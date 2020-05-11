if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}

Function ExitOnError ([string]$message) {
    Write-Error $message
    Read-Host -Prompt "Press Enter to continue"
    exit -1
}

$Supported = @{
    "B3448BF077665F2E1CA67094BCF2A7C5" = 0x14DE1;
    "DE5FA392A825332AB3E348EF0316B514" = 0x16A61;
    "F653C99D4A0C61D4B2C64358B8213BD8" = 0x15C11;
    "C8BC76C87563E78C9BC85EE9F4F96760" = 0x15C11;
}
$ChsIME = "ChsIME"
$ChsIMEExe = "${ChsIME}.exe"

# make sure CheIme.exe is the right version
$ChsImeExePath = "$env:windir\System32\InputMethod\CHS\$ChsIMEExe"
$ChsIMEHash = (Get-FileHash $ChsImeExePath -Algorithm MD5).Hash
$offsetAddr = $Supported[$ChsIMEHash]
if (-not $offsetAddr) {
    ExitOnError 'Unsupported ChsIme.exe'
}

Add-Type -MemberDefinition @'
[DllImport("kernel32.dll", SetLastError = true)]
  public static extern bool WriteProcessMemory(
  IntPtr hProcess,
  IntPtr lpBaseAddress,
  byte[] lpBuffer,
  Int32 nSize,
  out IntPtr lpNumberOfBytesWritten);
'@ -Name Kernel32 -Namespace Pinvoke


$i = 0
while ($i++ -lt 30) {
    $ps = Get-Process -Name $ChsIME
    foreach ($p in $ps) {
        $hModule = $p.Modules | Where-Object {$_.ModuleName -eq $ChsIMEExe}
        if (!$hModule) {
            continue
        }
        $hModule = $hModule[0]
        $addr = [IntPtr]::Add($hModule.BaseAddress, $offsetAddr)
        [Int32]$n = 0
        $pidd = $p.id
        if ([Pinvoke.Kernel32]::WriteProcessMemory($p.Handle[0], $addr, @(0x31, 0xc0), 2, [ref]$n)) {
            Write-Output "$pidd is patched"
        } else {
            ExitOnError "Failed to patch $pidd"
        }
    }
    if ($ps) {
        break
    }
    Start-Sleep -Milliseconds 100
}
