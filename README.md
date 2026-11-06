# flutter_clean_architecture_bloc_cubit_riverpod_template

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

for setup project template clean architecture (th/en)
1.ติดตั้ง package ใน pubspec.yaml ให้ครบอันไหนที่ต้องใช้และไม่ต้องใช้
2.จัดโครงสร้าง folder ตามนี้

1.setup pub.dev like pubspec.yaml required or option
2.setup structure folder

- assets/
  - colors/
  - fonts/
  - images/
- lib
  - firebase_options for different env launch/
  - src/
    - core/
      - config/
        - remote_config_service.dart
      - gen(for flutter_gen asset)/
      - constants (variable)/
      - env(envied generate)/
      - exceptions (for all error)/
      - extension (for easy manage type function variable)/
      - utils (service)/
    - data/
      - datasources/
        - \_mapper/
          - entity_convertable.dart
        - local/
          - (feature)/
            - xxx_datasource_impl.dart
            - xxx_datasource.dart
        - remote/
          - (feature)/
            - xxx_datasource.dart
            - xxx_datasource.g.dart (form generate retrofit)
        - export_datasource.dart (include export datasource path for clean)
      - models(dtos)/
        - local/
          - request/
            - req_xxx_model.dart
          - response/
            - res_xxx_model.dart
        - remote/
          - request/
            - req_xxx_model.dart
            - req_xxx_model.g.dart (json_annotation generate)
          - response/
            - res_xxx_model.dart
            - res_xxx_model.g.dart (json_annotation generate)
        - export_model.dart (include export datasource path for clean)
      - repositories/
        - (feature)/
          - local (if have)/
            - xxx_repo_impl.dart
          - remote/
            - xxx_repo_impl.dart
        - export_repo_impl.dart
    - domain/
      - entities/
        - local/
          - request/
            - req_xxx_entity.dart
          - response/
            - res_xxx_entity.dart
        - remote/
          - request/
            - req_xxx_entity.dart
          - response/
            - res_xxx_entity.dart
      - repositories/
        - (feature)/
          - local (if have)/
            - xxx_repo.dart
          - remote/
            - xxx_repo.dart
      - usecases/
        - (feature)/
          - feature_usecase.dart
        - export_usecase.dart
    - presentation/
      - pages/
        - (feature)/
          - xxx_page.dart
        - core/
          - splash_page.dart
          - maintenance_page.dart
          - dashboard_page.dart
      - xxx (xxx is your riverpod,bloc.cubit)
        - (feature)/
          - local/
            - check_session/
              - xxx_notifier.dart
              - xxx_state.dart
          - remote/
            - login/
              - xxx_notifier.dart
              - xxx_state.dart
      - widgets/
        - global/
        - (feature)/
          - xxx_widget.dart
    - xxx_injector.dart (xxx is yourname state management)
  - main.dart
- test/
  - integration_test (ui test overall) (patrol)(integration_test)
  - unit_test (test function and module)(mockito)

    3.ติดตั้ง env ตามที่คุณมีและในอนาคต เช่น dev sit uat prod ที่เป็นพื้นฐาน
    ไปยัง firebase console ที่เว็บ และสร้าง project และสร้าง app ทั้งหมด 8 แอป โดยแบ่งเป็น ios 4 แอป และ android 4 แอป เพื่อเอาไว้แบ่งทดสอบ env เช่น

    1.com.yourcompany.yourapp (it is prod)
    2.com.yourcompany.yourapp.dev (it is dev)
    3.com.yourcompany.yourapp.sit (it is sit)
    4.com.yourcompany.yourapp.uat (it is uat)

    หากต้องการ setting bundleid ของแอปใหม่สารมารถใช้คำสั่งต่อไปนี้ที่ terminal ได้
    $ flutter pub global activate rename
    $ flutter pub global run rename setBundleId --value "com.yourcompany.yourapp"

    หลังจากสร้างเสร็จทั้งหมดให้โหลดไฟล์ที่ setting --> general --> your app
    จากนั้นเลือกที่แอป android ก่อน จะมีให้ download google-service.json สำหรับ android โหลดแค่อันเดียวพอ ส่วน ios ต้องโหลด googleservice-info.plist ให้ครบทุกแอป
    และหลังจากนั้นทำการสร้างไฟล์ .firebase ขึ้นมา และสร้าง folder แต่ละ env ขึ้นมา และ นำ ไฟล์ที่โหลดมาจาก firebase app ไปใส่ตาม env ทั้งหมด
    และหลังจากนั้นทำการสร้าง app flutter ที่ firebase console
    และทำตามขั้นตอน
    install firebase cli
    $ npm install -g firebase-tools
    ถ้ายังไม่มี npm ให้ลง
    $ npm install -g npm@latest (windows)
    $ sudo npm install -g npm@latest

    ที่ terminal
    $ dart pub global activate flutterfire_cli
    $ firebase login
    $ flutterfire configure --project=xxxx
    y
    y
    enter
    หลัง run เสร็จเราจะได้ ไฟล์ firebase_option ที่ระบบ gen มาให้เอามาแบ่ง env และวางใน folder firebase_options
    จุดแตกต่างทื่ต้องเปลี่ยนในไฟล์ของ android คือ appid
    ios คือ iosbundleid และ appid

    และหลังจากนั้น
    สร้างไฟล์ ต่อไปนี้เพื่อใช้สำหรับดึงข้อมูลความลับของแต่ละ env และทำการเข้ารหัส ตัวอย่างข้อมูลคือ apikey , base url ,key secure ต่างๆ ใน
    - .dev.env
    - .sit.env
    - .uat.env
    - .prod.env
      สร้างให้อยู่ระดับเดียวกับ folder lib
      หลังจากนั้นเราก็จะมาสร้างไฟล์ใน folder env คือ env.dart
      อิงโครงสร้างตามนี้เลยประยุคตามชื่อตัวแปรใน env ของคุณได้เลย
      หลังจากทำเสร็จแล้วใช้คำสั่งนี้รันใน terminal
      $ dart run build_runner build
      จะได้ file env.g.dart มา

    ต่อไปสร้างไฟล์ flavorize.yaml
    เตรียม icon ให้พร้อม นำไว้ที่ assets ให้ครบ
    ที่สำคัญอย่าลืมเปิดใช้ assets ที่ pubspec
    อยู่ระดับเดียวกับ folder lib
    โครงสร้างตามไฟล์ตัวอย่างเลย
    firebase config , bundleid ,application id
    และใช้คำสั่ง
    flutter pub run flutter_flavorizr ในครั้งแรกเมื่อ setup เสร็จ
    และครั้งต่อไปแนะนำให้ใช้คำสั่งนี้

    flutter pub run flutter_flavorizr -p <processor_1>,<processor_2>

    Example
    android:icons , ios:icons ส่วนนี้สำหรับ re icon แต่ละ env ใหม่ โดยไม่กระทบส่วนอื่น
    ide:config อันนี้จะ generate ส่วนรันแอปให้ตาม env ที่เรากำหนดเลย แล้วแต่ถนัด แต่แนะนำให้เอาของที่มีไปใช้เลย จะง่ายกว่า

    $ flutter pub run flutter_flavorizr -p android:icons , ios:icons , ide:config
    เนื่องจากหลังจากรันครั้งแรกเราจะได้ไฟล์ flavors.dart มา
    และเราจะนำไปใช้ร่วมกับ envied ที่ generate มาด้วย
    ตัวอย่างสามารถดูในไฟล์ได้
    ซึ่งเราสามารถนำมาเรียกใช้แยก flavor ของแต่ละส่วนได้ที่นี่ในครั้งต่อไปถ้าจะ รัน flavorizr ใหม่แนะนำอย่าให้รัน flutter:flavors เด็ดขาดถ้าไม่งั้นไฟล์จะreset
    ตัวอย่างที่อยู่ในไฟล์คือ ผมทำการดึงข้อมูลจาก env ที่ gen ไว้ก่อนหน้าเอามาร่วมใช้กับไฟล์นี้เพื่อจัดการ การแยก env ที่ไฟล์นี้ทีเดียวจะได้ง่ายต่อการจัดการ

    ส่วนไฟล์ main จะถูก gen จาก process
    flutter:main ของ flavorizr ด้วยเผื่อเรียกว่าเรารัน flavor ไหนมา

    หลังจากนั้นเราก็มา setting ใน run vscode ตามใน
    .vscode/launch.json แบ่งตาม envไว้แล้ว
    จริงๆเราได้ส่วน gen มาจาก flavorizr แล้วแต่เราต้องมา custom เพิ่มเพื่อแยก firebase เองอีกทีซึ่งผมแนะนำให้ copy ส่วนนี้มาใช้เลยจะได้ง่าย
    ส่วน firebase และ อื่นๆ setup ตามใน file main.dart ได้เลย
    ถือเป็นอันเสร็จสิ้นการแยก env ทั้งหมด

4. setup main.dart
   setup navigator_observation.dart (core/utils/navigator_observation)
   และเอาไปติดตั้งไว้ใน widget material app เพื่อใช้ดูว่า page ปัจจุบันที่อยู่คือ page อะไร ()
   firebase_options
   widgetbinding
   sharepreferences ถ้าใช้
   firebase crashlytic
   ตั้งค่าแนวตั้งแนวนอน setPreferredOrientations
   devicepreview ui

5. setup app.dart
   จะเป็นส่วนไว้ setup security , firebase_message ,local notification ,remote config firebase ,responsive ui
   สร้าง myhomepage stful ใน app.dart
   สร้างไฟล์ firebase_messaging_Service.dart เพื่อตั้งค่า firebase message เรียกมา setup ที่ initstate func ใน homepage
   อย่าลืมไป setup firebase ที่ console ด้วย
   สำคัญ ios ต้องไปสร้าง apn ใน apple develop ไฟล์ .8p
   และนำไปอัพโหลดใน cloud firebase
   ส่วนอื่นสามารถคัดลอกไปวางได้เลยเพราะคิดว่าจำเป็นหมดและสามารถประยุกต์ได้
   ส่วนของ securitypage ทำเพื่อตรวจพบความผิดปกติจะบังคับไปยังหน้านั้นทันทีเมื่อเป็น prod และ เอาไว้โหลด firebase config ก่อนนำไปยัง splash screen เพื่อเช็คเวอร์ชันจาก config ว่าตรงกันไหมนหน้า splash ต่อไป
   สร้าง stateless page(stl) หรือ stateful page (stf)ให้พิใตัวย่อ
   ติดตั้ง responsive ui (screenutils ด้วย)

6. //laucher-icon
   gen laucher icon แยก env
   สร้างตาม env ที่มี
   flutter_laucher_icons-(flavor).yaml
   และกำหนดค่าให้เรียบร้อยให้ครบทุก env และ รันคำสั่ง
   $ dart run flutter_launcher_icons -f <your config file name here>
   รันให้ครบที่ env ที่เรามีหรือแก้ไข icon ใหม่ก็มาใช้คำสั่งนี้รันเปลี่ยนได้

   //flutter_gen
   เป็นการ gen path ทั้งหมดใน asset รวมถึง font color png svg และอื่น แก้ปัญหาเวลาเรียก path หรือเขียนผิด
   จะ gen ส่วนไหนต้องเพิ่ม asset path ไปจนถึงรูปนั้นๆด้วย
   ใช้ buildrunner gen โดย setting จะใส่ไว้ที่ส่วนล่างสุดของ pubspec.yaml

   **\*\*** หมายเหตุถ้า package ไหนเกิด build แล้วไฟล์ generate ไม่ขึ้นให้ใช้คำสั่งต่อไปนี้
   $ dart run build_runner clean
   $ dart run build_runner build --delete-conflicting-outputs

7. ก่อนจะเริม feature ใดจะสร้าง ui ก่อนก็ได้หรือจะเริ่มที่  
   entity_convertable.dart->entity->model->datasource->repository(domain/data)->usecases->statemanagement(riverpod)->injector(riverpod_provider)
   ->ui(call state management)
   model สามารถนำ json ไปวางและนำ model มาใช้ได้เลย ที่เว็บ
   https://app.quicktype.io/
   model
   select
   -Types only
   -Make all properties final
   -Make all properties optional
   -Generate CopyWith method
   -Generate annotations for json_serializable
   -Merge similar classes
   datasource function ใน class จะใช้ model
   repository function ใน class จะใช้ entity try catch exception ใช้ในนี้

   และ ใน model จะต้อง with ต่อจาก extend ด้วยเพื่อง่ายสำหรับ convert entity to model
   ส่วน export\*\_.dart ให้ใช้ extension Dart Barrel File Generator วิธีใช้ คลิกขวาที่ โฟลเดอร์ใหญ่แล้วเลือก GDBF:FOLDER'S FILES (RECURSIVE) คือการเรียก export ทุกไฟล์ dart มายังไฟล์หลักและสร้างชื่อตามไฟล์ที่เรา คลิกขวา หลังจาก generate เสร็จทำการแก้เพิ่มชื่อ export\_\_.dart นำหน้าด้วยเพื่อแยกออก

   ทำการสร้าง stat management ขึ้นมาแบ่งเป็น state file และ provider file หลังจากสร้างเสร็จแล้วทำการ เชื่อม injector ตามโครงสร้างทั้งหมดได้เลยหากมี constructor แยกอะไรบ้างก็เรียกผ่าน provider watch ได้ลเยส่วน ตั้งแต่ dio datasource ยาวไปจนถึง usecase provider ได้เลย ส่วนใน statemangement เรียก usecase provider มาใช้โดยไม่มี constructor ได้เลยเพราะ riverpod 3.0 เปลี่ยนจาก statenotifierprovider มาเป็น notifier provider แล้วยังเปลี่ยนวิธีการเรียกไปด้วย

   และส่วนสุดท้ายอย่าลืมไป setup future provider ว่าใช้อะไรบ้างใน flavors.dart และไป setting variable ใน firebase remote config ที่เว็บด้วย
   สร้างตัวแปรแต่ละ env ให้เรียบร้อยและแยก variable env ไปยังไฟล์แต่ละ env หากไมม่ีให้สร้าง
   เวอร์ชันแอปปรับได้ที่ pubspec.yaml

   ทำการสร้างหน้า ui ทั้งหมด

หมายเหตุ @RestApi(parser: Parser.FlutterCompute) ใช้สำหรับ compute isolate ได้เลย และตัวอย่างการใช้แบบไม่ generator ก็อยู่ใน datasource

//bloc ทำตามขั้นต้น
bloc observe ลง main.dart
injector ใช้ get_it
pubspec flutter_bloc bloc get_it

ใช้คลุม scope ใช้
BlocProvider Inject BLoC/Cubit ให้ Widget
MultiBlocProvider รวม BlocProvider หลายตัว

BlocBuilder สร้าง UI ใหม่เมื่อ State เปลี่ยน
BlocConsumer ใช้ทั้ง Builder และ Listener
BlocSelector เลือกเฉพาะ State บางส่วนเพื่อ Update UI

แนะนำควรเปลี่ยน bloc เป็น cubit เพื่อลด boiled plate
ิ*\_bloc.dart หรือ *_cubit.dart
เรียก part \*_\*.dart
และ part of ของ \*.dart

// ลงทะเบียน Dependency หลังจากได้ Base URL แล้ว
await initializeDependencies();
