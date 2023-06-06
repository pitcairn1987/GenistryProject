import 'package:appwrite/appwrite.dart' hide Locale;
import 'package:appwrite/models.dart';
import 'package:camera_app/views/homepage/languagespage.dart';
import 'package:camera_app/views/homepage/themepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../appsettings.dart';
import '../../apptheme.dart';
import '../../services/AppWriteService.dart';
import '../../translation_keys.dart';
import '../loginpage.dart';

class ExampleDestination {
  const ExampleDestination(this.label, this.icon, this.selectedIcon);

  final String label;
  final Widget icon;
  final Widget selectedIcon;
}



class HomePageDrawer extends StatelessWidget {

  var selectedIndexValue = 0.obs;

  @override
  Widget build(BuildContext context) {

    List<ExampleDestination> mainDestinations = <ExampleDestination>[
      AppSettings.loginInfo.userName == ""
          ?  ExampleDestination(Translation.log_in.tr, Icon(Icons.login_outlined, color: AppTheme.drawerIconColor), Icon(Icons.login, color: AppTheme.drawerIconColor))
          :ExampleDestination(Translation.log_out.tr, Icon(Icons.logout_outlined, color: AppTheme.drawerIconColor), Icon(Icons.logout, color: AppTheme.drawerIconColor)),

    ];

    List<ExampleDestination> settingsDestinations = <ExampleDestination>[

      ExampleDestination(
          Translation.theme.tr, Icon(Icons.color_lens_outlined, color: AppTheme.drawerIconColor), Icon(Icons.color_lens, color: AppTheme.drawerIconColor)),
      ExampleDestination(
          Translation.location.tr, Icon(Icons.language_outlined, color: AppTheme.drawerIconColor), Icon(Icons.language, color: AppTheme.drawerIconColor)),
    ];


    List<ExampleDestination> otherDestinations = <ExampleDestination>[
      ExampleDestination(
          Translation.privacy_policy.tr, Icon(Icons.policy_outlined, color: AppTheme.drawerIconColor), Icon(Icons.policy, color: AppTheme.drawerIconColor)),
      ExampleDestination(
          Translation.contact_support.tr, Icon(Icons.contact_support_outlined, color: AppTheme.drawerIconColor), Icon(Icons.contact_support, color: AppTheme.drawerIconColor)),

      ExampleDestination(
          "Genistry Telegram", Icon(Icons.telegram_outlined, color: AppTheme.drawerIconColor), Icon(Icons.telegram, color: AppTheme.drawerIconColor)),
    ];





    showLogoutDialog() async {
      return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(Translation.log_out_q.tr),
            actions: <Widget>[

              FilledButton(
                  onPressed: () async {

                    var res = await AppWriteService.logout();
                    await AppSettings.setLoginInfo("", "", "", "");
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage(),
                      ),
                          (Route route) => false,
                    );


                  /*  if (res is AppwriteException) {

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(duration: Duration(seconds: 2), content: Text(res.message!,
                        ),
                        ),
                      );
                    } else {

                      Get.snackbar("", Translation.logged_out.tr,
                          colorText: AppTheme.appBarIconFontColor
                      );

                    }*/




                  },
                  child: Text(Translation.yes.tr)),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(Translation.no.tr),
              ),
            ],
          );
        },
      );
    }



    return Obx(()=> NavigationDrawer(
      //backgroundColor: AppTheme.backgroundColor1,
      backgroundColor: AppTheme.drawerBackground,
      indicatorColor: AppTheme.drawerSelectedColor,

      onDestinationSelected: (selectedIndex) async {

        selectedIndexValue.value=selectedIndex;
        if(selectedIndexValue.value == 0 && AppSettings.loginInfo.userName==""){
          Get.to(LoginPage());
        }
        else if(selectedIndexValue.value == 0 && AppSettings.loginInfo.userName!=""){
          showLogoutDialog();
        }

        else if(selectedIndexValue.value == 1){
          Get.to(ThemesPage());
        }

        else if(selectedIndexValue.value == 2){
         // showLanguageDialog();
          Get.to(LanguagesPage());
        }

        else if(selectedIndexValue.value == 3){
          // showLanguageDialog();
          // Get.to(PrivacyPage());

          //  Navigator.of(context).pushNamed('/privacypolicy');


          final Uri _url = Uri.parse('https://genistry.pl/policyprivacy');

          if (!await launchUrl(_url)) {
            throw Exception('Could not launch $_url');
          }
        }

        else if(selectedIndexValue.value == 4){


          String email = Uri.encodeComponent("genistry2023@gmail.com");
          String subject = Uri.encodeComponent("Genistry help");
          String body = Uri.encodeComponent("");
          print(subject); //output: Hello%20Flutter
          Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");
          if (await launchUrl(mail)) {
            //email app opened
          }else{
            //email app is not opened
          }

        }

        else if(selectedIndexValue.value == 5){


          try {

            if (!await launchUrl(Uri.parse("https://t.me/+T25uNjqAwiszMWZk"), mode: LaunchMode.externalApplication)) {
              //  showToast(sSomethingWrong);
            }
          } catch (ex) {
            //"Could not launch url $ex".printLog();
          }

        }





      },
      selectedIndex: selectedIndexValue.value,
      children: <Widget>[
        Container(
          height: 180,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/drawer_image.jpg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.modulate,)
            ),
          ),
          margin: EdgeInsets.only(bottom: 10),
        ),

        AppSettings.loginInfo.userName == "" ? Container() :
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
          child:
          Text(
            Translation.user.tr + ' ' +AppSettings.loginInfo.userName,
            style: TextStyle( fontSize: 16, color: AppTheme.drawerFontColor),

          ),
        ),



        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Text(
            Translation.main_menu.tr,
            style: TextStyle( fontSize: 16, color: AppTheme.drawerFontColor),
          ),
        ),
        ...mainDestinations.map((destination) {
          return NavigationDrawerDestination(
            label: Text(destination.label, style: TextStyle(fontSize: 16, color: AppTheme.drawerFontColor)),
            icon: destination.icon,
            selectedIcon: destination.selectedIcon,
          );
        }),
     /*    Padding(
          padding: EdgeInsets.symmetric(horizontal: 28),
          child: Divider(color: AppTheme.formIconColor,),
        ),*/
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Text(
            Translation.settings.tr,
           style: TextStyle( fontSize: 16, color: AppTheme.drawerFontColor),
           // style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        ...settingsDestinations.map((destination) {
          return NavigationDrawerDestination(
            label: Text(destination.label,style: TextStyle(fontSize: 16, color: AppTheme.drawerFontColor)),
            icon: destination.icon,
            selectedIcon: destination.selectedIcon,
          );
        }),
       /* Padding(
          padding: EdgeInsets.symmetric(horizontal: 28),
          child: Divider(color: AppTheme.formIconColor,),
        ),*/
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Text(
            Translation.about.tr,
            style: TextStyle( fontSize: 16, color: AppTheme.drawerFontColor),
            // style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        ...otherDestinations.map((destination) {
          return NavigationDrawerDestination(
            label: Text(destination.label,style: TextStyle(fontSize: 16, color: AppTheme.drawerFontColor)),
            icon: destination.icon,
            selectedIcon: destination.selectedIcon,
          );
        }),
        SizedBox(height: 40,),





      ],
    ));




  }
}
