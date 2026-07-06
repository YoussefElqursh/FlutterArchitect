param(
  [Parameter(Mandatory = $true)]
  [string]$FeatureName
)

$FeatureClassName = ($FeatureName -split '_|-|\s' | ForEach-Object {
    if ($_ -ne "") {
        $_.Substring(0,1).ToUpper() + $_.Substring(1).ToLower()
    }
}) -join ""

# ---------------------------------------------------------
#  Banner
# ---------------------------------------------------------
Write-Host ""
Write-Host "╔════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║        FLUTTER CLEAN ARCHITECTURE GENERATOR    ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Feature Name  : " -NoNewline -ForegroundColor DarkGray
Write-Host "$FeatureName" -ForegroundColor Yellow
Write-Host "  Class Name    : " -NoNewline -ForegroundColor DarkGray
Write-Host "$FeatureClassName" -ForegroundColor Yellow
Write-Host ""

$folders = @(
"lib/features/$FeatureName",

"lib/features/$FeatureName/data",
"lib/features/$FeatureName/data/datasources",
"lib/features/$FeatureName/data/datasources/remote",
"lib/features/$FeatureName/data/datasources/local",
"lib/features/$FeatureName/data/models",
"lib/features/$FeatureName/data/repositories",

"lib/features/$FeatureName/domain",
"lib/features/$FeatureName/domain/entities",
"lib/features/$FeatureName/domain/repositories",
"lib/features/$FeatureName/domain/usecases",

"lib/features/$FeatureName/presentation",
"lib/features/$FeatureName/presentation/bloc",
"lib/features/$FeatureName/presentation/pages",
"lib/features/$FeatureName/presentation/widgets"
)

# ---------------------------------------------------------
#  Create folders
# ---------------------------------------------------------
Write-Host "▶ Creating folder structure..." -ForegroundColor Magenta

foreach ($folder in $folders)
{
  if (!(Test-Path $folder))
  {
    New-Item -ItemType Directory -Path $folder | Out-Null
    Write-Host "   + " -NoNewline -ForegroundColor DarkGreen
    Write-Host "$folder" -ForegroundColor Gray
  }
}

Write-Host ""

$files = [ordered]@{
    "lib/features/$FeatureName/data/datasources/local/${FeatureName}_local_datasource.dart" = @"
abstract class ${FeatureClassName}LocalDatasource {}

class ${FeatureClassName}LocalDatasourceImpl extends ${FeatureClassName}LocalDatasource {}
"@

  "lib/features/$FeatureName/data/datasources/remote/${FeatureName}_remote_datasource.dart" = @"
abstract class ${FeatureClassName}RemoteDatasource {}

class ${FeatureClassName}RemoteDatasourceImpl extends ${FeatureClassName}RemoteDatasource {}
"@

  "lib/features/$FeatureName/data/repositories/${FeatureName}_repository_impl.dart" = @"
import '../../domain/repositories/${FeatureName}_repository.dart';

class ${FeatureClassName}RepositoryImpl implements ${FeatureClassName}Repository {}
"@

  "lib/features/$FeatureName/domain/entities/${FeatureName}_entity.dart" = "class ${FeatureClassName}Entity {}"

  "lib/features/$FeatureName/domain/repositories/${FeatureName}_repository.dart" = @"
abstract class ${FeatureClassName}Repository {}
"@


  "lib/features/$FeatureName/presentation/bloc/${FeatureName}_bloc.dart" = @"
import 'package:flutter_bloc/flutter_bloc.dart';

import '${FeatureName}_event.dart';
import '${FeatureName}_state.dart';

class ${FeatureClassName}Bloc
    extends Bloc<${FeatureClassName}Event, ${FeatureClassName}State> {

  ${FeatureClassName}Bloc()
      : super(${FeatureClassName}Initial()) {

    on<${FeatureClassName}Event>(_onEvent);
  }

  void _onEvent(
    ${FeatureClassName}Event event,
    Emitter<${FeatureClassName}State> emit,
  ) {

  }
}
"@
  "lib/features/$FeatureName/presentation/bloc/${FeatureName}_event.dart" = @"
abstract class ${FeatureClassName}Event {}

class ${FeatureClassName}Started extends ${FeatureClassName}Event {}
"@
  "lib/features/$FeatureName/presentation/bloc/${FeatureName}_state.dart" = @"
abstract class ${FeatureClassName}State {}

class ${FeatureClassName}Initial extends ${FeatureClassName}State {}

class ${FeatureClassName}Loading extends ${FeatureClassName}State {}

class ${FeatureClassName}Success extends ${FeatureClassName}State {}

class ${FeatureClassName}Error extends ${FeatureClassName}State {}
"@


}

# ---------------------------------------------------------
#  Create files
# ---------------------------------------------------------
Write-Host "▶ Generating Dart files..." -ForegroundColor Magenta

foreach ($file in $files.Keys) {

    $dir = Split-Path $file -Parent

    if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }

    $files[$file] | Set-Content -Path $file -Encoding UTF8

    Write-Host "   ✓ " -NoNewline -ForegroundColor DarkCyan
    Write-Host "$file" -ForegroundColor Gray
}

# ---------------------------------------------------------
#  Summary tree
# ---------------------------------------------------------
Write-Host ""
Write-Host "▶ Structure overview" -ForegroundColor Magenta
Write-Host "   lib/features/$FeatureName" -ForegroundColor White
Write-Host "   ├── data" -ForegroundColor DarkYellow
Write-Host "   │   ├── datasources (remote, local)" -ForegroundColor Gray
Write-Host "   │   ├── models" -ForegroundColor Gray
Write-Host "   │   └── repositories" -ForegroundColor Gray
Write-Host "   ├── domain" -ForegroundColor DarkYellow
Write-Host "   │   ├── entities" -ForegroundColor Gray
Write-Host "   │   ├── repositories" -ForegroundColor Gray
Write-Host "   │   └── usecases" -ForegroundColor Gray
Write-Host "   └── presentation" -ForegroundColor DarkYellow
Write-Host "       ├── bloc" -ForegroundColor Gray
Write-Host "       ├── pages" -ForegroundColor Gray
Write-Host "       └── widgets" -ForegroundColor Gray
Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  ✅ Feature '$FeatureName' structure created successfully             ║" -ForegroundColor Green
Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""