<#
 CI check: regenerate everything and fail when the committed generated files
 are not exactly what the generators produce (i.e. someone hand-edited them,
 or forgot to regenerate after changing an annotation).

 Usage:  powershell -File scripts/check_generated.ps1
 Exit code 0 = generated files are up to date, 1 = they differ.
#>
$ErrorActionPreference = 'Stop'
Set-Location (Split-Path $PSScriptRoot -Parent)

$before = git status --porcelain -- '*.g.dart' '*.freezed.dart' 'lib/core/di/injection.config.dart'
if ($before) {
  Write-Host 'Uncommitted changes in generated files already exist; commit or stash them first:'
  Write-Host $before
  exit 1
}

& "$PSScriptRoot/codegen.ps1"
if ($LASTEXITCODE -ne 0) { exit 1 }

$after = git status --porcelain -- '*.g.dart' '*.freezed.dart' 'lib/core/di/injection.config.dart'
if ($after) {
  Write-Host 'Generated files are out of date or were hand-edited:'
  Write-Host $after
  git --no-pager diff --stat -- '*.g.dart' '*.freezed.dart' 'lib/core/di/injection.config.dart'
  exit 1
}
Write-Host 'Generated files are up to date.'
exit 0
