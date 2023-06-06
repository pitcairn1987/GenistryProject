import 'package:appwrite/appwrite.dart' hide Account;
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:camera_app/appsettings.dart';
import 'package:camera_app/services/AppWriteService.dart';
import 'package:camera_app/views/homepage/homepage.dart';
import 'package:camera_app/views/registrationpage/registrationpage.dart';
import 'package:camera_app/views/widgets/customformfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../apptheme.dart';
import '../controllers/loginpage_controller.dart';
import '../translation_keys.dart';




class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LoginPageController loginPageController = Get.put(LoginPageController());
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/cielesze.png"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.5), BlendMode.lighten,)

                ),
              ),
              child: SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                    ),
                    child: Container(
                      width: 500,
                      color: AppTheme.backgroundColor1,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right:20.0, top: 40),
                                child: IconButton(
                                  icon:  Icon(Icons.cancel_outlined, color: AppTheme.formIconColor,size: 30,),
                                  tooltip: Translation.close.tr,
                                  onPressed: () async {
                                    await AppSettings.setShowHomeScreen(true);
                                    // Get.to(HomePage());
                                    Get.offAll(HomePage(),duration: const Duration(milliseconds: 1500), transition: Transition.fadeIn);
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            //  Image(image: AssetImage('assets/logo.png', )),
                         Image.asset(
                           AppTheme.isThemeDark
                               ? 'assets/images/night_logo.png'
                               :'assets/images/light_logo.png',
                              width: 200,
                              height: 200,
                            ),
                            SizedBox(height: 30),
                            Padding(
                              padding: const EdgeInsets.only(left:15, right: 15),
                              child:   CustomFormField(
                                validateMode: AutovalidateMode.onUserInteraction,
                                fieldDescription: Translation.email.tr,
                                enabled: true,
                                fieldController: loginPageController.emailController,
                                maxLength: 30,
                                checkIfEmpty: true,
                                regExp: r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                                inputFillColor: AppTheme.inputFillColor,
                                message: Translation.incorrect_format.tr,

                              ),
                            ),
                            SizedBox(height:20),
                            Padding(
                              padding: const EdgeInsets.only(left:15, right: 15),
                              child:
                              CustomFormField(
                                validateMode: AutovalidateMode.onUserInteraction,
                                fieldDescription: 'password'.tr,
                                isPasswordInput: true,
                                enabled: true,
                                fieldController: loginPageController.passwordController,
                                maxLength: 30,
                                checkIfEmpty: true,
                                //minLength: 8,
                                //minLength: 1,
                                regExp: r"^\S+$",
                                message:  Translation.illegal_signs.tr,
                                inputFillColor: AppTheme.inputFillColor,

                              )
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left:15, right: 15, top: 8),
                              child: OutlinedButton(


                                /*style: FilledButton.styleFrom(
                                    foregroundColor: AppTheme.onButtonColor3,
                                    backgroundColor: AppTheme.buttonColor3,
                                ),*/


                                onPressed: () async {

                                  if (_formKey.currentState!.validate()) {
                                    var res = await AppWriteService.login(
                                        loginPageController.emailController
                                            .text,
                                        loginPageController.passwordController
                                            .text);
                                    if (res is AppwriteException) {
                                  /*    Get.defaultDialog(content: Text(res.code
                                          .toString()
                                          .tr));
*/
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(duration: Duration(seconds: 2), content: Text(res.code
                                            .toString()
                                            .tr,
                                        ),
                                        ),
                                      );







                                    } else if (res is Session) {
                                      await AppSettings.setLoginInfo(
                                          res.userId, res.userId,
                                          res.providerUid, res.$id);
                                      await AppSettings.setShowHomeScreen(true);
                                      Get.snackbar(Translation.logged_in.tr,
                                          Translation.hello.tr + ' ' +
                                              AppSettings.loginInfo.userName,
                                        colorText: AppTheme.appBarIconFontColor
                                      );







                                      Get.offAll(HomePage(),duration: const Duration(milliseconds: 1500), transition: Transition.fadeIn);

                                    }
                                  }
                                },
                                child: Container(
                                  height: 40,
                                  child:
                                  Center(child: Text(Translation.log_in_with.tr + ' Genistry',))
                              /*    Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset('assets/images/logo2.png'),
                                      ),
                                      SizedBox(width: 5,),
                                      Text(Translation.log_in_with.tr + ' Genistry',)
                                    ],
                                  ),*/
                                ),
                              ),
                            ),






                            Padding(
                              padding: const EdgeInsets.only(left:15, right: 15, top: 8),
                              child: FilledButton(
                                child: Container(
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/images/google.png'),
                                      SizedBox(width: 5,),
                                      Text(Translation.log_in_with.tr + ' Google')
                                    ],
                                  ),
                                ),
                                onPressed: () async {
                                  var res = await AppWriteService.loginByProvider("google");

                                  var res2 = await AppWriteService.getAccountInfo();

                                  var res3 =  await AppWriteService.getSession();
                                  if(res3 is Session){
                                    print("//////Session: " +res3.$id);
                                  }

                                  if(res2 is User){
                                    print("//////Account: " + res2.email);
                                    await AppSettings.setLoginInfo(res2.$id, res2.email, res2.email, '');
                                    await AppSettings.setShowHomeScreen(true);
                                    Get.snackbar(Translation.logged_in.tr, Translation.hello.tr + ' ' + AppSettings.loginInfo.userName);
                                    Get.to(HomePage(),duration: const Duration(seconds: 2), );

                                  }

                                  print("accountinfo");
                                //  print(res2);

                                if (res is AppwriteException) {
                                   // Get.defaultDialog(content:Text(res.message!));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(duration: Duration(seconds: 2), content: Text(res.message!,
                                      ),
                                      ),
                                      );
                                  } else  {
                                    var res2 = await AppWriteService.getAccountInfo();

                                    if (res2 is AppwriteException) {
                                    //  Get.defaultDialog(content:Text(res2.message!));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(duration: Duration(seconds: 2), content: Text(res2.message!,
                                      ),
                                      ),
                                      );
                                    } else if (
                                    res2 is Account
                                    ) {
                                     // await AppSettings.setLoginInfo(res2.$id, res2.name, res2.email, res2.$id);
                                      await AppSettings.setShowHomeScreen(true);
                                      Get.snackbar(Translation.logged_in.tr, Translation.hello.tr + ' ' + AppSettings.loginInfo.userName);
                                      Get.to(HomePage(),duration: const Duration(seconds: 2), transition: Transition.circularReveal);
                                    }
                                  }


                                },
                              ),
                            ),









                            Padding(
                              padding: const EdgeInsets.only(left:15, right: 15, top: 8),
                              child: FilledButton(
                                style: ButtonStyle(
                                    foregroundColor:
                                    MaterialStateProperty.resolveWith<Color>((_) {
                                      return  AppTheme.onButtonColor1;
                                    }),
                                    backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>((_) {
                                      return  AppTheme.buttonColor1;
                                    }),

                                ),
                                child: Container(
                                  height: 40,
                                  child: Center(child: Text(Translation.register.tr,)),
                                ),
                                onPressed: () async {

                                  var result = await Get.to(RegistrationPage());
                                  if(result==true)    Get.snackbar(Translation.success_register.tr, Translation.you_can_login.tr, colorText: AppTheme.appBarIconFontColor);


                                },
                              ),
                            ),

                            SizedBox(
                              height: 30.0,
                            ),


                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        )
    );
  }
}
