# Points one fixed GitHub Pages link at a new Cloudflare quick-tunnel address.
# Usage: update-link.ps1 -Name cctv -Url https://xxxx.trycloudflare.com
# Both staging scripts call this after their tunnel starts; retries cover a slow network at logon
# and two scripts pushing at the same moment.
param(
    [Parameter(Mandatory = $true)] [ValidateSet('cctv', 'weather')] [string] $Name,
    [Parameter(Mandatory = $true)] [ValidatePattern('^https://[a-z0-9-]+\.trycloudflare\.com$')] [string] $Url
)

Set-Location $PSScriptRoot
$file = Join-Path $PSScriptRoot 'targets.json'

for ($attempt = 1; $attempt -le 10; $attempt++) {
    git pull --rebase --quiet origin main
    if ($LASTEXITCODE -eq 0) {
        $targets = Get-Content $file -Raw | ConvertFrom-Json
        $entry = [pscustomobject]@{ url = $Url; updated = (Get-Date).ToString('yyyy-MM-ddTHH:mm:sszzz') }
        if ($targets.PSObject.Properties[$Name]) { $targets.$Name = $entry }
        else { $targets | Add-Member -NotePropertyName $Name -NotePropertyValue $entry }
        [IO.File]::WriteAllText($file, ($targets | ConvertTo-Json -Depth 3) + "`n")
        git add targets.json
        git commit --quiet -m "Point $Name at the current tunnel"
        git push --quiet origin main
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Fixed $Name link now forwards to $Url"
            exit 0
        }
        # Someone else pushed first: drop this commit and redo it on top of theirs.
        git reset --quiet --hard origin/main
    }
    Start-Sleep -Seconds ([Math]::Min(60, 5 * $attempt))
}
Write-Host "Could not update the fixed $Name link on GitHub; the trycloudflare link still works."
exit 1
