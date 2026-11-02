# One-time setup for the fixed staging links. Run it yourself: double-click setup-once.cmd.
# 1) Publishes this folder as the PUBLIC GitHub repo OhayouOhayouOhayou/pcs and turns on GitHub Pages.
#    The repo holds only the current trycloudflare addresses, never a password.
# 2) Adds "Weather staging" and "CCTV staging" to the Windows Startup folder so both start after you log in.
# Safe to run again: steps that are already done are skipped.

Set-Location $PSScriptRoot
$repo = 'OhayouOhayouOhayou/pcs'

Write-Host '1) GitHub repo and Pages'
gh repo view $repo *> $null
if ($LASTEXITCODE -ne 0) {
    gh repo create $repo --public --description 'Fixed links that forward to the current staging tunnels' --source . --remote origin --push
} else {
    git remote get-url origin *> $null
    if ($LASTEXITCODE -ne 0) { git remote add origin "https://github.com/$repo.git" }
    git push -u origin main
}
gh api "repos/$repo/pages" *> $null
if ($LASTEXITCODE -ne 0) { gh api -X POST "repos/$repo/pages" -f 'source[branch]=main' -f 'source[path]=/' | Out-Null }
Write-Host '   https://ohayouohayouohayou.github.io/pcs/weather/'
Write-Host '   https://ohayouohayouohayou.github.io/pcs/cctv/'
Write-Host '   (the first publish takes 1-2 minutes)'

Write-Host '2) Start both systems after Windows logon'
$startup = [Environment]::GetFolderPath('Startup')
$shell = New-Object -ComObject WScript.Shell
foreach ($item in @(
        @{ Name = 'Weather staging'; Target = 'D:\xampp1010\wether\staging\start-staging.cmd' },
        @{ Name = 'CCTV staging'; Target = 'D:\pooc\staging\start-staging.cmd' })) {
    $shortcut = $shell.CreateShortcut((Join-Path $startup "$($item.Name).lnk"))
    $shortcut.TargetPath = $item.Target
    $shortcut.WorkingDirectory = Split-Path $item.Target
    $shortcut.WindowStyle = 7   # minimized
    $shortcut.Save()
    Write-Host "   $($item.Name) -> $($item.Target)"
}
Write-Host '   To stop this later, delete the two shortcuts in:' $startup
Write-Host ''
Write-Host 'Done.'
