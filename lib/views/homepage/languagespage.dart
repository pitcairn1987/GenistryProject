
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../apptheme.dart';
import '../../mysharedpreferences.dart';
import '../../translation_keys.dart';

class LanguagesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: AppTheme.backgroundColor1,
      appBar: AppBar(title: Text(Translation.choose_language.tr),),
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilledButton(
                //  style: filledButtonStyle,
                onPressed: () async {
                  await MySharedPreferences.instance.setLanguage('PL');
                  Get.updateLocale( Locale('pl', 'PL'));
                  Navigator.pop(context);
                },
                child:  Text(Translation.polish.tr, style:TextStyle(fontSize: 17)),
              ),
              SizedBox(height: 20,),
              FilledButton(
                onPressed: ()  async{
                  await MySharedPreferences.instance.setLanguage('EN');
                  Get.updateLocale( Locale('en', 'EN'));
                  Navigator.pop(context);
                },
                child:  Text(Translation.english.tr, style:TextStyle(fontSize: 17)),
              ),
              SizedBox(height: 20,),
              FilledButton(
                onPressed: () async{
                  await MySharedPreferences.instance.setLanguage('BY');
                  Get.updateLocale( Locale('be', 'BY'));
                  Navigator.pop(context);
                },
                child:  Text(Translation.belarussian.tr, style:TextStyle(fontSize: 17)),
              ),
            ],
          ),
        ),
      )
    );


  }
}


