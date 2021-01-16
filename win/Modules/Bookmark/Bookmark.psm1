$BOOKMARK_PATH = "~\Nextcloud\bookmarks.md"

function Get-Bookmark {
    [CmdletBinding()]
    param(
            [string[]] $args
         )

    $categories = [System.Collections.ArrayList] @()
    $names = [System.Collections.ArrayList] @()
    foreach ($arg in $args) {
        if ($arg.StartsWith('#')) {
            [void]$categories.Add($arg)
        } else {
            [void]$names.Add($arg)
        }
    }
    Get-Content $BOOKMARK_PATH | FilterByCategory $categories | FilterByName $names
}

function Open-Bookmark {
    [CmdletBinding()]
    param(
            [string[]] $urls
         )
    if ($urls.Length -eq 0) {
        SearchBookmark
    } else {
        Get-Bookmark $urls | OpenUrls
    }
}

function FilterByCategory {
    [CmdletBinding()]
    param(
            [string[]] $categories,
            [Parameter(Mandatory, ValueFromPipeline)] [array] $lines
         )

    BEGIN {
        $current_indent = 0
    }
    PROCESS {
        foreach ($line in $lines) {
            if ($line -match '^(#+) (.*)$') {
                $heading_indent = $matches[1].Length
                if ($current_indent -eq 0) {
                    if ($categories.Contains("$line")) {
                        $current_indent = $heading_indent
                    }
                } else {
                    if ($heading_indent -le $current_indent) {
                        $current_indent = 0
                    }
                }
            }
            if ($current_indent -gt 0) {
                echo $line
            }
        }
    }
}

function FilterByName {
    param(
            [string[]] $names,
            [Parameter(ValueFromPipeline)] [array] $lines
         )

    BEGIN {
        $pattern = $names -join "|"
    }
    PROCESS {
        if ($names.Length -eq 0) {
            return $lines
        }
        foreach ($line in $lines) {
            if ($line -match $pattern) {
                echo $line
            }
        }
    }
}

function OpenUrls {
    param(
            [Parameter(ValueFromPipeline)] [array] $lines
         )

    PROCESS {
        foreach ($line in $lines) {
            if ($line -match '\[(.*?)\]\((.*?)\)') {
                start $matches[2]
            }
        }
    }
}

function SearchBookmark {
    $query = Get-Content $BOOKMARK_PATH | Where {$_.Length -gt 0} | fzf
    if ($query.Length -eq 0) {
        return
    }
    if ($query -match '^#') {
        Open-Bookmark $query
    } else {
        @($query) | OpenUrls
    }
}

Export-ModuleMember -Function Get-Bookmark,Open-Bookmark,FilterByCategory,FilterByName,OpenUrls,SearchBookmark

