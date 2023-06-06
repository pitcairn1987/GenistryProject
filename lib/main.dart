import 'dart:ui';
import 'package:camera_app/appsettings.dart';
import 'package:camera_app/model/customdocumentHiveModel.dart';
import 'package:camera_app/services/AppWriteService.dart';
import 'package:camera_app/views/addpage/addpage.dart';
import 'package:camera_app/views/homepage/homepage.dart';
import 'package:camera_app/views/loginpage.dart';
import 'package:camera_app/views/revisionspage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'apptheme.dart';
import 'languages.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await AppSettings.init();
  AppTheme.isThemeDark = AppSettings.theme == "dark" ? true : false;
  Hive.init(AppSettings.applicationDirectoryPath);
  AppWriteService.init();
  Hive.registerAdapter(CustomDocumentHiveModelAdapter());


  Widget _defaultPage = new LoginPage();
  if (AppSettings.showHomeScreen) {
      _defaultPage = new HomePage();
    }

    runApp(MyApp(_defaultPage));
}


class MyApp extends StatefulWidget {
  final Widget defaultPage;
  MyApp(this.defaultPage);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {





    super.initState();
  }





  @override
  Widget build(BuildContext context) {


    var locale;

    if (AppSettings.language == '' ) {
      locale = Get.deviceLocale;
    }
    if (AppSettings.language == 'PL' ) {
      locale = Locale('pl', 'PL');
    }
    if (AppSettings.language == 'EN') {
      locale = Locale('en', 'EN');
    }
    if (AppSettings.language == 'BY') {
      locale = Locale('be', 'BY');
    }


      return
        GetMaterialApp(



         getPages: [
        GetPage(
              name: '/details',
              page: () => AddPage(),
            ),
           GetPage(
             name: '/main',
             page: () => HomePage(),
           ),

           GetPage(
             name: '/revisions',
             page: () => RevisionsPage(),
           ),


          ],


            translations: Languages(),
            fallbackLocale: const Locale('pl', 'PL'),
           // locale: locale,
          locale:locale,
          //useInheritedMediaQuery: true,
          title: 'Genistry Mobile',
         // home: NestedScreen(),
         home: widget.defaultPage,

            themeMode: AppSettings.theme == "dark" ? ThemeMode.dark : ThemeMode.light,
            darkTheme: AppTheme.darkTheme,
          theme: AppTheme.darkTheme,
        );

  }
}
