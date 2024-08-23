#!/usr/bin/env pwsh
$ErrorActionPreference = 'Stop'

$Modules = $null
if ([string]::IsNullOrWhiteSpace($env:INPUT_MODULEPATH)) {
    $Modules = Get-ChildItem -Recurse -Filter '*.psd1' |
        Select-Object -Unique -ExpandProperty Directory
} else {
    $Modules = @($env:INPUT_MODULEPATH)
}

$Modules | ForEach-Object {
    Write-Host "Publishing '$_' to PowerShell Gallery"

    $Params = @{
        Path                       = $_
        Repository                 = "PSGallery"
        ApiKey                     = $env:INPUT_NUGETAPIKEY
        SkipModuleManifestValidate = $true
    }

    Publish-PSResource @Params
    Write-Host "'$_' published to PowerShell Gallery"
}
