[CmdletBinding()]
param (
	[string]
	$Configuration = "Debug",

	[Parameter()]
	[string[]]
	$Parameters
)

function Step-Build() {
	$local:BuildScript = Join-Path -Path $PSScriptRoot -ChildPath "windows-build.ps1"

	& $BuildScript -Configuration $Configuration -Tests
	if ($LastExitCode -Ne 0) {
		exit $LastExitCode
	}
}

function Step-Test() {
	# Run CMake in the project:
	$local:RootFolder = Split-Path $PSScriptRoot
	$local:BuildFolder = Join-Path -Path $RootFolder -ChildPath "build"

	Write-Host "# Now running tests from '" -ForegroundColor Blue -NoNewline
	Write-Host $BuildFolder                 -ForegroundColor Cyan -NoNewline
	Write-Host "'."                         -ForegroundColor Blue

	Push-Location $BuildFolder
	ctest --build-config $Configuration --output-on-failure $Parameters
	Pop-Location
}

Step-Build
Step-Test

exit $LastExitCode
