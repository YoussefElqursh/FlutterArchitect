Write-Host ""
Write-Host "╔════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║          FLUTTER ARCHITECTURE GENERATOR            ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "🚀 Starting Flutter Architecture Generator..." -ForegroundColor Green
Write-Host ""

# =========================
# CREATE FOLDERS
# =========================
$folders = @(
# lib
    "lib",

    # app
    "lib/app",
    "lib/app/observers",
    "lib/app/router",
    "lib/app/bindings",
    "lib/app/bootstrap",
    "lib/app/theme",

    # core
    "lib/core",
    "lib/core/constants",
    "lib/core/di",
    "lib/core/errors",
    "lib/core/extensions",
    "lib/core/networking",
    "lib/core/helpers",
    "lib/core/services",
    "lib/core/theme",
    "lib/core/utils",
    "lib/core/widgets",
    "lib/core/localization",

    # features
    "lib/features"

)

Write-Host "▶ Creating folder structure..." -ForegroundColor Magenta

foreach ($folder in $folders) {
    New-Item -ItemType Directory -Path $folder -Force | Out-Null
    Write-Host "   + " -NoNewline -ForegroundColor DarkGreen
    Write-Host "$folder" -ForegroundColor Gray
}

Write-Host ""

# =========================
# CREATE FILES
# =========================
$files = @{

# ENTRY POINT
    "lib/main.dart"                           = @'
import 'package:flutter/material.dart';
import 'app/app.dart';
import 'app/bootstrap/bootstrap.dart';

Future<void> main() async {
  await bootstrap();
}
'@

    # BOOTSTRAP
    "lib/app/bootstrap/bootstrap.dart"        = @'
import 'package:flutter/material.dart';
import '../app.dart';
import '../bindings/app_bindings.dart';
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppBindings.init();

  runApp(const App());
}
'@

    # APP ROOT
    "lib/app/app.dart"                        = @'
import 'package:flutter/material.dart';
import 'router/app_routes.dart';
import 'router/route_names.dart';
import 'theme/app_theme.dart';
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      initialRoute: RouteNames.login,
    );
  }
}
'@

    # ROUTES
    "lib/app/router/app_routes.dart"          = @'
import 'package:flutter/material.dart';
import 'route_names.dart';

class AppRoutes {
  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const Scaffold(
            body: Center(child: Text("Login Screen")),
          ),
        );

      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const Scaffold(
            body: Center(child: Text("No Route Found")),
          ),
        );
    }
  }
}
'@
    #========================
    # ROUTE NAMES
    #========================
    "lib/app/router/route_names.dart"         = @'
class RouteNames {
  static const String login = '/login';
}
'@
    # =========================
    # APP
    # =========================

    "lib/app/bindings/app_bindings.dart"      = @'
class AppBindings {
  static Future<void> init() async {
    // Register dependencies here
  }
}
'@

    "lib/app/observers/app_observer.dart"     = @'

import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print('Created: ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('Changed: ${bloc.runtimeType} => $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('Error: ${bloc.runtimeType} => $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    print('Closed: ${bloc.runtimeType}');
  }
}
'@

    "lib/app/theme/app_theme.dart"            = @'
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    useMaterial3: true,
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
  );
}
'@
    "lib/core/constants/app_constants.dart"   = @'
class AppConstants {
  static const appName = 'My App';
}
'@
    "lib/core/di/dependency_injection.dart"   = @'
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'dependency_injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
void configureDependencies() => getIt.init();
'@

    "lib/core/di/firebase_module.dart"        = @'
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@module
abstract class FirebaseModule {
  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @lazySingleton
  FirebaseFirestore get firebaseFirestore => FirebaseFirestore.instance;
}
'@
    "lib/core/errors/exceptions.dart"         = @'
class ServerException implements Exception {}

class CacheException implements Exception {}
'@

    "lib/core/errors/failures.dart"           = @'
abstract class Failure {}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
'@
    "lib/core/networking/api_client.dart"     = @'
class ApiClient {}
'@

    "lib/core/networking/interceptors.dart"   = @'
class AppInterceptor {}
'@

    "lib/core/theme/colors.dart"              = @'
import 'package:flutter/material.dart';

class AppColors {
  static const primary = Colors.blue;
}
'@

    "lib/core/utils/logger.dart"              = @'
import 'package:flutter/foundation.dart';
class Logger {
  static void log(Object message) {
    debugPrint(message.toString());
  }
}
'@
    "lib/core/helpers/validators.dart"        = @'
class Validators {
  static bool isEmail(String value) {
    return value.contains("@");
  }
      static String? fullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }

    if (value.trim().length < 3) {
      return 'Full name must be at least 3 characters';
    }

    if (!value.trim().contains(' ')) {
      return 'Please enter your full name';
    }

    return null;
  }

  static String? amount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Amount is required';
    }

    final amount = double.tryParse(value.trim());

    if (amount == null) {
      return 'Please enter a valid amount';
    }

    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }

    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }
}
'@

    "lib/core/helpers/prefs_helper.dart"      = @'
import 'package:shared_preferences/shared_preferences.dart';

class PrefsHelper {
  PrefsHelper._();
  static final PrefsHelper instance = PrefsHelper._();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // =========================
  // 🔹 SETTERS
  // =========================

  Future<bool> setString(String key, String value) async {
    return await _prefs!.setString(key, value);
  }

  Future<bool> setInt(String key, int value) async {
    return await _prefs!.setInt(key, value);
  }

  Future<bool> setBool(String key, bool value) async {
    return await _prefs!.setBool(key, value);
  }

  Future<bool> setDouble(String key, double value) async {
    return await _prefs!.setDouble(key, value);
  }

  Future<bool> setStringList(String key, List<String> value) async {
    return await _prefs!.setStringList(key, value);
  }

  // =========================
  // 🔹 GETTERS
  // =========================

  String? getString(String key) {
    return _prefs!.getString(key);
  }

  int? getInt(String key) {
    return _prefs!.getInt(key);
  }

  bool? getBool(String key) {
    return _prefs!.getBool(key);
  }

  double? getDouble(String key) {
    return _prefs!.getDouble(key);
  }

  List<String>? getStringList(String key) {
    return _prefs!.getStringList(key);
  }

  // =========================
  // 🔹 REMOVE
  // =========================

  Future<bool> remove(String key) async {
    return await _prefs!.remove(key);
  }

  Future<bool> clear() async {
    return await _prefs!.clear();
  }

  bool containsKey(String key) {
    return _prefs!.containsKey(key);
  }
}
'@
    "lib/core/widgets/custom_text_field.dart" = @'
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final Widget? prefix;
  final Widget? suffix;
  final bool obscureText;
  final TextAlign? textAlign;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.label,
    this.hintText,
    this.suffix,
    this.validator,
    this.textAlign,
    this.keyboardType,
    this.controller,
    this.obscureText = false,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 20.h),
        TextFormField(
          validator: validator,
          obscureText: obscureText,
          controller: controller,
          keyboardType: keyboardType,
          autocorrect: true,
          textAlign: textAlign ?? TextAlign.start,
          decoration: InputDecoration(
            prefixIcon: prefix,
            suffixIcon: suffix,
            hintText: hintText,
          ),
        ),
      ],
    );
  }
}

'@

}

Write-Host "▶ Generating core files..." -ForegroundColor Magenta

foreach ($file in $files.Keys) {

    $dir = Split-Path $file -Parent

    if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }

    $files[$file] | Set-Content -Path $file -Encoding UTF8

    Write-Host "   ✓ " -NoNewline -ForegroundColor DarkCyan
    Write-Host "$file" -ForegroundColor Gray
}

Write-Host ""

# =========================
# STRUCTURE SUMMARY
# =========================
Write-Host "▶ Structure overview" -ForegroundColor Magenta
Write-Host "   lib" -ForegroundColor White
Write-Host "   ├── app" -ForegroundColor DarkYellow
Write-Host "   │   ├── bootstrap, bindings, observers" -ForegroundColor Gray
Write-Host "   │   ├── router" -ForegroundColor Gray
Write-Host "   │   └── theme" -ForegroundColor Gray
Write-Host "   ├── core" -ForegroundColor DarkYellow
Write-Host "   │   ├── constants, di, errors, networking" -ForegroundColor Gray
Write-Host "   │   ├── helpers, services, utils" -ForegroundColor Gray
Write-Host "   │   └── theme, widgets, localization" -ForegroundColor Gray
Write-Host "   └── features" -ForegroundColor DarkYellow
Write-Host ""

$dependencies = @(
    "flutter_bloc: ^9.1.1"
    "equatable: ^2.0.7"
    "dartz: ^0.10.1"
    "get_it: ^8.2.0"
    "injectable: ^2.5.1"
    "dio: ^5.9.0"
    "shared_preferences: ^2.5.3"
    "flutter_screenutil: ^5.9.3"
    "firebase_core: ^4.0.0"
    "firebase_auth: ^6.0.1"
    "cloud_firestore: ^6.0.0"
)

$devDependencies = @(
    "build_runner: ^2.5.4"
    "injectable_generator: ^2.7.0"
    "flutter_lints: ^6.0.0"
)
function Add-Packages {
    param(
        [string]$Section,
        [string[]]$Packages
    )

    $pubspecPath = "pubspec.yaml"

    $content = Get-Content $pubspecPath

    $output = @()

    foreach ($line in $content) {

        $output += $line

        if ($line.Trim() -eq "${Section}:") {

            foreach ($package in $Packages) {

                $name = $package.Split(":")[0].Trim()

                if (-not ($content -match "^\s*$([regex]::Escape($name))\s*:")) {
                    $output += "  $package"
                }
            }
        }
    }

    $output | Set-Content $pubspecPath -Encoding UTF8
}
if (!(Test-Path "pubspec.yaml")) {
    Write-Host "❌ pubspec.yaml not found!" -ForegroundColor Red
    exit
}

Write-Host "▶ Updating pubspec.yaml..." -ForegroundColor Magenta

Add-Packages -Section "dependencies" -Packages $dependencies
Write-Host "   ✓ " -NoNewline -ForegroundColor DarkCyan
Write-Host "dependencies added" -ForegroundColor Gray

Add-Packages -Section "dev_dependencies" -Packages $devDependencies
Write-Host "   ✓ " -NoNewline -ForegroundColor DarkCyan
Write-Host "dev_dependencies added" -ForegroundColor Gray

Write-Host ""
Write-Host "▶ Running flutter pub get..." -ForegroundColor Magenta
flutter pub get

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ flutter pub get failed." -ForegroundColor Red
    exit
}

Write-Host ""
Write-Host "════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "✅ Done Successfully! Flutter Architecture Generated." -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""
Write-Host "▶ Starting build_runner watch..." -ForegroundColor Magenta
Write-Host ""

dart run build_runner watch --delete-conflicting-outputs