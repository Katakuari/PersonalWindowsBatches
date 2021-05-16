# 11.05.2021
Set-Location A:
$foldersToArchive = "Docs", "Bilder"
$archiveDest = "C:\Users\katak\OneDrive\Archives"
$7zpw = Get-Content ".\7z"

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


foreach ($folder in $foldersToArchive) {
	& $7z a -t7z -mx9 -mmt6 -mhe -p"$7zpw" "$archiveDest\$(Get-Date -Format yyyy-MM-dd)_$folder.zip" "A:\$folder\"
}

Get-ChildItem -Path "$archiveDest" -Force | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-60) } | Remove-Item -Force -Verbose

#Pause