
import 'package:camera_app/translation_keys.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';
import '../../apptheme.dart';
import '../../mysharedpreferences.dart';

class ThemesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.backgroundColor1,
        appBar: AppBar(title: Text(Translation.theme.tr)),
        body: Container(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FilledButton(
                  //  style: filledButtonStyle,
                  onPressed: () async {

                    AppTheme.isThemeDark = false;
                    Get.changeThemeMode(ThemeMode.light);
                    await MySharedPreferences.instance.setTheme('light');
                    Restart.restartApp();
                    //Phoenix.rebirth(context);


                  },
                  child:  Text("Jasny", style:TextStyle(fontSize: 17)),
                ),
                SizedBox(height: 20,),
                FilledButton(
                  onPressed: ()  async{
                    AppTheme.isThemeDark = true;
                    Get.changeThemeMode(ThemeMode.dark);
                    await MySharedPreferences.instance.setTheme('dark');
                    Restart.restartApp();
                   //Phoenix.rebirth(context);
                  },
                  child:  Text("Ciemny", style:TextStyle(fontSize: 17)),
                ),

              ],
            ),
          ),
        )
    );


  }
}


