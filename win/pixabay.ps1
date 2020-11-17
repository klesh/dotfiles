[CmdletBinding()]
param (
    [Parameter(Mandatory=$false)]
    [string]
    $ApiKey='18224187-6d4fdb0c31aebbab0f814ab5d',

    [Parameter(Mandatory=$false)]
    [string]
    $Keyword,

    [Parameter(Mandatory=$false)]
    [string]
    $Id,

    [Parameter(Mandatory=$false)]
    [ValidateSet('all', 'photo', 'illustration', 'vector')]
    [string]
    $Type,

    [Parameter(Mandatory=$false)]
    [ValidateSet('all', 'horizontal', 'vertical')]
    [string]
    $Orientation,

    [Parameter(Mandatory=$false)]
    [ValidateSet(
        'backgrounds',
        'fashion',
        'nature',
        'science',
        'education',
        'feelings',
        'health',
        'people',
        'religion',
        'places',
        'animals',
        'industry',
        'computer',
        'food',
        'sports',
        'transportation',
        'travel',
        'buildings',
        'business',
        'music'
    )]
    [string]
    $Category,

    [Parameter(Mandatory=$false)]
    [int]
    $MinWidth=0,


    [Parameter(Mandatory=$false)]
    [int]
    $MinHeight=0,

    [Parameter(Mandatory=$false)]
    [ValidateSet(
        "grayscale",
        "transparent",
        "red",
        "orange",
        "yellow",
        "green",
        "turquoise",
        "blue",
        "lilac",
        "pink",
        "white",
        "gray",
        "black",
        "brown"
    )]
    [string[]]
    $Colors,

    [Parameter(Mandatory=$false)]
    [bool]
    $EditorsChoiceOnly=$false,

    [Parameter(Mandatory=$false)]
    [bool]
    $SafeForWorkOnly=$false,

    [Parameter(Mandatory=$false)]
    [ValidateSet("popular", "latest")]
    [string]
    $Order='popular',

    [Parameter(Mandatory=$false)]
    [int]
    $Page=1,

    [Parameter(Mandatory=$false)]
    [ValidateRange(3, 200)]
    [int]
    $Size=50,

    [Parameter(Mandatory=$false)]
    [string]
    $OutFile,

    [Parameter(Mandatory=$false)]
    [string]
    $OutDir,

    [Parameter(Mandatory=$false)]
    [bool]
    $OutDirWithType=$true
)

if ($OutDir -and -not $OutFile) {
    $OutFile
}

function Save-Hit {
    param (
        [Parameter()]
        [PSCustomObject]
        $hit
    )

    $FilePath = $OutFile
    if (-not $FilePath) {
        $FilePath = $OutDir
        if ($OutDirWithType) {
            $FilePath = Join-Path $FilePath ($hit.type -replace '\W+','_' )
        }
        if (-not (Test-Path $FilePath)) {
            New-Item -ItemType Directory $FilePath | Out-Null
        }
        $FileName = ($hit.id.ToString() + '_' +
            ($hit.tags -split ", " | %{ $_ -replace '\s+','-' } | Join-String -Separator '_') +
            '.' + $hit.largeImageURL.Split('.')[-1])
        $FilePath = Join-Path $FilePath  $FileName
    }
    $msg = "saving $($hit.id) to $FilePath"
    Write-Host $msg.PadRight(100) -NoNewline
    if (Test-Path $FilePath) {
        Write-Host "[SKIP]"
    } else {
        $job = Start-Job -ScriptBlock {
            try {
                Invoke-WebRequest -TimeoutSec 5 -Uri $args[0] -OutFile $args[1]
                $true
            } catch {
                $false
            }
        } -ArgumentList $hit.largeImageURL,$FilePath
        $fg = 'red'
        $tx = '[TIMEOUTED]'
        if (Wait-Job $job -Timeout 20) {
            $ok = Receive-Job $job
            $fg = $ok ? 'green' : 'red'
            $tx = $ok ? '[OK]' : '[Failed]'
        }
        Remove-Job -force $job
        Write-Host -ForegroundColor $fg $tx
    }

}


[System.Net.ServicePointManager]::MaxServicePointIdleTime = 5
$Res = Invoke-WebRequest -TimeoutSec 5 -Uri https://pixabay.com/api/ -Body @{
    key = $ApiKey;
    q = $Keyword;
    id = $Id;
    image_type = $Type;
    orientation = $Orientation;
    category = $Category;
    min_width = $MinWidth;
    min_height = $MinHeight;
    colors = $Colors;
    editors_choice = $EditorsChoiceOnly;
    safesearch = $SafeForWorkOnly;
    order = $Order;
    page = $Page;
    per_page = $Size;
} | ConvertFrom-Json

Write-Host "Total $($res.total)   Accessible $($res.totalHits)"

$Listing = -not $OutFile -and -not $OutDir

if ($Res.hits.Length -eq 1) {
    if ($Listing) {
        $Res.hits[0]
    } else {
        Save-Hit $Res.hits[0]
    }
} else {
    if ($Listing) {
        $Res.hits | Select-Object -Property id,type,largeImageURL | Format-Table
    } else {
        $Res.hits | %{ Save-Hit $_ }
        # Save-Hit $Res.hits[0]
    }
}
