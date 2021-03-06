# 11.05.2021

$parentdir = Split-Path $Script:MyInvocation.MyCommand.Path
$foldersToArchive = "Docs", "Bilder"		# Folders/paths of files to archive 
$archiveDest = "$env:OneDrive\Archives"		# Destination of the created archives
$7zpw = Get-Content "$parentdir\7z"			# Get contents of "7z" for PSDrive Root (first line) and 7zip archive password (second line)

New-PSDrive -Name "A" -PSProvider "FileSystem" -Root "$($7zpw[0])" -Persist # Create new PSDrive with path specified

# 7zip installation check
if (Test-Path "$env:ProgramFiles\7-Zip\7z.exe") {
	$7z = "$env:ProgramFiles\7-Zip\7z.exe"
}
else {
	if (Test-Path "${env:ProgramFiles(x86)}\7-Zip\7z.exe") {
		$7z = "${env:ProgramFiles(x86)}\7-Zip\7z.exe"
	}
 else {
		Write-Host "7-Zip could not be found in Program Files`nPlease download and install it from: https://www.7-zip.org/" -ForegroundColor Red
		Pause
		Exit
	}
}

# Create archive for every folder specified in foldersToArchive variable
# More info on 7zip command line: https://sevenzip.osdn.jp/chm/cmdline/index.htm
foreach ($folder in $foldersToArchive) {
	& $7z a -t7z -mx9 -mmt6 -mhe -p"$($7zpw[1])" "$archiveDest\$(Get-Date -Format yyyy-MM-dd)_$folder" "A:\$folder\"
}

# Delete archives older than 60 days
Get-ChildItem -Path "$archiveDest" -Force | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-60) } | Remove-Item -Force -Verbose

Remove-PSDrive -Name "A" -Force 	# Remove the created PSDrive

#Pause
Exit