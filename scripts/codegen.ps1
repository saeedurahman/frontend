<#
 Regenerates every generated file (*.g.dart, *.freezed.dart, app_database.g.dart,
 injection.config.dart) with the versions pinned in pubspec.lock.

 Usage:  powershell -File scripts/codegen.ps1 [-Clean]
   -Clean  also wipes .dart_tool/build first (use after changing generator versions)
#>
param([switch]$Clean)
$ErrorActionPreference = 'Stop'
Set-Location (Split-Path $PSScriptRoot -Parent)

flutter pub get
if ($LASTEXITCODE -ne 0) { throw 'flutter pub get failed' }

if ($Clean) {
  if (Test-Path .dart_tool/build) { Remove-Item .dart_tool/build -Recurse -Force }
}

dart run build_runner build --delete-conflicting-outputs
if ($LASTEXITCODE -ne 0) { throw 'build_runner failed' }
Write-Host 'Code generation finished.'
