[CmdletBinding()]
param (
	[switch]
	$Tests,

	[string]
	$Configuration = "Debug"
)

# Asserts that the variable assigned to $CMake is a valid file path, discarding files that do not exist and folders.
function Assert-CMakePath([string] $CMake) {
	if (($CMake -Eq "") -Or !(Test-Path -LiteralPath $CMake -PathType Leaf)) {
		Write-Host "I was not able to find cmake.exe, please download the binary at https://cmake.org." -ForegroundColor Red
		exit 1
	}

	return $CMake
}

# Find and assert CMake
function Step-Configure([string] $CMake, [string] $Path) {
	Write-Host "# Generating CMake Project for '" -ForegroundColor Blue -NoNewline
	Write-Host $Path                              -ForegroundColor Cyan -NoNewline
	Write-Host "'."                               -ForegroundColor Blue

	$local:Parameters = @("-S", "$Path", "-B", "$Path\build", "-Wno-dev")

	# If -Tests is present, append INTERNATIONALIZATION_BUILD_TESTS to the flags.
	if ($Tests.IsPresent) {
		$Parameters = $Parameters + "-DINTERNATIONALIZATION_BUILD_TESTS=ON"
	}

	# Run the process
	& $CMake $Parameters

	if ($LastExitCode -Ne 0) {
		Write-Host "# Errored when generating '" -ForegroundColor Red  -NoNewLine
		Write-Host $Path                         -ForegroundColor Cyan -NoNewLine
		Write-Host "' with code $LastExitCode."  -ForegroundColor Red
		exit 1
	}
}

# Build a CMake-generated project given a path and optional arguments
function Step-Build([string] $CMake, [string] $Path) {
	Write-Host "# Now building '"     -ForegroundColor Blue -NoNewline
	Write-Host $Path                  -ForegroundColor Cyan -NoNewline
	Write-Host "' as $Configuration." -ForegroundColor Blue

	$local:Parameters = @("--build", "$Path", "--config", "$Configuration", "-j", "--", "-m", "-noLogo")

	# Run the process
	& $CMake $Parameters

	if ($LastExitCode -Ne 0) {
		Write-Host "# Errored when building '"  -ForegroundColor Red  -NoNewLine
		Write-Host $Path                        -ForegroundColor Cyan -NoNewLine
		Write-Host "' with code $LastExitCode." -ForegroundColor Red
		exit 1
	}
}

$local:CMake = Assert-CMakePath (Get-Command "cmake.exe" -ErrorAction SilentlyContinue).Path

# Run CMake in the project:
$local:RootFolder = Split-Path $PSScriptRoot
Step-Configure -CMake $CMake -Path $RootFolder

# Run CMake Build to the built project:
$local:BuildFolder = Join-Path -Path $RootFolder -ChildPath "build"
Step-Build -CMake $CMake -Path $BuildFolder
