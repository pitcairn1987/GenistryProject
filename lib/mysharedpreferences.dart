import 'package:camera_app/appsettings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  MySharedPreferences._privateConstructor();

  static final MySharedPreferences instance = MySharedPreferences._privateConstructor();

  setDataBaseExist(bool value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setBool('DataBaseExist', value);
  }

  Future<bool> getDataBaseExist() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getBool('DataBaseExist') ?? false;
  }

  setDataBaseVer(String value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString('DataBaseVer', value);
  }

  Future<String> getDataBaseVer() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString('DataBaseVer') ?? '';
  }



  setLanguage(String value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString('Language', value);
  }

  Future<String> getLanguage() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString('Language') ?? '';
  }


  setTheme(String value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString('Theme', value);
  }

  Future<String> getTheme() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString('Theme') ?? '';
  }




  /* setUserID(int value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setInt('UserID', value);
  }

  Future<int> getUserID() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getInt('UserID') ?? '';
  }*/

  setUserID(String value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString('UserID', value);
  }

  Future<String> getUserID() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString('UserID') ?? '';
  }

  setSessionID(String value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString('SessionID', value);
  }

  Future<String> getSessionID() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString('SessionID') ?? '';
  }

  setUserEmail(String value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString('UserEmail', value);
  }

  Future<String> getUserEmail() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString('UserEmail') ?? '';
  }

  setUserName(String value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString('UserName', value);
  }

  Future<String> getUserName() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString('UserName') ?? '';
  }

  setShowHomePage(bool value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setBool('ShowLoginPageOnStartup', value);
  }

  Future<bool> getShowHomePage() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getBool('ShowLoginPageOnStartup') ?? false;
  }

  setLoginInfo(String userId, String userName, String userEmail, String sessionId) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString('UserID', userId);
    myPrefs.setString('UserName', userName);
    myPrefs.setString('UserEmail', userEmail);
    myPrefs.setString('SessionID', sessionId);
  }

  Future<LoginInfo> getLoginInfo() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String userId = myPrefs.getString('UserID') ?? '';
    String userName = myPrefs.getString('UserName') ?? '';
    String userEmail = myPrefs.getString('UserEmail') ?? '';
    String sessionID = myPrefs.getString('SessionID') ?? '';
    LoginInfo info = LoginInfo(userId, userName, userEmail, sessionID);
    return info;
  }
}
