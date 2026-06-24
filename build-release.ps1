param(
    [ValidateSet("Debug", "Release")]
    [string] $Configuration = "Release",

    [string] $OutputDirectory = "",

    [string[]] $AgentLocations = @("Test", "Aprang"),

    [string] $AndroidSdkDirectory = "$env:LOCALAPPDATA\Android\Sdk",

    [string] $JavaSdkDirectory = "$env:LOCALAPPDATA\Android\jdk-17"
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path $PSScriptRoot
if ([string]::IsNullOrWhiteSpace($OutputDirectory)) {
    $OutputDirectory = $repoRoot
}

$outputPath = [System.IO.Path]::GetFullPath($OutputDirectory)
$buildPath = Join-Path $repoRoot ".build-temp"

$clientAgentProject = Join-Path $repoRoot "apps\client-agent\PisonetManager.Agent\PisonetManager.Agent.csproj"
$desktopProject = Join-Path $repoRoot "apps\frontend-dashboard-windows\PisonetManager.Desktop\PisonetManager.Desktop.csproj"
$androidProject = Join-Path $repoRoot "apps\frontend-dashboard-android\PisonetManager.Android\PisonetManager.Android.csproj"

function Invoke-Step {
    param(
        [string] $Name,
        [scriptblock] $Action
    )

    Write-Host ""
    Write-Host "==> $Name" -ForegroundColor Cyan
    & $Action
}

function Copy-RequiredFile {
    param(
        [string] $Source,
        [string] $Destination
    )

    if (-not (Test-Path $Source)) {
        throw "Expected file was not found: $Source"
    }

    Copy-Item -LiteralPath $Source -Destination $Destination -Force
    Write-Host "Copied $Destination"
}

Invoke-Step "Preparing output folder" {
    New-Item -ItemType Directory -Force -Path $outputPath | Out-Null
    New-Item -ItemType Directory -Force -Path $buildPath | Out-Null
}

foreach ($agentLocation in $AgentLocations) {
    Invoke-Step "Publishing client agent ($agentLocation)" {
        $agentPublishPath = Join-Path $buildPath "client-agent\$agentLocation"
        dotnet publish $clientAgentProject `
            -c $Configuration `
            -o $agentPublishPath `
            -p:AgentLocation=$agentLocation

        $agentLabel = $agentLocation -replace "[^A-Za-z0-9]+", "-"
        $agentLabel = $agentLabel.Trim("-")
        Copy-RequiredFile `
            -Source (Join-Path $agentPublishPath "PisonetManager.Agent.exe") `
            -Destination (Join-Path $outputPath "PisonetManager.Agent.$agentLabel.exe")
    }
}

Invoke-Step "Publishing Windows desktop dashboard" {
    $desktopPublishPath = Join-Path $buildPath "desktop-dashboard"
    dotnet publish $desktopProject `
        -c $Configuration `
        -o $desktopPublishPath

    Copy-RequiredFile `
        -Source (Join-Path $desktopPublishPath "PisonetManager.Desktop.exe") `
        -Destination (Join-Path $outputPath "PisonetManager.Desktop.exe")
}

Invoke-Step "Building Android dashboard APK" {
    $androidBuildArgs = @(
        "build",
        $androidProject,
        "-c",
        $Configuration,
        "-p:AndroidPackageFormat=apk"
    )

    if (-not [string]::IsNullOrWhiteSpace($AndroidSdkDirectory)) {
        $androidBuildArgs += "-p:AndroidSdkDirectory=$AndroidSdkDirectory"
    }

    if (-not [string]::IsNullOrWhiteSpace($JavaSdkDirectory)) {
        $androidBuildArgs += "-p:JavaSdkDirectory=$JavaSdkDirectory"
    }

    dotnet @androidBuildArgs

    $androidProjectDirectory = Split-Path $androidProject -Parent
    $signedApkCandidatePaths = @(
        "bin\$Configuration\net8.0-android\com.pisonetmanager.dashboard-Signed.apk",
        "bin\$Configuration\net8.0-android\android-arm64\publish\com.pisonetmanager.dashboard-Signed.apk",
        "bin\$Configuration\net8.0-android\android-arm64\com.pisonetmanager.dashboard-Signed.apk"
    )

    $signedApkCandidates = $signedApkCandidatePaths |
        ForEach-Object { Join-Path $androidProjectDirectory $_ }
    $signedApk = $signedApkCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
    if ([string]::IsNullOrWhiteSpace($signedApk)) {
        throw "Android build completed, but no signed APK was found."
    }

    Copy-RequiredFile `
        -Source $signedApk `
        -Destination (Join-Path $outputPath "PisonetManager.Dashboard.Android.apk")
}

Invoke-Step "Removing temporary build files" {
    if (Test-Path $buildPath) {
        Remove-Item -LiteralPath $buildPath -Recurse -Force
    }
}

Write-Host ""
Write-Host "Release files are ready in: $outputPath" -ForegroundColor Green
Get-ChildItem -LiteralPath $outputPath | Select-Object Name, Length, LastWriteTime
