
import 'package:path_provider/path_provider.dart';
import 'mysharedpreferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';

class LoginInfo {
  String userId;
  String userName;
  String userEmail;
  String sessionId;

  LoginInfo(this.userId, this.userName, this.userEmail, this.sessionId);
}





class AppSettings {
  static bool showHomeScreen = false;
  static late String applicationDirectoryPath;
  static late String temporaryDirectoryPath;
  static late LoginInfo loginInfo;
  static  double ? deviceMaxSize;
  static late String language;
  static late String theme;

  static int sendInfo = 0;



  static init() async {
    showHomeScreen = await MySharedPreferences.instance.getShowHomePage();
    loginInfo = await MySharedPreferences.instance.getLoginInfo();
    language = await MySharedPreferences.instance.getLanguage();
    theme = await MySharedPreferences.instance.getTheme();


    if (!kIsWeb && Platform.isAndroid) {
      // Set web-specific directory


      await getApplicationDocumentsDirectory().then((value) => applicationDirectoryPath = value.path);
      await getTemporaryDirectory().then((value) => temporaryDirectoryPath = value.path);
    } else {
      applicationDirectoryPath = "";
      temporaryDirectoryPath = "";
    }
  }

  static setShowHomeScreen(bool value) async {
    showHomeScreen = value;
    await MySharedPreferences.instance.setShowHomePage(value);
  }

  static setLoginInfo(String userId, String userName, String userEmail, String sessionId) async {
    loginInfo = new LoginInfo(userId, userName, userEmail, sessionId);
    await MySharedPreferences.instance.setLoginInfo(userId, userName, userEmail, sessionId);
  }


  static setDeviceMaxSize(double size) async {
    deviceMaxSize = size;
  }




}
