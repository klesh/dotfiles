
function Get-Font{
    [CmdletBinding()]
    param(
            [string] $keyword
         )

    [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
    $families = (New-Object System.Drawing.Text.InstalledFontCollection).Families
    foreach ($family in $families) {
        if (-not $keyword || $family.Name.Contains($keyword)) {
            echo $family.Name
        }
    }
}

Export-ModuleMember -Function Get-Font

