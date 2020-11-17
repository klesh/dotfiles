[CmdletBinding()]
param (
    [ValidateSet("Projects", "MarkRead")]
    [string]
    $CMD,
    [Parameter(Mandatory=$false)]
    [string]
    $PRO,
    [Parameter(Mandatory=$false)]
    [string]
    $ORG="malong",
    [Parameter(Mandatory=$false)]
    [string]
    $TOKEN="4ef37b6c118e44a499450fb996f2d58ef81faa46e2f14f38aadfa6d4ee0c4062"
)


function Projects {
    $PROJECTS_URL="https://sentry.malongtech.cn/api/0/projects/"
    while ($PROJECTS_URL) {
        $projectsRes = Invoke-WebRequest -Uri $PROJECTS_URL -Headers @{'Authorization'="Bearer $TOKEN"}
        $projects = $projectsRes.Content | ConvertFrom-Json
        if (-not $projects.Length) {
            break
        }
        foreach ($project in $projects) {
            Write-Host $project.id $project.name
        }
        $PROJECTS_URL=$projectsRes.Headers.Link
        if (-not $PROJECTS_URL.Length) {
            break
        }
        $PROJECTS_URL = $PROJECTS_URL[0].ToString()
        $PROJECTS_URL=$PROJECTS_URL.SubString(1, $PROJECTS_URL.IndexOf(";")-2)
    }
}


function MarkRead {
    $ISSUES_URL="https://sentry.malongtech.cn/api/0/projects/$ORG/$PRO/issues/"
    while ($true) {
        $issuesRes = Invoke-WebRequest -Uri $ISSUES_URL -Headers @{'Authorization'="Bearer $TOKEN"}
        $issues = $issuesRes.Content | ConvertFrom-Json
        if (-not $issues.Length) {
            break
        }
        $qs = $issues | Select-Object -Property id | %{"id=$($_.id)"} | Join-String -Separator "&"
        $deleteRes = Invoke-WebRequest -Uri "$($ISSUES_URL)?$qs" -Method Delete -Body @{'id'=$ids} -Headers @{'Authorization'="Bearer $TOKEN"}
        Write-Host "status: $($deleteRes.StatusCode) content: $($deleteRes.Content)"
    }
}

switch ($CMD) {
    "MarkRead" { MarkRead }
    Default { Projects }
}
