param (
    [parameter(Mandatory=$false)] [switch] $Delete,
    [parameter(Mandatory=$false)] [string] $OutFormat=".mkv",
    [parameter(Mandatory=$true, Position=0)] [string] $InPath,
    [parameter(Mandatory=$true, Position=1)] [string] $OutPath
)

if (-not (Test-Path -LiteralPath $InPath -Type Leaf)) {
    Write-Error "Invalid Input File Path $($InPath)"
    exit
}

if (-not (Test-Path -LiteralPath $OutPath)) {
    Write-Error "Invalid Output Path $($OutPath)"
    exit
}
if (Test-Path -LiteralPath $OutPath -PathType Container) {
    $OutPath = Join-Path $OutPath ((Split-Path -Leaf $InPath) + $OutFormat)
}

$ConvertedInPath = Convert-Path -LiteralPath $InPath
$InDrive = "bluray:$((Mount-DiskImage $ConvertedInPath | Get-Volume).DriveLetter):\\"
ffmpeg.exe -i $InDrive -c:v copy $OutPath
Dismount-DiskImage $ConvertedInPath
if ($Delete) {
    Remove-Item -LiteralPath $InPath
}