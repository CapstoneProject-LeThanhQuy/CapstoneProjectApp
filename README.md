# Capstone Project

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Usage

---

- Install plugin: [flutter_intl](https://marketplace.visualstudio.com/items?itemName=localizely.flutter-intl)
- Install fvm: [fvm](https://fvm.app/docs/getting_started/installation)

```shell
$ git clone git@bitbucket.org:est-rouge/caa-abs-app.git
$ cd caa-abs-app

$ fvm install 3.0.5
$ fvm use 3.0.5
$ fvm flutter --version
Flutter 3.0.5 • channel stable • https://github.com/flutter/flutter.git
Framework • revision f1875d570e (3 weeks ago) • 2022-07-13 11:24:16 -0700
Engine • revision e85ea0e79c
Tools • Dart 2.17.6 • DevTools 2.12.2

$ fvm flutter pub get
$ fvm flutter pub run build_runner build --delete-conflicting-outputs
$ fvm flutter run
```

- For development time

```shell
$ fvm flutter pub run build_runner watch --delete-conflicting-outputs
```

Each time you modify your project code, `main.mapper.g.dart` files will be updated as well.

## About Project

---

#### Document

#### Techstack

#### Architecture

- Using [GetX](https://github.com/jonataslaw/getx) for integration State management, Route management, Dependency management
- Using [Dio](https://pub.dev/packages/dio) & [Retrofit](https://pub.dev/packages/retrofit) for networking
- Using [json_dart_mapper](https://pub.dev/packages/dart_json_mapper) for mapping data

![](/assets/architecture/architecture.png)

#### Folder structure

```
├─ assets
│   ├─ env
│   │   ─   .env_qa
│   │   ─   .env_stg
│   │   ─   .env_prod
│   ├─ fonts
│   │   ─   *.ttf
│   └─ images
│       ─   *.png
│       ─   ...
└─ lib
    ├─ base
    │   ├─ data
    │   ├─ domain
    │   └─ presentation
    ├─ features
    │   ├─ authentication
    │   │   ├─ data
    │   │   │   ├─ providers (datasources)
    │   │   │   │   ├─ local
    │   │   │   │   │   ─   user_storage.dart
    │   │   │   │   │   ─   ...
    │   │   │   │   └─ remote
    │   │   │   │       ─   user_api.dart
    │   │   │   │       ─   ...
    │   │   │   ├─ models
    │   │   │   │   ─   user_model.dart
    │   │   │   │   ─   ...
    │   │   │   └─ repositories_impl
    │   │   │       └─ mapper
    │   │   │           ─   user_mapper.dart
    │   │   │           ─   ...
    │   │   │       ─   user_repo_impl.dart
    │   │   │       ─   ...
    │   │   ├─ domain
    │   │   │   ├─ repositories (abstract class)
    │   │   │   │   ─   user_repo.dart
    │   │   │   │   ─   ...
    │   │   │   ├─ entities
    │   │   │   │   ─   user.dart
    │   │   │   │   ─   ...
    │   │   │   └─ usecases
    │   │   │       ├─ login
    │   │   │       │   ─   login_uc.dart
    │   │   │       │   ─   ...
    │   │   │       ├─ ...
    │   │   └─ presentation
    │   │       ├─ controllers
    │   │       │   ├─ login
    │   │       │   │   ─   login_binding.dart
    │   │       │   │   ─   login_controller.dart
    │   │       │   │   ─   login_input.dart
    │   │       │   └─ ...
    │   │       └─ views
    │   │           ├─ login
    │   │           │   ─   login_page.dart
    │   │           └─ ...
    │   └─ other features ...
    │
    ├─ l10n
    │   ─   intl_en.arb
    │   ─   intl_jp.arb
    └─ ultis
        ├─ common_widgets
        ├─ config
        ├─ extension
        └─ service

    ─   main.dart
    ─   app.dart

─   analysis_options.yaml
─   build.yaml
─   pubspec.yaml
```

#### Plugins

- [flutter_intl](https://marketplace.visualstudio.com/items?itemName=localizely.flutter-intl): VS Code extension to create a binding between your translations from .arb files and your Flutter app. It generates boilerplate code for official Dart Intl library and adds auto-complete for keys in Dart code.
