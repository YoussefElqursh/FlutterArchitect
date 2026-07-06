# 🏗️ FlutterArchitect

**PowerShell-based Flutter Project Scaffolding Toolkit**

A simple and fast toolkit built with **PowerShell 7** that generates a production-ready **Clean Architecture** structure for any Flutter project. It can also scaffold new **Features** following the same architecture with a single command.

The goal is to save time by eliminating repetitive manual folder creation while ensuring that every project in your team follows the exact same structure.

---

# 📋 Table of Contents

- [Features](#-features)
- [Requirements](#-requirements)
- [Installation](#-installation)
- [Usage](#-usage)
  - [1. Generate the Base Project Structure](#1-generate-the-base-project-structure--genbasefoldersps1)
  - [2. Generate a New Feature](#2-generate-a-new-feature--genfeatureps1)
- [Generated Project Structure](#-generated-project-structure)
- [Automatically Added Packages](#-automatically-added-packages)
- [Important Notes](#-important-notes)
- [Roadmap](#-roadmap)
- [Contributing](#-contributing)
- [License](#-license)

---

# ✨ Features

- ⚡ Generate a complete **Flutter Clean Architecture** project in seconds.
- 🧩 Scaffold any new **Feature** (Data / Domain / Presentation) with a single command.
- 📦 Automatically add essential dependencies to `pubspec.yaml` without duplicating existing packages.
- 🔁 Automatically run `flutter pub get` and `build_runner watch` after generation.
- 🎨 Display colorful terminal output so you can easily follow every step.
- 🧱 Built around **BLoC + GetIt + Injectable + Dio + Firebase**, ready from day one.

---

# ✅ Requirements

| Requirement | Details |
|-------------|---------|
| **PowerShell** | Version **7 or later** (PowerShell 7+ / pwsh) |
| **Flutter SDK** | Installed and added to your PATH |
| **Dart SDK** | Included with Flutter |
| **Operating System** | Windows, macOS, or Linux (as long as PowerShell 7 is installed) |

> ⚠️ These scripts are written and tested for **PowerShell 7**. Running them on the legacy Windows PowerShell (5.1) may cause unexpected issues.

## Install PowerShell 7

```powershell
winget install --id Microsoft.Powershell --source winget
```

Or download it from the official repository:

https://github.com/PowerShell/PowerShell

---

# 📥 Installation

1. Clone the repository (or download the scripts manually):

```bash
git clone https://github.com/HossamHesham2/FlutterArchitect
```

2. Copy `genBaseFolders.ps1` and `genFeature.ps1` into the root directory of your Flutter project (the same directory that contains `pubspec.yaml`).

---

# 🚀 Usage

## 1. Generate the Base Project Structure — `genBaseFolders.ps1`

Navigate to your Flutter project's root directory (where `pubspec.yaml` is located), then run:

```powershell
pwsh .\genBaseFolders.ps1
```

### This script automatically:

1. Creates the base project structure (`app`, `core`, and `features`).
2. Generates ready-to-use files such as:
   - `main.dart` and `bootstrap.dart`
   - `app.dart` with routing (`app_routes.dart`, `route_names.dart`)
   - `app_bindings.dart`
   - `app_observer.dart` (BLoC Observer)
   - `AppTheme` (Light & Dark)
   - A complete `core` module including:
     - Constants
     - Dependency Injection (GetIt + Injectable + Firebase Module)
     - Errors (Exceptions & Failures)
     - Networking (ApiClient & Interceptors)
     - Theme (AppColors)
     - Utilities (Logger)
     - Helpers (Validators & SharedPreferences Helper)
     - A reusable `CustomTextField` built with `flutter_screenutil`
3. Adds the required dependencies and dev dependencies to `pubspec.yaml` without duplicating existing packages.
4. Runs:

```bash
flutter pub get
```

5. Starts:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

to generate `dependency_injection.config.dart` automatically for Injectable.

> 💡 The script first verifies that `pubspec.yaml` exists before proceeding. If it cannot be found, execution stops and a clear error message is displayed.

---

## 2. Generate a New Feature — `genFeature.ps1`

Once the base structure has been generated, create a new feature with a single command:

```powershell
pwsh .\genFeature.ps1 my_new_feature
```

Example:

```powershell
pwsh .\genFeature.ps1 auth
```

This generates:

```text
lib/features/auth
├── data
│   ├── datasources
│   │   ├── remote/auth_remote_datasource.dart
│   │   └── local/auth_local_datasource.dart
│   ├── models
│   └── repositories/auth_repository_impl.dart
├── domain
│   ├── entities/auth_entity.dart
│   ├── repositories/auth_repository.dart
│   └── usecases
└── presentation
    ├── bloc
    │   ├── auth_bloc.dart
    │   ├── auth_event.dart
    │   └── auth_state.dart
    ├── pages
    └── widgets
```

### Additional Features

- Feature names are automatically converted to **PascalCase** for class names.

Example:

```text
my_new_feature
↓
MyNewFeature
```

- The generated BLoC comes preconfigured with the basic states:
  - Initial
  - Loading
  - Success
  - Error

and includes the necessary connection between the Bloc, Events, and States.

---

# 🗂️ Generated Project Structure

```text
lib
├── app
│   ├── bootstrap      # Application bootstrap
│   ├── bindings       # Dependency registration
│   ├── observers      # Global BLoC Observer
│   ├── router         # Routes & Route Names
│   └── theme          # Light & Dark ThemeData
│
├── core
│   ├── constants
│   ├── di             # GetIt + Injectable + Firebase Module
│   ├── errors         # Exceptions & Failures
│   ├── networking     # ApiClient & Interceptors
│   ├── helpers        # Validators & SharedPreferences Helper
│   ├── services
│   ├── theme          # AppColors
│   ├── utils          # Logger
│   ├── widgets        # Shared Widgets
│   └── localization
│
└── features
    └── <feature_name>
        ├── data          # Datasources, Models, Repository Implementations
        ├── domain        # Entities, Abstract Repositories, Use Cases
        └── presentation  # BLoC, Pages, Widgets
```

The generated structure follows the standard **Clean Architecture** principles by clearly separating the **Data**, **Domain**, and **Presentation** layers while using **GetIt** and **Injectable** for Dependency Injection.

---

# 📦 Automatically Added Packages

The scripts automatically fetch and add the **latest versions** of all required packages from [pub.dev](https://pub.dev), ensuring you always have up-to-date dependencies without manual version management.

## Dependencies

- flutter_bloc
- equatable
- dartz
- get_it
- injectable
- dio
- shared_preferences
- flutter_screenutil
- firebase_core
- firebase_auth
- cloud_firestore

## Dev Dependencies

- build_runner
- injectable_generator
- flutter_lints

### Asset Folders

The script also creates the following asset directory structure:

```
assets/
├── images/
├── svgs/
└── fonts/
```

> ✨ **Smart Features:**
> - Existing packages are detected automatically, so duplicates are never added.
> - Package versions are fetched dynamically from pub.dev, ensuring you always have the latest compatible versions.
> - The script gracefully handles network errors and continues with the generation process.

---

# ⚠️ Important Notes

- Run `genBaseFolders.ps1` **only once** when starting a new project. Running it again may overwrite files such as `main.dart` or `app.dart` if you've modified them.
- `genFeature.ps1` is safe to run at any time for creating additional features.
- Feature names should use lowercase letters separated by `_` or `-`.

Examples:

```text
user_profile
user-profile
```

- Whenever you modify your Dependency Injection classes (`@injectable`, `@lazySingleton`, etc.), regenerate the DI configuration by running:

```powershell
dart run build_runner build --delete-conflicting-outputs
```

---

# 🧭 Roadmap

- [ ] Add CLI flags to choose which packages to include.
- [ ] Generate Use Cases and Models automatically within each feature.
- [ ] Provide a Bash/Zsh version for users who prefer not to use PowerShell.
- [ ] Generate Unit Test templates for every feature.

---

# 🤝 Contributing

Contributions are always welcome!

If you have ideas for improvements, discover a bug, or want to add new functionality, feel free to open an Issue or submit a Pull Request.

---

# 📄 License

This project is licensed under the **MIT License**.

---

<div align="center">

Made with ❤️ by **Hossam** — Flutter Developer

</div>