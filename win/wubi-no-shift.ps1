#Requires -RunAsAdministrator

Import-Module PSReflect-Functions

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
    throw [System.Exception] "Unsupported ChsIme.exe"
}
echo "Offset Address: $offsetAddr"

# reference
<#
    public enum ProcessAccessFlags : uint
    {
        All = 0x001F0FFF,
        Terminate = 0x00000001,
        CreateThread = 0x00000002,
        VirtualMemoryOperation = 0x00000008,
        VirtualMemoryRead = 0x00000010,
        VirtualMemoryWrite = 0x00000020,
        DuplicateHandle = 0x00000040,
        CreateProcess = 0x000000080,
        SetQuota = 0x00000100,
        SetInformation = 0x00000200,
        QueryInformation = 0x00000400,
        QueryLimitedInformation = 0x00001000,
        Synchronize = 0x00100000
    }
    public enum SnapshotFlags : uint
    {
        HeapList = 0x00000001,
        Process  = 0x00000002,
        Thread   = 0x00000004,
        Module   = 0x00000008,
        Module32 = 0x00000010,
        All      = (HeapList | Process | Thread | Module),
        Inherit  = 0x80000000,
        NoHeaps = 0x40000000

    }
#>


$ps = Get-Process -Name $ChsIME
foreach ($p in $ps) {
    $hProcess = Get-Process -Name $ChsIme
    if (!$hProcess) {
        throw [System.Exception] "Unable to open process $pid";
    }
    $hModule = $hProcess.Modules | Where-Object {$_.ModuleName -eq $ChsIMEExe}
    if (!$hModule) {
        continue
    }
    $hModule = $hModule[0]
    $addr = [IntPtr]::Add($hModule.BaseAddress, $offsetAddr)
    [Int32]$n = 0
    [PSReflectFunctions.kernel32]::WriteProcessMemory($hProcess.Handle[0], $addr, @(0x31, 0xc0), 2, [ref]$n)
}
