$rev = "1.0"
$revSuffix="_v$rev"
$timestamp = Get-Date -Format "dd/MM/yyyy HH:mm"

$devFolderName = 'tdm-fm-inplainsight'
$missionName = 'inplainsight'
$missionDir = "C:\games\darkmod\fms\$devFolderName"
$stagingDir = 'C:\Temp\dm_staging'
$stagingMissionDir = "$stagingDir\$devFolderName"
$darkmodtxt = "$stagingMissionDir\darkmod.txt"
$readme = "$stagingMissionDir\readme.txt"

$pkg = "$stagingMissionDir\$missionName$revSuffix"

$dmap = Read-Host -Prompt 'Did you delete and recompile the map files?'
if ( $dmap -notin "Y","y") {
    exit 1
}

$playerStart = Read-Host -Prompt 'Did you reset the player start position?'
if ( $playerStart -notin "Y","y") {
    exit 1
}

$masterKey = Read-Host -Prompt 'Did you disable the master key?'
if ( $masterKey -notin "Y","y") {
    exit 1
}

# clean staging directory and copy latest code
remove-item -path $stagingDir\* -Filter * -Force -Recurse
copy-item -path $missionDir -destination $stagingDir -recurse

# remove unwanted files
remove-item -path $stagingMissionDir -include .git,savegames,.gitignore,.github,build.ps1,changelog.txt,consolehistory.dat,dmx.darkradiant,dmx.bak,dmx.darkradiant.bak,dmx.xd.bkup,README.md -Force -Recurse

# token replace version
(Get-Content $darkmodtxt).replace('[VERSION]', $rev) | Set-Content $darkmodtxt 
(Get-Content $readme).replace('[VERSION]', $rev) | Set-Content $readme 
(Get-Content $readme).replace('[TIMESTAMP]', $timestamp) | Set-Content $readme 

# compress and rename main pk4
$compress = @{
    Path = "$stagingMissionDir\*"
    CompressionLevel = "Optimal"
    DestinationPath = "$pkg.zip"
}
Compress-Archive @compress
rename-item -path "$pkg.zip" -newname "$pkg.pk4"

