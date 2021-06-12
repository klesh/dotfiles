$PASSWORD_STORE_DIR = (Get-Item "~\.password-store").FullName

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
            [String] $PassPath
         )

    if (!$PassPath) {
        throw "path is empty!"
    }

    $PassPath = Join-Path $PASSWORD_STORE_DIR $PassPath
    if (!$PassPath.EndsWith(".gpg")) {
        $PassPath = $PassPath + ".gpg"
    }
    $dir = Split-Path $PassPath
    if (!$dir) {
        $dir = "."
    }
    if (!(Test-Path -PathType Container $dir)) {
        New-Item -ItemType Directory -Path $dir
    }
    return $PassPath
}

function GetUid {
    if ((gpg --list-secret-keys | findstr uid) -match '<(.*?)>') {
        $matches[1]
    } else {
        throw "unable to find default uid"
    }
}

function FzfPass {
    Get-ChildItem $PASSWORD_STORE_DIR -Recurse -Filter *.gpg | %{
        $_.FullName.SubString(
                $PASSWORD_STORE_DIR.Length+1,
                $_.FullName.Length-$PASSWORD_STORE_DIR.Length-5
                )
    } | fzf
}

function Edit-Pass {
    [Cmdletbinding()]
    param(
            [String] $PassPath
         )

    if (!$PassPath) {
        $PassPath = FzfPass
        if (!$?) {
            return
        }
    }

    $PassPath = EnsurePath $PassPath

    $tmpfile = (New-TemporaryFile).FullName
    gpg --decrypt $PassPath > $tmpfile
    nvim $tmpfile

    if ($?) {
        gpg -r (GetUid) -o "$tmpfile.gpg" --encrypt $tmpfile
        Move-Item -Path "$tmpfile.gpg" -Destination "$PassPath" -Force
        Remove-Item $tmpfile -Force
    }
}

function New-Pass {
  [Cmdletbinding()]
  param(
          [Parameter(Mandatory=$true)] [String] $PassPath
       )

  $PassPath = EnsurePath $PassPath
  $pass = GeneratePassword
  if (Test-Path -PathType Leaf $PassPath) {
      $text = gpg --decrypt $PassPath
      if ($text -is [string]) {
        $text = @($pass)
      } else {
        $text[0] = $pass
      }
      Remove-Item $PassPath -Force
  } else {
      $text = @($pass)
  }
  $text | gpg -r (GetUid) -o $PassPath --encrypt -
  Set-Clipboard $pass
  Write-Host $pass
  Write-Host "new password is saved and copied to Clipboard"
}

function Get-Pass {
  [Cmdletbinding()]
  param(
          [Parameter(Mandatory=$true)] [String] $PassPath,
          [Bool] $Clipboard=$true
       )

  $PassPath = EnsurePath $PassPath
  if ($Clipboard) {
      $pass = gpg --decrypt $PassPath | Select -First 1
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
  $selected = FzfPass

  if ($selected) {
      Get-Pass $selected
  }
}

function Find-Login {
  $selected = FzfPass

  if ($selected) {
      $login = Split-Path -Leaf $selected
      Write-Host $login
      Set-Clipboard $login
  }
}

Export-ModuleMember -Function Edit-Pass,New-Pass,Get-Pass,Find-Pass,Find-Login

