[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $FontPath
)

Add-Type -AssemblyName PresentationCore

$face = New-Object System.Windows.Media.GlyphTypeface -ArgumentList "$(Resolve-Path $FontPath)"
$style = "$($face.Style)"
$weight = "$($face.Weight)"
$stretch = "$($face.Stretch)"

$name = $face.FamilyNames["en-US"] -replace '\W',''
if ($style -ne "Normal") {
    $name += "-$($style)"
}
if ($weight -ne "Normal") {
    $name += "-$($weight)"
}
if ($stretch -ne "Normal") {
    $name += "-$(stretch)"
}
$name