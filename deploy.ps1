# build.ps1

$source = ".\src"
$destination = "C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\grm-whisper"

# Remove old version
if (Test-Path $destination) {
    Remove-Item $destination -Recurse -Force
}

# Copy new version
Copy-Item $source -Destination $destination -Recurse

Write-Host "✅ Addon deployed to WoW AddOns folder."
