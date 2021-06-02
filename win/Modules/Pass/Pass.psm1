$PASSWORD_STORE_DIR = Get-Item "~\.password-store"

function GeneratePassword {
    param(
            [Int] $Size = 10,
            [Char[]] $Charsets = "ULNS",
            [Char[]] $Exclude
         )

    $Chars = @(); $TokenSet = @()
    If (!$TokenSets) {
        $Global:TokenSets = @{
            U = [Char[]]'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
            L = [Char[]]'abcdefghijklmnopqrstuvwxyz'
            N = [Char[]]'0123456789'
            S = [Char[]]'!"#$%&''()*+,-./:;<=>?@[\]^_`{|}~'
        }
    }
    $CharSets | ForEach {
        $Tokens = $TokenSets."$_" | ForEach {If ($Exclude -cNotContains $_) {$_}}
        If ($Tokens) {
            $TokensSet += $Tokens
            If ($_ -cle [Char]"Z") {$Chars += $Tokens | Get-Random}
        }
    }
    While ($Chars.Count -lt $Size) {$Chars += $TokensSet | Get-Random}
    return ($Chars | Sort-Object {Get-Random}) -Join ""
}

function EnsurePath {
    param(
            [String] $Path
         )

    $dir = Split-Path $Path
    if (!$dir) {
        $dir = "."
    }
    if (!(Test-Path -PathType Container $dir)) {
        New-Item -ItemType Directory -Path $dir
    }
    if (!$Path.EndsWith(".gpg")) {
        $Path = $Path + ".gpg"
    }
    Join-Path $PASSWORD_STORE_DIR.FullName $Path
}

function GetUid {
    if ((gpg --list-secret-keys | findstr uid) -match '<(.*?)>') {
        $matches[1]
    } else {
        throw "unable to find default uid"
    }
}

function Edit-Pass {
    [Cmdletbinding()]
    param(
            [Parameter(Mandatory=$true)] [String] $Path
         )

    $Path = EnsurePath($Path)
    echo $Path

    $tmpfile = (New-TemporaryFile).FullName
    gpg --decrypt $Path > $tmpfile
    nvim $tmpfile

    if ($?) {
        gpg -r (GetUid) -o "$tmpfile.gpg" --encrypt $tmpfile
        Move-Item -Path "$tmpfile.gpg" -Destination "$Path" -Force
        Remove-Item $tmpfile -Force
    }
}

function New-Pass {
  [Cmdletbinding()]
  param(
          [Parameter(Mandatory=$true)] [String] $Path
       )

  $Path = EnsurePath $Path
  $pass = GeneratePassword
  if (Test-Path -PathType Leaf $Path) {
      $text = gpg --decrypt $Path
      $text[0] = $pass
  } else {
      $text = @($pass)
  }
  Remove-Item $Path -Force
  $text | gpg -r (GetUid) -o $Path --encrypt -
  Set-Clipboard $pass
  Write-Host $pass
  Write-Host "new password is saved and copied to Clipboard"
}

function Get-Pass {
  [Cmdletbinding()]
  param(
          [Parameter(Mandatory=$true)] [String] $Path,
          [Bool] $Clipboard=$true
       )

  $Path = EnsurePath $Path
  if ($Clipboard) {
      $pass = gpg --decrypt $Path | Select -First 1
      if ($pass) {
          Set-Clipboard $pass
          Write-Host "password is copied to Clipboard successfully"
          #TODO clear clipboard after centain period
      } else {
          throw "password is empty"
      }
  } else {
      Write-Host $pass
  }
}

function Find-Pass {
  $selected = Get-ChildItem $PASSWORD_STORE_DIR -Recurse -Filter *.gpg | %{
      $_.FullName.SubString(
              $PASSWORD_STORE_DIR.FullName.Length+1,
              $_.FullName.Length-$PASSWORD_STORE_DIR.FullName.Length-5
              )
  } | Invoke-Fzf

  if ($selected) {
      Get-Pass $selected
  }
}

Export-ModuleMember -Function Edit-Pass,New-Pass,Get-Pass,Find-Pass

