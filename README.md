# Flutter Clean Architecture Template (BLoC / Cubit & Riverpod)

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-2EA44F)](#)
[![State Management](https://img.shields.io/badge/State-BLoC%20%2F%20Cubit%20%7C%20Riverpod%203-orange)](#)

**Zero-to-Hero** production Flutter Clean Architecture monorepo template containing two complete, independent implementations of the same app — from initial setup, multi-environment Firebase & Push Notifications, feature development, and full-pyramid testing, all the way to **Google Play Store** and **Apple App Store** release:

- **`flutter_bloc/`** — Clean Architecture + **BLoC / Cubit** + **`get_it`** Dependency Injection
- **`flutter_riverpod/`** — Clean Architecture + **Riverpod 3 (`NotifierProvider`)**

> **Language / ภาษา:** [🇹🇭 คู่มือภาษาไทย (TH)](#คู่มือภาษาไทย-th) | [🇬🇧 English Guide (EN)](#english-guide-en)

---

## Quick Comparison: `flutter_bloc/` vs `flutter_riverpod/`

| Aspect | `flutter_bloc/` | `flutter_riverpod/` |
|---|---|---|
| **State Management** | `flutter_bloc` (`Bloc` & `Cubit`) | `flutter_riverpod` v3 (`Notifier` & `NotifierProvider`) |
| **Dependency Injection** | `get_it` (`lib/src/injector.dart`) | Riverpod `Provider` graph (`lib/src/injector.dart`) |
| **Debug Observer** | `AppBlocObserver` (`Bloc.observer`) | `ProviderObserver` (optional) |
| **Unit & Widget Tests** | `flutter_bloc/test/` (81 tests) | `flutter_riverpod/test/` (73 tests) |
| **Integration Tests** | `flutter_bloc/integration_test/` (7 E2E flows) | `flutter_riverpod/integration_test/` (7 E2E flows) |
| **Test DI Override** | `getIt.reset()` + `registerLazySingleton` | `ProviderContainer` / `ProviderScope(overrides: [...])` |

---
---

# คู่มือภาษาไทย (TH)

## สารบัญ (TH)
1. [Quick Start (เริ่มรันได้ใน 5 นาที)](#1-quick-start-เริ่มรันได้ใน-5-นาที)
2. [สิ่งที่ต้องเตรียมก่อนเริ่ม (Prerequisites)](#2-สิ่งที่ต้องเตรียมก่อนเริ่ม-prerequisites)
3. [โครงสร้างโฟลเดอร์ (Project Structure)](#3-โครงสร้างโฟลเดอร์-project-structure)
4. [ชุดแพ็กเกจหลักที่ใช้ (`pubspec.yaml`)](#4-ชุดแพ็กเกจหลักที่ใช้-pubspecyaml)
5. [ตั้งค่า Bundle ID, Firebase และ Multi-Environment (`dev` / `sit` / `uat` / `prod`)](#5-ตั้งค่า-bundle-id-firebase-และ-multi-environment-dev--sit--uat--prod)
6. [ตั้งค่า Push Notifications (FCM + Local Notifications — Android & iOS)](#6-ตั้งค่า-push-notifications-fcm--local-notifications--android--ios)
7. [เข้ารหัสตัวแปรความลับด้วย `envied`](#7-เข้ารหัสตัวแปรความลับด้วย-envied)
8. [ตั้งค่า Flavors ด้วย `flutter_flavorizr`](#8-ตั้งค่า-flavors-ด้วย-flutter_flavorizr)
9. [สร้าง App Icon และ Code Generation (`flutter_launcher_icons`, `flutter_gen`, `build_runner`)](#9-สร้าง-app-icon-และ-code-generation-flutter_launcher_icons-flutter_gen-build_runner)
10. [การตั้งค่า `main.dart` และ `app.dart`](#10-การตั้งค่า-maindart-และ-appdart)
11. [ขั้นตอนการพัฒนา Feature ตามหลัก Clean Architecture](#11-ขั้นตอนการพัฒนา-feature-ตามหลัก-clean-architecture)
    - [11.1 Data & Domain Layer (ใช้ร่วมกันทั้ง 2 โปรเจกต์)](#111-data--domain-layer-ใช้ร่วมกันทั้ง-2-โปรเจกต์)
    - [11.2 Presentation & DI — สำหรับ `flutter_bloc/`](#112-presentation--di--สำหรับ-flutter_bloc)
    - [11.3 Presentation & DI — สำหรับ `flutter_riverpod/`](#113-presentation--di--สำหรับ-flutter_riverpod)
12. [วิธีรันแอป (แยก `flutter_bloc` และ `flutter_riverpod`)](#12-วิธีรันแอป-แยก-flutter_bloc-และ-flutter_riverpod)
13. [กระบวนการทดสอบ (Unit, Widget & Integration Tests) + การตั้งค่า Emulator](#13-กระบวนการทดสอบ-unit-widget--integration-tests--การตั้งค่า-emulator)
14. [ขั้นตอน Build Release ขึ้น Store (Android Google Play & iOS App Store)](#14-ขั้นตอน-build-release-ขึ้น-store-android-google-play--ios-app-store)
    - [14.1 Pre-Release Checklist (สำคัญมากสำหรับ `freeRASP` & Crashlytics)](#141-pre-release-checklist-สำคัญมากสำหรับ-freerasp--crashlytics)
    - [14.2 Build & Release ขึ้น Google Play Store (Android)](#142-build--release-ขึ้น-google-play-store-android)
    - [14.3 Build & Release ขึ้น Apple App Store / TestFlight (iOS)](#143-build--release-ขึ้น-apple-app-store--testflight-ios)
15. [คำสั่งแก้ปัญหาที่พบบ่อย (Troubleshooting)](#15-คำสั่งแก้ปัญหาที่พบบ่อย-troubleshooting)

---

### 1. Quick Start (เริ่มรันได้ใน 5 นาที)

```bash
# 1. Clone โปรเจกต์
git clone <your-repo-url>
cd flutter_clean_architecture_bloc_cubit_riverpod

# 2. เลือกโฟลเดอร์ที่ต้องการใช้งาน: flutter_bloc หรือ flutter_riverpod
cd flutter_bloc   # หรือ cd flutter_riverpod

# 3. ติดตั้ง dependencies
flutter pub get

# 4. (เฉพาะ macOS สำหรับ iOS) ติดตั้ง CocoaPods
cd ios && pod install && cd ..

# 5. ยืนยันว่าเครื่องพร้อมด้วยการรัน Unit & Widget Tests
flutter test

# 6. รันแอปบน Emulator / เครื่องจริง
flutter run --flavor dev
```

---

### 2. สิ่งที่ต้องเตรียมก่อนเริ่ม (Prerequisites)
- **Flutter SDK** (3.x) และ **Dart SDK** (`>=3.3.2 <4.0.0`) — ตรวจสอบด้วย `flutter doctor`
- **Java 17+** (แนะนำใช้ JBR ที่มากับ Android Studio)
- **Android Studio** + Android SDK + Emulator (`x86_64` system image สำหรับ Flutter เวอร์ชันใหม่)
- **Xcode** + **CocoaPods** (`sudo gem install cocoapods`) สำหรับพัฒนา/ปล่อยแอป iOS
- **Node.js & npm** (สำหรับติดตั้ง `firebase-tools`)
- **Firebase CLI & FlutterFire CLI**
- **บัญชีนักพัฒนาสำหรับขึ้น Store:** Google Play Console (\$25 ครั้งเดียว) และ Apple Developer Program (\$99/ปี)

---

### 3. โครงสร้างโฟลเดอร์ (Project Structure)

ทั้ง `flutter_bloc/` และ `flutter_riverpod/` ใช้โครงสร้าง Clean Architecture เดียวกัน ต่างกันเฉพาะชั้น Presentation และ DI:

```text
<flutter_bloc หรือ flutter_riverpod>/
├── assets/
│   ├── colors/
│   ├── fonts/
│   ├── images/icons/
│   └── localization.xlsx / localization.csv
├── .firebase/                        # ไฟล์ config Firebase แยกตาม env (dev, sit, uat, prod)
├── .dev.env / .sit.env / .uat.env / .prod.env
├── flavorizr.yaml
├── lib/
│   ├── main.dart                     # Entry point: flavor, Firebase, Crashlytics, DI, Localization
│   ├── app.dart                      # Security (freeRASP/ScreenProtector), FCM, Responsive UI
│   ├── flavors.dart                  # จัดการค่าแยกตาม Flavor (title, baseUrl, minAppVersion)
│   ├── firebase_options/             # firebase_options_{dev,sit,uat,prod}.dart
│   └── src/
│       ├── injector.dart             # DI (get_it ใน flutter_bloc / Provider ใน flutter_riverpod)
│       ├── core/
│       │   ├── config/               # remote_config_service.dart
│       │   ├── constants/            # app_constants.dart, enum_constants.dart
│       │   ├── env/                  # env.dart, env.g.dart (envied)
│       │   ├── exceptions/           # BaseException, NormalException, NetworkException, DatabaseException
│       │   ├── extensions/
│       │   ├── gen/                  # assets.gen.dart (flutter_gen)
│       │   ├── network/              # dio_client.dart, error_model.dart
│       │   └── utils/                # firebase_messaging_service.dart, func.dart, url_launcher_manager.dart, navigator_observation.dart
│       ├── data/
│       │   ├── _mapper/              # entity_convertable.dart
│       │   ├── datasources/remote/   # Retrofit datasource (*.dart, *.g.dart) + export_datasources.dart
│       │   ├── models/remote/        # DTO + json_serializable (*.dart, *.g.dart) + export_models.dart
│       │   └── repositories/         # Repository implementation (try/catch + Either) + export_repositories.dart
│       ├── domain/
│       │   ├── entities/             # Pure domain entities (Equatable)
│       │   ├── repositories/         # Abstract repository contracts
│       │   └── usecases/             # Business use cases
│       └── presentation/
│           ├── bloc_cubit/           # (เฉพาะ flutter_bloc) app_bloc_observer.dart + feature BLoC/Cubit
│           ├── riverpod/             # (เฉพาะ flutter_riverpod) feature Notifier + State
│           ├── pages/                # splash_page, security_page, home_page, users/*
│           └── widgets/              # global/* (common_widgets, update_dialog), users/*
├── test/                             # Unit & Widget tests แบ่งตาม layer
│   ├── helpers/fakes.dart
│   ├── core/exceptions/
│   ├── data/models/
│   ├── data/repositories/
│   ├── domain/usecases/
│   ├── presentation/                 # bloc_cubit/* หรือ riverpod/*
│   └── widget_test.dart
└── integration_test/
    └── users_flow_test.dart          # Full-stack E2E Integration Tests
```

---

### 4. ชุดแพ็กเกจหลักที่ใช้ (`pubspec.yaml`)

| หมวดหมู่ | แพ็กเกจ | หน้าที่ |
|---|---|---|
| **State Management** | `flutter_bloc`, `bloc` / `flutter_riverpod`, `riverpod` | จัดการ State ใน Presentation layer |
| **Dependency Injection** | `get_it` (BLoC) / `riverpod` (Riverpod) | Service Locator / Provider Graph |
| **Networking** | `dio`, `retrofit`, `pretty_dio_logger`, `dio_curl_logger` | เรียก REST API และดู HTTP log |
| **Serialization & Equality** | `json_annotation`, `json_serializable`, `equatable` | แปลง JSON และเปรียบเทียบค่า Object |
| **Functional Error Handling** | `dartz` (`Either<BaseException, T>`) | แยกผลลัพธ์ `Left(error)` / `Right(data)` |
| **Env & Flavors** | `envied`, `flutter_flavorizr`, `rename` | เข้ารหัส `.env`, แยก flavor, ตั้งชื่อแอป/Bundle ID |
| **Firebase** | `firebase_core`, `firebase_crashlytics`, `firebase_remote_config`, `firebase_messaging` | แจ้งเตือน, เก็บ crash, ปรับ config แบบ remote |
| **Security** | `freerasp`, `screen_protector` | ตรวจจับ Root/Jailbreak/Hook/Emulator และกันแคปหน้าจอ |
| **UI & Localization** | `flutter_screenutil`, `responsive_framework`, `easy_localization`, `device_preview`, `get` | Responsive UI, หลายภาษา, Navigation |
| **Local Storage & Utils** | `flutter_secure_storage`, `shared_preferences`, `package_info_plus`, `url_launcher`, `flutter_local_notifications` | เก็บ token/ค่าตั้งค่า, ตรวจเวอร์ชัน, เปิด store, local noti |
| **Testing** | `flutter_test`, `integration_test`, `mockito` | Unit, Widget, และ Integration Testing |

---

### 5. ตั้งค่า Bundle ID, Firebase และ Multi-Environment (`dev` / `sit` / `uat` / `prod`)

#### 5.1 เปลี่ยน Bundle ID / Package Name
```bash
dart pub global activate rename
dart pub global run rename setBundleId --value "com.yourcompany.yourapp"
```

#### 5.2 สร้างแอปบน Firebase Console (8 แอป)
สร้างแอปใน Firebase Console แยกตาม Environment ทั้ง Android (4 แอป) และ iOS (4 แอป):
1. `com.yourcompany.yourapp` (**prod**)
2. `com.yourcompany.yourapp.dev` (**dev**)
3. `com.yourcompany.yourapp.sit` (**sit**)
4. `com.yourcompany.yourapp.uat` (**uat**)

จากนั้นดาวน์โหลดไฟล์ config จาก **Project Settings → General → Your apps**:
- **Android**: ดาวน์โหลด `google-services.json`
- **iOS**: ดาวน์โหลด `GoogleService-Info.plist` ให้ครบทุกแอป
- นำไปวางไว้ที่ `.firebase/<env>/` (`dev`, `sit`, `uat`, `prod`)

#### 5.3 ติดตั้ง Firebase CLI & FlutterFire CLI และสร้าง `firebase_options`
```bash
npm install -g firebase-tools
dart pub global activate flutterfire_cli

firebase login
flutterfire configure --project=<your-firebase-project-id>
```
นำไฟล์ `firebase_options.dart` ที่ได้มาแยกตาม environment ไว้ใน `lib/firebase_options/firebase_options_{dev,sit,uat,prod}.dart`
> จุดที่แตกต่างกันในแต่ละ env: **Android** ต่างกันที่ `appId`, ส่วน **iOS** ต่างกันที่ `iosBundleId` และ `appId`

---

### 6. ตั้งค่า Push Notifications (FCM + Local Notifications — Android & iOS)

โปรเจกต์นี้ใช้ `firebase_messaging` คู่กับ `flutter_local_notifications` (จัดการใน `lib/src/core/utils/firebase_messaging_service.dart`, `func.dart`, และ `lib/app.dart`)

#### 6.1 ตั้งค่าฝั่ง Android
1. **สิทธิ์ใน `android/app/src/main/AndroidManifest.xml`**:
   - เพิ่มสิทธิ์สำหรับ Android 13+ (API 33+):
     ```xml
     <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
     <uses-permission android:name="android.permission.INTERNET"/>
     ```
   - กำหนด Default Notification Channel (แนะนำ):
     ```xml
     <meta-data
         android:name="com.google.firebase.messaging.default_notification_channel_id"
         android:value="high_importance_channel" />
     ```
2. **เปิด Core Library Desugaring** ใน `android/app/build.gradle` *(จำเป็นสำหรับ `flutter_local_notifications` — โปรเจกต์นี้ตั้งค่าไว้ให้แล้ว)*:
   ```gradle
   compileOptions {
       coreLibraryDesugaringEnabled true
       sourceCompatibility JavaVersion.VERSION_1_8
       targetCompatibility JavaVersion.VERSION_1_8
   }
   dependencies {
       coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.1.4'
   }
   ```
3. **Foreground Notification**: Android ไม่แสดง banner จาก FCM ตอนเปิดแอปอยู่โดยอัตโนมัติ จึงต้องรับผ่าน `FirebaseMessaging.onMessage` แล้วเรียก `Func.showLocalNotification(message.notification)` (ตั้งค่าไว้แล้วใน `lib/app.dart`)

#### 6.2 ตั้งค่าฝั่ง iOS (จำเป็นต้องมี Apple Developer Account)
1. **สร้าง APNs Authentication Key (`.p8`)**:
   - เข้า [Apple Developer Portal](https://developer.apple.com/account/resources/authkeys/list) → **Certificates, Identifiers & Profiles → Keys → +**
   - ตั้งชื่อ Key แล้วติ๊กเลือก **Apple Push Notifications service (APNs)** → กด Continue & Register
   - ดาวน์โหลดไฟล์ `.p8` *(ดาวน์โหลดได้ครั้งเดียวเท่านั้น เก็บไว้ให้ปลอดภัย!)* และจด **Key ID** + **Team ID** (ดูได้จากมุมขวาบนของ Apple Developer Portal)
2. **อัปโหลด `.p8` ขึ้น Firebase Console**:
   - ไปที่ **Firebase Console → Project Settings → Cloud Messaging → Apple app configuration**
   - อัปโหลดไฟล์ `.p8` พร้อมกรอก **Key ID** และ **Team ID**
3. **เปิด Capabilities ใน Xcode**:
   - เปิด `ios/Runner.xcworkspace` ด้วย Xcode
   - เลือก Target **Runner** → แท็บ **Signing & Capabilities** → กด **+ Capability**:
     - เพิ่ม **Push Notifications**
     - เพิ่ม **Background Modes** → ติ๊กเลือก **Background fetch** และ **Remote notifications**
4. **ตั้งค่า `ios/Runner/AppDelegate.swift`**:
   - ให้แน่ใจว่าตั้ง `UNUserNotificationCenter.current().delegate = self` เพื่อรองรับการแสดง notification ตอนเปิดแอปอยู่

#### 6.3 การจัดการ 3 สถานะของ Notification และวิธีทดสอบ
| สถานะแอป | Handler ที่ทำงาน | ตำแหน่งในโปรเจกต์ |
|---|---|---|
| **Foreground** (เปิดแอปอยู่) | `FirebaseMessaging.onMessage` → `Func.showLocalNotification` | `lib/app.dart` |
| **Background** (พับแอปไว้แล้วกด noti) | `FirebaseMessaging.onMessageOpenedApp` → `actionNotification` | `lib/app.dart` |
| **Terminated** (ปิดแอปสนิทแล้วกด noti) | `FirebaseMessaging.instance.getInitialMessage()` → `actionNotification` | `lib/app.dart` |

**วิธีทดสอบส่ง Push:**
1. รันแอปบนเครื่องจริง (Android หรือ iOS — **iOS แนะนำทดสอบบนเครื่องจริง**) แล้วคัดลอก **FCM Token** ที่ print ออกมาใน console
2. เข้า **Firebase Console → Messaging → Create campaign → Send test message** → วาง FCM Token แล้วกดส่งทดสอบทั้งตอนเปิดแอป, พับแอป, และปิดแอป

---

### 7. เข้ารหัสตัวแปรความลับด้วย `envied`

1. สร้างไฟล์ `.dev.env`, `.sit.env`, `.uat.env`, `.prod.env` ไว้ระดับเดียวกับโฟลเดอร์ `lib/`:
   ```env
   BASE_URL=https://api-dev.example.com
   API_KEY=your_secret_key
   ```
2. กำหนดคลาสใน `lib/src/core/env/env.dart` (`EnvDev`, `EnvSit`, `EnvUat`, `EnvProd`)
3. รัน `build_runner` เพื่อสร้างไฟล์ `env.g.dart`:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

---

### 8. ตั้งค่า Flavors ด้วย `flutter_flavorizr`

1. เตรียมไอคอนแต่ละ env ใน `assets/images/icons/` และเปิด `assets:` ใน `pubspec.yaml`
2. ตรวจสอบค่าใน `flavorizr.yaml` แล้วรันครั้งแรก:
   ```bash
   dart run flutter_flavorizr
   ```
3. **ข้อควรระวังสำหรับการรันครั้งถัดไป:** รันเฉพาะ processor ที่ต้องการ และ **ห้ามรัน `flutter:flavors` ซ้ำ** เพราะจะรีเซ็ตโค้ดใน `lib/flavors.dart`:
   ```bash
   dart run flutter_flavorizr -p android:icons,ios:icons,ide:config
   ```
4. ใช้ `lib/flavors.dart` ดึงค่า `baseUrl` จาก `envied` และรองรับค่า override จาก Firebase Remote Config (`minAppVersion`, `forceUpdateAppVersion`)
5. กดรันแต่ละ Flavor จาก VS Code ผ่าน `.vscode/launch.json` ได้ทันที

---

### 9. สร้าง App Icon และ Code Generation (`flutter_launcher_icons`, `flutter_gen`, `build_runner`)

```bash
# สร้าง Launcher Icon แยกตาม Flavor
dart run flutter_launcher_icons -f flutter_launcher_icons-dev.yaml

# Generate code ทั้งหมด (Retrofit, JsonSerializable, Envied, flutter_gen)
dart run build_runner build --delete-conflicting-outputs
```
> หากไฟล์ generated ไม่อัปเดต ให้รัน `dart run build_runner clean` ก่อนแล้วค่อย `build --delete-conflicting-outputs`

---

### 10. การตั้งค่า `main.dart` และ `app.dart`

- **`lib/main.dart`**:
  1. `WidgetsFlutterBinding.ensureInitialized()` + กำหนด `F.appFlavor`
  2. *(เฉพาะ `flutter_bloc`)* ตั้งค่า `Bloc.observer = AppBlocObserver();`
  3. โหลด `SharedPreferences`
  4. Initialize Firebase ตาม Flavor (`initializeDefault`) + ผูก `FirebaseCrashlytics` (`FlutterError.onError` และ `PlatformDispatcher.instance.onError`)
  5. โหลด `initializeRemoteConfig()`
  6. *(เฉพาะ `flutter_bloc`)* เรียก `await initializeDependencies();` **หลังจากได้ Base URL แล้ว**
  7. Initialize `EasyLocalization` + ล็อกแนวหน้าจอ + รันพร้อม `DevicePreview(enabled: kDebugMode)`
- **`lib/app.dart`**:
  - `RouteObserverService()` สำหรับติดตามหน้าปัจจุบัน
  - `FirebaseMessagingService().init()` + FCM & Local Notification listeners
  - Security (เปิดอัตโนมัติใน `Flavor.prod`): `ScreenProtector` + `freeRASP` (`Talsec`) → ส่งไป `SecurityPage` เมื่อตรวจพบภัยคุกคาม
  - Responsive UI: `ScreenUtilInit(designSize: const Size(360, 690))` + `ResponsiveBreakpoints.builder` (`MOBILE`, `TABLET`, `DESKTOP`, `4K`)

---

### 11. ขั้นตอนการพัฒนา Feature ตามหลัก Clean Architecture

ลำดับการสร้าง Feature ใหม่ (ดูตัวอย่างจริงได้จาก feature `users` ในทั้ง 2 โฟลเดอร์):
`Entity` → `Model` → `Datasource` → `Repository (Domain & Data)` → `Usecases` → `State Management` → `Injector` → `UI Pages` → `Tests`

#### 11.1 Data & Domain Layer (ใช้ร่วมกันทั้ง 2 โปรเจกต์)
1. **Entity** (`lib/src/domain/entities/user_entity.dart`): สืบทอด `Equatable` เก็บเฉพาะ domain fields
2. **Model / DTO** (`lib/src/data/models/remote/users/user_model.dart`):
   - สืบทอด `Equatable with EntityConvertible<Entity, Model>` + `@JsonSerializable()`
   - สามารถสร้างจาก JSON ผ่าน [quicktype.io](https://app.quicktype.io/) (เลือก *Types only, Make all properties final, Make all properties optional, Generate CopyWith, Generate json_serializable annotations*)
3. **Datasource** (`lib/src/data/datasources/remote/users/users_datasource.dart`):
   - ใช้ Retrofit `@RestApi(parser: Parser.FlutterCompute)` เพื่อ parse JSON ใน background isolate (ดูตัวอย่างแบบเขียนเองได้ใน `users_ex_datasource.dart`)
4. **Repository**:
   - Contract (`lib/src/domain/repositories/remote/users/users_repo.dart`) คืนค่า `Future<Either<BaseException, T>>`
   - Implementation (`lib/src/data/repositories/users/remote/users_repo_impl.dart`) แปลง `DioException` → `NetworkException` และ error อื่น ๆ → `NormalException`
5. **Usecases** (`lib/src/domain/usecases/users/user_usecase.dart`): เรียกใช้ Repository ตาม business logic
6. **Barrel Exports (`export_*.dart`)**: รวม export ของแต่ละโฟลเดอร์ (ใช้ extension *Dart Barrel File Generator* แล้วเติม `export_`)

#### 11.2 Presentation & DI — สำหรับ `flutter_bloc/`
- **State Management (`lib/src/presentation/bloc_cubit/users/`)**:
  - `*_bloc.dart` (`part '*_event.dart'`, `part '*_state.dart'`) หรือ `*_cubit.dart` (`part '*_state.dart'`) — แนะนำใช้ `Cubit` เพื่อลด boilerplate
  - ใช้ `sealed class` + `Equatable` (`Initial`, `Loading`, `Success`, `Failure`)
- **DI (`flutter_bloc/lib/src/injector.dart`)**: ลงทะเบียนด้วย `get_it` (`registerLazySingleton` สำหรับ Dio/Datasource/Repo/Usecase, `registerFactory` สำหรับ BLoC/Cubit)
- **UI**: `MultiBlocProvider`, `BlocBuilder`, `BlocListener`, `BlocConsumer`, `BlocSelector` — ปิด BLoC ที่สร้างเองใน `dispose()` เสมอ

#### 11.3 Presentation & DI — สำหรับ `flutter_riverpod/`
- **State Management (`lib/src/presentation/riverpod/users/`)**:
  - แยก `*_state.dart` (`sealed class` + `Equatable`) และ `*_notifier.dart` (Riverpod 3 `Notifier<State>` + `NotifierProvider` / `.autoDispose`)
  - อ่าน dependency ด้วย `ref.read(usersUseCasesProvider)` โดยไม่ต้องส่งผ่าน constructor, ตรวจ `if (!ref.mounted) return;` หลัง `await` และครอบ `try/catch` เสมอ
- **DI (`flutter_riverpod/lib/src/injector.dart`)**: `userdatasourceProvider` → `userRepositoryProvider` → `usersUseCasesProvider`
- **UI**: ครอบ root ด้วย `ProviderScope` และใช้ `ConsumerWidget` / `ConsumerStatefulWidget` กับ `ref.watch`, `ref.listen`, `ref.read(...notifier)`

---

### 12. วิธีรันแอป (แยก `flutter_bloc` และ `flutter_riverpod`)

```bash
# รัน flutter_bloc
cd flutter_bloc
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run --flavor dev

# รัน flutter_riverpod
cd ..\flutter_riverpod
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run --flavor dev
```
> Flavors ที่มีให้ใช้: `dev`, `diffdev`, `sit`, `diffsit`, `uat`, `diffuat`, `prod`

---

### 13. กระบวนการทดสอบ (Unit, Widget & Integration Tests) + การตั้งค่า Emulator

ทั้ง 2 โปรเจกต์ออกแบบการทดสอบตาม **Testing Pyramid** ครบทุกชั้น:
- **Unit Tests**: `NetworkException` (ครบทั้ง 9 `DioExceptionType` + `badResponse` + `SocketException`), `UserModel`/`NetworkErrorModel`, `UsersRepoImpl`, `UsersUsecases` (`Right` & `Left`), และ BLoC/Cubit ทั้ง 5 ตัว หรือ Riverpod Notifiers ทั้ง 5 ตัว (รวม `ref.mounted` ตอน dispose)
- **Widget Tests (`test/widget_test.dart`)**: `ErrorView`, `UserAvatar`, `confirmDelete`, `UsersPage` (loading/empty/error+retry), `UserFormPage` (validation + create/edit mode)
- **Full-Stack Integration Tests (`integration_test/users_flow_test.dart`)**: override เฉพาะ `UsersDatasource` ด้วย `InMemoryUsersDatasource` เพื่อทดสอบทั้ง stack (UI → State → Usecases → `UsersRepoImpl` → Datasource) ครบ 7 E2E Scenarios

#### คำสั่งรันทดสอบ — `flutter_bloc/`
```bash
cd flutter_bloc
flutter test                                                              # Unit & Widget Tests (81 tests)
flutter test -d flutter-tester integration_test/users_flow_test.dart      # Integration Test แบบ Headless (CI)
flutter test integration_test/users_flow_test.dart --flavor dev -d <id>   # Integration Test แบบเห็นหน้าจอจริง
dart analyze test integration_test                                        # Static Analysis
```

#### คำสั่งรันทดสอบ — `flutter_riverpod/`
```bash
cd flutter_riverpod
flutter test                                                              # Unit & Widget Tests (73 tests)
flutter test -d flutter-tester integration_test/users_flow_test.dart      # Integration Test แบบ Headless (CI)
flutter test integration_test/users_flow_test.dart --flavor dev -d <id>   # Integration Test แบบเห็นหน้าจอจริง
dart analyze test integration_test                                        # Static Analysis
```

#### การสร้างและเปิด Android Emulator (`x86_64`) เพื่อรันแบบเห็นหน้าจอจริง
> **สำคัญ:** Flutter เวอร์ชันใหม่ไม่รองรับ Emulator 32-bit (`x86`) ต้องใช้ **`x86_64`** เท่านั้น

```powershell
# 1. ติดตั้ง x86_64 system image (ถ้ายังไม่มี)
& "$env:LOCALAPPDATA\Android\Sdk\cmdline-tools\latest\bin\sdkmanager.bat" "system-images;android-31;google_apis_playstore;x86_64"

# 2. สร้าง AVD (หรือสร้างผ่าน Android Studio → Device Manager)
& "$env:LOCALAPPDATA\Android\Sdk\cmdline-tools\latest\bin\avdmanager.bat" create avd -n Pixel_4_API_31 -k "system-images;android-31;google_apis_playstore;x86_64"

# 3. เปิด Emulator
& "$env:LOCALAPPDATA\Android\Sdk\emulator\emulator.exe" -avd Pixel_4_API_31 -skin 1080x2280

# 4. ดู Device ID แล้วรัน Integration Test
flutter devices
flutter test integration_test/users_flow_test.dart --flavor dev -d emulator-5554
```
> สำหรับ **Windows Desktop**: เปิด Developer Mode (`start ms-settings:developers`) แล้วรัน `flutter test integration_test/users_flow_test.dart -d windows`

#### Pre-PR / CI Checklist
```bash
dart format --output=none --set-exit-if-changed lib test integration_test
dart analyze
flutter test
flutter test -d flutter-tester integration_test/users_flow_test.dart
```

---

### 14. ขั้นตอน Build Release ขึ้น Store (Android Google Play & iOS App Store)

#### 14.1 Pre-Release Checklist (ทำก่อน Build ทุกครั้ง)
1. **อัปเดตเวอร์ชัน** ใน `pubspec.yaml` เช่น `version: 1.0.1+2` *(ต้องเพิ่มตัวเลขหลัง `+` ทุกครั้งที่อัปโหลดขึ้น Store)*
2. **ตรวจสอบ `.prod.env`** ให้ชี้ไปที่ Production API และรัน `dart run build_runner build --delete-conflicting-outputs`
3. **ตรวจสอบ `freeRASP` (`TalsecConfig`) ใน `lib/app.dart`**:
   - เปิดและกรอก `androidConfig` (`packageName`, `signingCertHashes` แบบ SHA-256 Base64, `supportedStores: ['com.android.vending']`)
   - เปิดและกรอก `iosConfig` (`bundleIds`, `teamId`) และ `watcherMail`
4. **สำคัญมาก — ต้องใส่ `--obfuscate --split-debug-info` เสมอตอน Build `prod`**:
   - เพราะใน `lib/app.dart` เมื่อเป็น `Flavor.prod` ระบบ `freeRASP` จะตรวจ `onObfuscationIssues` หากไม่ได้ obfuscate แอปจะถูกส่งไปหน้า `SecurityPage`!
   - เก็บโฟลเดอร์ `build/symbols/` ไว้เพื่ออัปโหลดขึ้น Firebase Crashlytics (จะได้อ่าน stack trace ออก)
5. **ทดสอบบนเครื่องจริง** ด้วย `--release` ก่อนอัปโหลด และรัน `flutter test` ให้ผ่านทั้งหมด

---

#### 14.2 Build & Release ขึ้น Google Play Store (Android)

##### ขั้นตอนที่ 1: สร้าง Upload Keystore (ทำครั้งเดียวและเก็บรักษาให้ดีที่สุด!)
```bash
keytool -genkey -v -keystore android/app/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```
> **ห้าม commit ไฟล์ `.jks` และ `key.properties` ขึ้น Git เด็ดขาด!** (เพิ่มไว้ใน `.gitignore`)

##### ขั้นตอนที่ 2: สร้าง `android/key.properties` และผูกใน `android/app/build.gradle`
สร้างไฟล์ `android/key.properties`:
```properties
storePassword=<รหัสผ่าน-store>
keyPassword=<รหัสผ่าน-key>
keyAlias=upload
storeFile=upload-keystore.jks
```
ใน `android/app/build.gradle` โหลด `key.properties` และตั้ง `signingConfigs.release` (เปลี่ยนจาก `signingConfigs.debug` ใน `buildTypes.release` เป็น `signingConfigs.release`)

##### ขั้นตอนที่ 3: ลงทะเบียน SHA-1 / SHA-256
- ดู fingerprint ของ Upload Key:
  ```bash
  keytool -list -v -keystore android/app/upload-keystore.jks -alias upload
  ```
- นำ **SHA-1** และ **SHA-256** ไปเพิ่มใน **Firebase Console → Project Settings → Android prod app**
- หลังอัปโหลดขึ้น Play Console ครั้งแรก ให้นำ **App signing key certificate (SHA-1 / SHA-256)** จาก **Play Console → Setup → App signing** ไปเพิ่มใน Firebase Console และแปลง SHA-256 เป็น Base64 ใส่ใน `freeRASP` (`signingCertHashes`) ด้วย

##### ขั้นตอนที่ 4: Build `.aab` (สำหรับ Play Store) และ `.apk` (สำหรับ QA ทดสอบ)
```bash
cd flutter_bloc   # หรือ cd flutter_riverpod

flutter clean
flutter pub get

# Build Android App Bundle (.aab) สำหรับอัปโหลดขึ้น Google Play Console
flutter build appbundle --flavor prod --release \
  --obfuscate --split-debug-info=build/symbols/android

# (ตัวเลือก) Build APK สำหรับติดตั้งทดสอบบนเครื่อง Android โดยตรง
flutter build apk --flavor prod --release \
  --obfuscate --split-debug-info=build/symbols/android
```
ไฟล์ที่ได้จะอยู่ที่: `build/app/outputs/bundle/prodRelease/app-prod-release.aab`

##### ขั้นตอนที่ 5: อัปโหลด Crashlytics Symbols (แนะนำ)
```bash
firebase crashlytics:symbols:upload --app=<FIREBASE_ANDROID_APP_ID> build/symbols/android
```

##### ขั้นตอนที่ 6: อัปโหลดและเผยแพร่บน Google Play Console
1. สร้างแอปใหม่ใน [Google Play Console](https://play.google.com/console)
2. กรอกข้อมูล **App Content** ให้ครบ: Privacy Policy URL, Data Safety, Ads declaration, Content Rating, Target Audience, App Access (ใส่ demo account หากแอปต้อง login)
3. เตรียม **Store Listing**: ชื่อแอป, คำอธิบายสั้น/ยาว, App Icon (512×512 PNG), Feature Graphic (1024×500 PNG), Screenshots อย่างน้อย 2 รูป
4. ไปที่ **Testing → Internal testing** (หรือ **Production**) → **Create new release** → อัปโหลด `app-prod-release.aab` → กรอก Release notes → กด **Review release → Start rollout**

---

#### 14.3 Build & Release ขึ้น Apple App Store / TestFlight (iOS)

##### ขั้นตอนที่ 1: เตรียม Apple Developer Portal & App Store Connect
1. เข้า [Apple Developer Portal](https://developer.apple.com) → **Identifiers** → สร้าง App ID ให้ตรงกับ Prod Bundle ID (เปิด **Push Notifications** หากใช้งาน)
2. เข้า [App Store Connect](https://appstoreconnect.apple.com) → **My Apps → + New App** → เลือก iOS, กรอกชื่อแอป, ภาษาหลัก, Bundle ID, และ SKU

##### ขั้นตอนที่ 2: ตั้งค่า Xcode (`ios/Runner.xcworkspace`)
1. ติดตั้ง Pods ให้เรียบร้อย:
   ```bash
   cd ios && pod repo update && pod install && cd ..
   ```
2. เปิด `ios/Runner.xcworkspace` ด้วย Xcode → เลือก Target **Runner**:
   - **Signing & Capabilities**: เลือก **Team**, เปิด *Automatically manage signing* (หรือเลือก Distribution Provisioning Profile), ตรวจสอบ **Bundle Identifier** และ **Push Notifications / Background Modes**
   - **Info.plist**: ตรวจสอบ Privacy Usage Descriptions ทุกตัวที่แอปใช้งาน (เช่น `NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription`, `NSLocationWhenInUseUsageDescription`) และเพิ่ม `ITSAppUsesNonExemptEncryption = NO` หากไม่ได้ใช้การเข้ารหัสเฉพาะทางนอกเหนือจาก HTTPS มาตรฐาน

##### ขั้นตอนที่ 3: Build `.ipa` สำหรับ App Store
```bash
cd flutter_bloc   # หรือ cd flutter_riverpod

flutter clean
flutter pub get

flutter build ipa --flavor prod --release \
  --obfuscate --split-debug-info=build/symbols/ios
```
ไฟล์ที่ได้จะอยู่ที่: `build/ios/ipa/*.ipa` และ Xcode archive ที่ `build/ios/archive/Runner.xcarchive`

##### ขั้นตอนที่ 4: อัปโหลดขึ้น App Store Connect
เลือกวิธีใดวิธีหนึ่ง:
- **วิธี A (ง่ายสุด — Transporter App):** เปิดแอป **Transporter** บน macOS → ลากไฟล์ `.ipa` ใส่ → กด **Deliver**
- **วิธี B (Xcode Organizer):** เปิด `build/ios/archive/Runner.xcarchive` ใน Xcode → กด **Distribute App → App Store Connect → Upload**

##### ขั้นตอนที่ 5: ทดสอบผ่าน TestFlight และส่งตรวจขึ้น App Store
1. รอ Apple ประมวลผล build (~10–30 นาที) จะปรากฏใน **App Store Connect → TestFlight**
2. ทดสอบติดตั้งผ่านแอป TestFlight บน iPhone จริง (รวมถึง Push Notification และ Security check)
3. ไปที่แท็บ **App Store** → กรอก Screenshots (6.9"/6.7" และ 6.5" iPhone), Description, Keywords, Support URL, Privacy Policy URL, App Privacy, Age Rating, และ **App Review Information** (ใส่ demo account หากมีหน้า login)
4. เลือก Build ที่อัปโหลดไว้ → กด **Add for Review → Submit to App Review**

---

### 15. คำสั่งแก้ปัญหาที่พบบ่อย (Troubleshooting)

- **ไฟล์ generated (`.g.dart`, `assets.gen.dart`) ไม่อัปเดต:**
  ```bash
  dart run build_runner clean
  dart run build_runner build --delete-conflicting-outputs
  ```
- **Android Gradle / Desugaring error:** ทั้ง 2 โปรเจกต์ตั้งค่าเป็น **Gradle 8.11.1 / AGP 8.9.1 / Kotlin 2.1.0** พร้อม `coreLibraryDesugaringEnabled true` (`desugar_jdk_libs:2.1.4`) ไว้เรียบร้อยแล้ว
- **Windows Flutter CLI แจ้ง `PathNotFoundException` ที่ `AndroidStudio2021.1\.home`:**
  ย้าย/ลบโฟลเดอร์แคชเก่าของ Android Studio ใน `%LOCALAPPDATA%\Google\` ที่ไม่มีไฟล์ `.home` แล้วรัน:
  ```bash
  flutter config --android-studio-dir "C:\Program Files\Android\Android Studio"
  flutter config --jdk-dir "C:\Program Files\Android\Android Studio\jbr"
  ```
- **iOS CocoaPods build error หลังอัปเดตปลั๊กอิน:**
  ```bash
  cd ios && rm -rf Pods Podfile.lock && pod install --repo-update && cd ..
  ```

---
---

# English Guide (EN)

## Table of Contents (EN)
1. [Quick Start (Running in 5 Minutes)](#1-quick-start-running-in-5-minutes)
2. [Prerequisites](#2-prerequisites)
3. [Project Structure](#3-project-structure)
4. [Core Packages (`pubspec.yaml`)](#4-core-packages-pubspecyaml)
5. [Bundle ID, Firebase & Multi-Environment Setup (`dev` / `sit` / `uat` / `prod`)](#5-bundle-id-firebase--multi-environment-setup-dev--sit--uat--prod)
6. [Push Notifications Setup (FCM + Local Notifications — Android & iOS)](#6-push-notifications-setup-fcm--local-notifications--android--ios)
7. [Encrypted Environment Variables (`envied`)](#7-encrypted-environment-variables-envied)
8. [Flavors Setup (`flutter_flavorizr`)](#8-flavors-setup-flutter_flavorizr)
9. [App Icons & Code Generation](#9-app-icons--code-generation)
10. [App Bootstrap (`main.dart` & `app.dart`)](#10-app-bootstrap-maindart--appdart)
11. [Feature Development Workflow (Clean Architecture)](#11-feature-development-workflow-clean-architecture)
    - [11.1 Shared Data & Domain Layers](#111-shared-data--domain-layers)
    - [11.2 Presentation & DI — `flutter_bloc/`](#112-presentation--di--flutter_bloc)
    - [11.3 Presentation & DI — `flutter_riverpod/`](#113-presentation--di--flutter_riverpod)
12. [Running the App (`flutter_bloc` vs `flutter_riverpod`)](#12-running-the-app-flutter_bloc-vs-flutter_riverpod)
13. [Testing Guide (Unit, Widget & Integration Tests) & Emulator Setup](#13-testing-guide-unit-widget--integration-tests--emulator-setup)
14. [Build & Store Release Guide (Google Play & Apple App Store)](#14-build--store-release-guide-google-play--apple-app-store)
    - [14.1 Pre-Release Checklist (`freeRASP` & Crashlytics)](#141-pre-release-checklist-freerasp--crashlytics)
    - [14.2 Android Release to Google Play Console](#142-android-release-to-google-play-console)
    - [14.3 iOS Release to Apple App Store / TestFlight](#143-ios-release-to-apple-app-store--testflight)
15. [Troubleshooting](#15-troubleshooting)

---

### 1. Quick Start (Running in 5 Minutes)

```bash
# 1. Clone repository
git clone <your-repo-url>
cd flutter_clean_architecture_bloc_cubit_riverpod

# 2. Pick your state management implementation
cd flutter_bloc   # or cd flutter_riverpod

# 3. Install dependencies
flutter pub get

# 4. (macOS / iOS only) Install CocoaPods
cd ios && pod install && cd ..

# 5. Verify setup by running Unit & Widget tests
flutter test

# 6. Run the app on an emulator or device
flutter run --flavor dev
```

---

### 2. Prerequisites
- **Flutter SDK** (3.x) & **Dart SDK** (`>=3.3.2 <4.0.0`) — verify with `flutter doctor`
- **Java 17+** (Android Studio's bundled JBR recommended)
- **Android Studio** + Android SDK + **x86_64** Android Emulator system image
- **Xcode** + **CocoaPods** (`sudo gem install cocoapods`) for iOS builds
- **Node.js & npm** (for `firebase-tools`)
- **Firebase CLI & FlutterFire CLI**
- **Store Accounts:** Google Play Console (\$25 one-time) & Apple Developer Program (\$99/year)

---

### 3. Project Structure

Both `flutter_bloc/` and `flutter_riverpod/` follow the same Clean Architecture layout, differing only in Presentation state management and DI:

```text
<flutter_bloc or flutter_riverpod>/
├── assets/
│   ├── colors/
│   ├── fonts/
│   ├── images/icons/
│   └── localization.xlsx / localization.csv
├── .firebase/                        # Per-environment Firebase configs (dev, sit, uat, prod)
├── .dev.env / .sit.env / .uat.env / .prod.env
├── flavorizr.yaml
├── lib/
│   ├── main.dart                     # Bootstrap: flavor, Firebase, Crashlytics, DI, Localization
│   ├── app.dart                      # Security (freeRASP/ScreenProtector), FCM, Responsive UI
│   ├── flavors.dart                  # Flavor config (title, baseUrl, minAppVersion)
│   ├── firebase_options/             # firebase_options_{dev,sit,uat,prod}.dart
│   └── src/
│       ├── injector.dart             # DI (get_it in flutter_bloc / Provider graph in flutter_riverpod)
│       ├── core/
│       │   ├── config/               # remote_config_service.dart
│       │   ├── constants/            # app_constants.dart, enum_constants.dart
│       │   ├── env/                  # env.dart, env.g.dart (envied)
│       │   ├── exceptions/           # BaseException, NormalException, NetworkException, DatabaseException
│       │   ├── extensions/
│       │   ├── gen/                  # assets.gen.dart (flutter_gen)
│       │   ├── network/              # dio_client.dart, error_model.dart
│       │   └── utils/                # firebase_messaging_service.dart, func.dart, url_launcher_manager.dart, navigator_observation.dart
│       ├── data/
│       │   ├── _mapper/              # entity_convertable.dart
│       │   ├── datasources/remote/   # Retrofit datasources (*.dart, *.g.dart) + export_datasources.dart
│       │   ├── models/remote/        # DTOs + json_serializable (*.dart, *.g.dart) + export_models.dart
│       │   └── repositories/         # Repository implementations (try/catch + Either) + export_repositories.dart
│       ├── domain/
│       │   ├── entities/             # Pure domain entities (Equatable)
│       │   ├── repositories/         # Abstract repository interfaces
│       │   └── usecases/             # Application use cases
│       └── presentation/
│           ├── bloc_cubit/           # (flutter_bloc only) app_bloc_observer.dart + feature BLoCs/Cubits
│           ├── riverpod/             # (flutter_riverpod only) feature Notifiers + States
│           ├── pages/                # splash_page, security_page, home_page, users/*
│           └── widgets/              # global/* (common_widgets, update_dialog), users/*
├── test/                             # Layered Unit & Widget tests
│   ├── helpers/fakes.dart
│   ├── core/exceptions/
│   ├── data/models/
│   ├── data/repositories/
│   ├── domain/usecases/
│   ├── presentation/                 # bloc_cubit/* or riverpod/*
│   └── widget_test.dart
└── integration_test/
    └── users_flow_test.dart          # Full-stack E2E Integration Tests
```

---

### 4. Core Packages (`pubspec.yaml`)

| Category | Packages | Purpose |
|---|---|---|
| **State Management** | `flutter_bloc`, `bloc` / `flutter_riverpod`, `riverpod` | Presentation state management |
| **Dependency Injection** | `get_it` (BLoC) / `riverpod` (Riverpod) | Service locator / Provider graph |
| **Networking** | `dio`, `retrofit`, `pretty_dio_logger`, `dio_curl_logger` | REST API client & HTTP logging |
| **Serialization & Equality** | `json_annotation`, `json_serializable`, `equatable` | JSON codegen & value equality |
| **Functional Error Handling** | `dartz` (`Either<BaseException, T>`) | Explicit `Left(error)` / `Right(data)` results |
| **Env & Flavors** | `envied`, `flutter_flavorizr`, `rename` | Encrypted `.env`, flavors, bundle ID renaming |
| **Firebase** | `firebase_core`, `firebase_crashlytics`, `firebase_remote_config`, `firebase_messaging` | Crash reporting, remote config, push notifications |
| **Security** | `freerasp`, `screen_protector` | RASP threat detection & screenshot/recording protection |
| **UI & Localization** | `flutter_screenutil`, `responsive_framework`, `easy_localization`, `device_preview`, `get` | Responsive scaling, i18n, navigation |
| **Storage & Utilities** | `flutter_secure_storage`, `shared_preferences`, `package_info_plus`, `url_launcher`, `flutter_local_notifications` | Secure token storage, app version checks, local notifications |
| **Testing** | `flutter_test`, `integration_test`, `mockito` | Unit, Widget, and Integration testing |

---

### 5. Bundle ID, Firebase & Multi-Environment Setup (`dev` / `sit` / `uat` / `prod`)

```bash
# Rename bundle ID
dart pub global activate rename
dart pub global run rename setBundleId --value "com.yourcompany.yourapp"
```

1. Create **8 apps** in Firebase Console (4 Android + 4 iOS): `prod`, `dev`, `sit`, `uat`.
2. Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS for every flavor) into `.firebase/<env>/`.
3. Generate `firebase_options` and split into `lib/firebase_options/firebase_options_{dev,sit,uat,prod}.dart`:
   ```bash
   npm install -g firebase-tools
   dart pub global activate flutterfire_cli
   firebase login
   flutterfire configure --project=<your-firebase-project-id>
   ```

---

### 6. Push Notifications Setup (FCM + Local Notifications — Android & iOS)

This template combines `firebase_messaging` with `flutter_local_notifications` (`lib/src/core/utils/firebase_messaging_service.dart`, `func.dart`, and `lib/app.dart`).

#### 6.1 Android Setup
1. **Permissions in `android/app/src/main/AndroidManifest.xml`**:
   ```xml
   <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
   <uses-permission android:name="android.permission.INTERNET"/>
   ```
   Optional default channel meta-data inside `<application>`:
   ```xml
   <meta-data
       android:name="com.google.firebase.messaging.default_notification_channel_id"
       android:value="high_importance_channel" />
   ```
2. **Core Library Desugaring** in `android/app/build.gradle` *(already pre-configured in both folders)*:
   `coreLibraryDesugaringEnabled true` + `coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.1.4'`.
3. **Foreground Display**: Android does not automatically display FCM banners while the app is open; `FirebaseMessaging.onMessage` in `lib/app.dart` forwards them to `Func.showLocalNotification`.

#### 6.2 iOS Setup (Requires Apple Developer Account)
1. **Create APNs Auth Key (`.p8`)**:
   - In [Apple Developer Portal](https://developer.apple.com/account/resources/authkeys/list) → **Keys → +** → enable **Apple Push Notifications service (APNs)** → register and download the `.p8` file *(downloadable once only)*. Note the **Key ID** and **Team ID**.
2. **Upload `.p8` to Firebase Console**:
   - **Firebase Console → Project Settings → Cloud Messaging → Apple app configuration** → upload `.p8` with **Key ID** and **Team ID**.
3. **Enable Xcode Capabilities**:
   - Open `ios/Runner.xcworkspace` → Target **Runner** → **Signing & Capabilities** → add **Push Notifications** and **Background Modes** (*Background fetch* + *Remote notifications*).
4. **Ensure `AppDelegate.swift`** sets `UNUserNotificationCenter.current().delegate = self`.

#### 6.3 Notification Lifecycle & Testing
- **Foreground**: `FirebaseMessaging.onMessage` → `Func.showLocalNotification`
- **Background tap**: `FirebaseMessaging.onMessageOpenedApp` → `actionNotification`
- **Terminated tap**: `FirebaseMessaging.instance.getInitialMessage()` → `actionNotification`
- **Test**: Run on a physical device, copy the printed FCM token, and send a test push from **Firebase Console → Messaging → Send test message**.

---

### 7. Encrypted Environment Variables (`envied`)

Create `.dev.env`, `.sit.env`, `.uat.env`, and `.prod.env` next to `lib/`:
```env
BASE_URL=https://api-dev.example.com
API_KEY=your_secret_key
```
Define fields in `lib/src/core/env/env.dart` and run:
```bash
dart run build_runner build --delete-conflicting-outputs
```

---

### 8. Flavors Setup (`flutter_flavorizr`)

```bash
# Initial setup
dart run flutter_flavorizr

# Subsequent runs (NEVER re-run flutter:flavors or lib/flavors.dart will be reset)
dart run flutter_flavorizr -p android:icons,ios:icons,ide:config
```

---

### 9. App Icons & Code Generation

```bash
dart run flutter_launcher_icons -f flutter_launcher_icons-dev.yaml
dart run build_runner build --delete-conflicting-outputs
```

---

### 10. App Bootstrap (`main.dart` & `app.dart`)

- **`lib/main.dart`**: `WidgetsFlutterBinding` → `F.appFlavor` → `AppBlocObserver` *(BLoC)* → `SharedPreferences` → flavor Firebase + `FirebaseCrashlytics` → `initializeRemoteConfig()` → `initializeDependencies()` *(BLoC, after Base URL is resolved)* → `EasyLocalization` → `SystemChrome` portrait lock → `DevicePreview(enabled: kDebugMode)`.
- **`lib/app.dart`**: `RouteObserverService`, `FirebaseMessagingService`, production security (`ScreenProtector` + `freeRASP` → `SecurityPage`), `ScreenUtilInit`, and `ResponsiveBreakpoints`.

---

### 11. Feature Development Workflow (Clean Architecture)

Order: `Entity` → `Model` → `Datasource` → `Repository (Domain & Data)` → `Usecases` → `State Management` → `Injector` → `UI Pages` → `Tests` *(see the `users` feature as a full working reference)*.

#### 11.1 Shared Data & Domain Layers
- **Entity** (`Equatable`), **Model** (`Equatable with EntityConvertible` + `@JsonSerializable()`), **Datasource** (`@RestApi(parser: Parser.FlutterCompute)`), **Repository** (`Either<BaseException, T>`, mapping `DioException` → `NetworkException` and others → `NormalException`), **Usecases**, and `export_*.dart` barrel files.

#### 11.2 Presentation & DI — `flutter_bloc/`
- `*_bloc.dart` / `*_cubit.dart` with `part`/`part of` and `sealed class` states (`Initial`, `Loading`, `Success`, `Failure`). Prefer `Cubit` for simple flows.
- Register dependencies in `lib/src/injector.dart` with `get_it`; always close manually created BLoCs in `dispose()`.

#### 11.3 Presentation & DI — `flutter_riverpod/`
- `*_state.dart` + `*_notifier.dart` using Riverpod 3 `Notifier<State>` + `NotifierProvider` / `.autoDispose`.
- Wire provider graph in `lib/src/injector.dart`: `userdatasourceProvider` → `userRepositoryProvider` → `usersUseCasesProvider`.
- Always guard with `if (!ref.mounted) return;` after `await` and wrap async calls in `try/catch`.

---

### 12. Running the App (`flutter_bloc` vs `flutter_riverpod`)

```bash
cd flutter_bloc      # or cd flutter_riverpod
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run --flavor dev
```
Available flavors: `dev`, `diffdev`, `sit`, `diffsit`, `uat`, `diffuat`, `prod`.

---

### 13. Testing Guide (Unit, Widget & Integration Tests) & Emulator Setup

Both projects implement the full **Testing Pyramid**:
- **Unit Tests**: `NetworkException` (all 9 `DioExceptionType` branches + `badResponse` + `SocketException`), `UserModel`/`NetworkErrorModel`, `UsersRepoImpl`, `UsersUsecases` (`Right` & `Left`), and all 5 BLoCs/Cubits or Riverpod Notifiers.
- **Widget Tests (`test/widget_test.dart`)**: `ErrorView`, `UserAvatar`, `confirmDelete`, `UsersPage`, and `UserFormPage` validation/modes.
- **Full-Stack Integration Tests (`integration_test/users_flow_test.dart`)**: Overrides only `UsersDatasource` with `InMemoryUsersDatasource`, running UI → State → Usecases → `UsersRepoImpl` → Datasource across 7 E2E scenarios.

```bash
# Run in flutter_bloc/ (81 unit/widget + 7 E2E) or flutter_riverpod/ (73 unit/widget + 7 E2E)
flutter test                                                              # Unit & Widget tests
flutter test -d flutter-tester integration_test/users_flow_test.dart      # Headless integration tests (CI)
flutter test integration_test/users_flow_test.dart --flavor dev -d <id>   # Visual integration tests on Emulator/Device
dart analyze test integration_test                                        # Static analysis
```

#### Creating an `x86_64` Android Emulator (Required by Modern Flutter)
```powershell
& "$env:LOCALAPPDATA\Android\Sdk\cmdline-tools\latest\bin\sdkmanager.bat" "system-images;android-31;google_apis_playstore;x86_64"
& "$env:LOCALAPPDATA\Android\Sdk\cmdline-tools\latest\bin\avdmanager.bat" create avd -n Pixel_4_API_31 -k "system-images;android-31;google_apis_playstore;x86_64"
& "$env:LOCALAPPDATA\Android\Sdk\emulator\emulator.exe" -avd Pixel_4_API_31 -skin 1080x2280
```
> For **Windows Desktop**, enable Developer Mode (`start ms-settings:developers`) and run `flutter test integration_test/users_flow_test.dart -d windows`.

#### Pre-PR / CI Checklist
```bash
dart format --output=none --set-exit-if-changed lib test integration_test
dart analyze
flutter test
flutter test -d flutter-tester integration_test/users_flow_test.dart
```

---

### 14. Build & Store Release Guide (Google Play & Apple App Store)

#### 14.1 Pre-Release Checklist (`freeRASP` & Crashlytics)
1. Bump `version: x.y.z+buildNumber` in `pubspec.yaml` *(increment the build number after `+` for every store upload)*.
2. Verify `.prod.env` and regenerate `env.g.dart` via `dart run build_runner build --delete-conflicting-outputs`.
3. Configure **`TalsecConfig` (`freeRASP`)** in `lib/app.dart`: set `androidConfig` (`packageName`, Base64 SHA-256 `signingCertHashes`, `supportedStores`), `iosConfig` (`bundleIds`, `teamId`), and `watcherMail`.
4. **CRITICAL — Always pass `--obfuscate --split-debug-info` on production builds**: `freeRASP` checks `onObfuscationIssues` in `Flavor.prod` and redirects unobfuscated release builds to `SecurityPage`. Keep `build/symbols/` to upload to Crashlytics.
5. Run all tests and verify a `--release` build on a physical device before uploading.

---

#### 14.2 Android Release to Google Play Console

1. **Generate Upload Keystore** *(keep `.jks` and `key.properties` out of Git!)*:
   ```bash
   keytool -genkey -v -keystore android/app/upload-keystore.jks \
     -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
2. **Create `android/key.properties`** and wire `signingConfigs.release` in `android/app/build.gradle`:
   ```properties
   storePassword=<store-password>
   keyPassword=<key-password>
   keyAlias=upload
   storeFile=upload-keystore.jks
   ```
3. **Register SHA-1 & SHA-256**: Add both Upload Key and Play App Signing Key fingerprints to **Firebase Console → Android prod app**, and add the Base64 SHA-256 hash to `freeRASP` (`signingCertHashes`).
4. **Build Production AAB & APK**:
   ```bash
   cd flutter_bloc   # or cd flutter_riverpod
   flutter clean && flutter pub get

   # Play Store App Bundle (.aab)
   flutter build appbundle --flavor prod --release \
     --obfuscate --split-debug-info=build/symbols/android

   # Optional QA APK
   flutter build apk --flavor prod --release \
     --obfuscate --split-debug-info=build/symbols/android
   ```
   Output: `build/app/outputs/bundle/prodRelease/app-prod-release.aab`
5. **Upload Crashlytics Symbols**:
   ```bash
   firebase crashlytics:symbols:upload --app=<FIREBASE_ANDROID_APP_ID> build/symbols/android
   ```
6. **Publish in Google Play Console**: Complete App Content (Privacy Policy, Data Safety, Content Rating, App Access), Store Listing (512×512 icon, 1024×500 feature graphic, screenshots), upload `.aab` under **Internal testing** or **Production**, and roll out.

---

#### 14.3 iOS Release to Apple App Store / TestFlight

1. **Apple Developer Portal & App Store Connect**: Register the prod App ID (with Push Notifications enabled) and create the app record in [App Store Connect](https://appstoreconnect.apple.com).
2. **Configure Xcode (`ios/Runner.xcworkspace`)**:
   - Run `cd ios && pod repo update && pod install && cd ..`
   - Under **Signing & Capabilities**, select your Team, Distribution signing, Bundle Identifier, and Push Notifications / Background Modes.
   - Add required Privacy Usage Descriptions in `Info.plist` (e.g. `NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription`) and `ITSAppUsesNonExemptEncryption = NO` if using standard HTTPS only.
3. **Build IPA**:
   ```bash
   cd flutter_bloc   # or cd flutter_riverpod
   flutter clean && flutter pub get

   flutter build ipa --flavor prod --release \
     --obfuscate --split-debug-info=build/symbols/ios
   ```
   Output: `build/ios/ipa/*.ipa`
4. **Upload**: Deliver `.ipa` using Apple's **Transporter** app or **Xcode Organizer** (`build/ios/archive/Runner.xcarchive`).
5. **TestFlight & Review**: Wait for processing (~10–30 min), test on a real iPhone via **TestFlight** (including Push Notifications & `freeRASP`), fill out App Store metadata (screenshots, description, privacy, review demo account), select the build, and **Submit to App Review**.

---

### 15. Troubleshooting

- **Stale generated files (`.g.dart` / `assets.gen.dart`)**:
  ```bash
  dart run build_runner clean
  dart run build_runner build --delete-conflicting-outputs
  ```
- **Android Gradle / Desugaring**: Both projects are pre-configured with **Gradle 8.11.1**, **AGP 8.9.1**, **Kotlin 2.1.0**, and `coreLibraryDesugaringEnabled true` (`desugar_jdk_libs:2.1.4`).
- **Windows Flutter CLI `AndroidStudio2021.1\.home` error**: Rename/remove stale empty `AndroidStudio*` folders under `%LOCALAPPDATA%\Google\` and run:
  ```bash
  flutter config --android-studio-dir "C:\Program Files\Android\Android Studio"
  flutter config --jdk-dir "C:\Program Files\Android\Android Studio\jbr"
  ```
- **iOS CocoaPods cache issues**:
  ```bash
  cd ios && rm -rf Pods Podfile.lock && pod install --repo-update && cd ..
  ```
