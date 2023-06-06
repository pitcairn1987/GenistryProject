import 'package:appwrite/appwrite.dart' hide Account;
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:camera_app/services/AppWriteService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../apptheme.dart';
import '../../controllers/registrationpage_controller.dart';
import '../../translation_keys.dart';
import '../widgets/customformfield.dart';


class RegistrationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final RegistrationPageController registrationPageController = Get.put(RegistrationPageController());
    final _formKey = GlobalKey<FormState>();


    return Scaffold(
        backgroundColor: AppTheme.backgroundColor1,
        appBar: AppBar(backgroundColor: AppTheme.backgroundColor1,),
        body: Container(
         // margin: EdgeInsets.only(left: 30, right: 30, top: 20),
          child: Form(
            key:_formKey,
            child: SingleChildScrollView(
              child: Column(
                 mainAxisSize: MainAxisSize.min,
                children: [

                  SizedBox(height: 50),

                  Padding(
                    padding: const EdgeInsets.only(left:15, right: 15),
                    //child: LoginFormField("Login", registrationPageController.userIDController),
                    child: CustomFormField(
                      validateMode: AutovalidateMode.onUserInteraction,
                      fieldDescription: Translation.login.tr,
                      enabled: true,
                      fieldController: registrationPageController.userIDController,
                      maxLength: 12,
                      minLength: 5,
                      checkIfEmpty: true,
                     // regExp: r"^[\p{L}0-9]*$",
                      message: "Tylko litery lub cyfry",
                      inputFillColor: AppTheme.inputFillColor,
                    )


                  ),
                  SizedBox(height:20),
                  Padding(
                    padding: const EdgeInsets.only(left:15, right: 15),
                   // child: LoginFormField("Email", registrationPageController.emailController),
                    child: CustomFormField(
                      validateMode: AutovalidateMode.onUserInteraction,
                      fieldDescription: Translation.email.tr,
                      enabled: true,
                      fieldController: registrationPageController.emailController,
                      maxLength: 30,
                      checkIfEmpty: true,
                      regExp: r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                      message: Translation.incorrect_format.tr,
                      inputFillColor: AppTheme.inputFillColor,
                    )

                  ),
                  SizedBox(height:20),
                  Padding(
                    padding: const EdgeInsets.only(left:15, right: 15),
                   // child: LoginFormField("Hasło", registrationPageController.passwordController),
                    child: CustomFormField(
                      validateMode: AutovalidateMode.onUserInteraction,
                      fieldDescription: Translation.password.tr,
                      enabled: true,
                      fieldController: registrationPageController.passwordController,
                      maxLength: 15,
                      minLength: 8,
                      checkIfEmpty: true,
                      regExp: r"^[^ ]+$",

                      inputFillColor: AppTheme.inputFillColor,
                      message: Translation.illegal_signs.tr,
                    )
                  ),
                  SizedBox(
                    height: 30.0,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left:15, right: 15, bottom:20),
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                      //  minimumSize: Size(20, 40),
                         // maximumSize: Size(20, 40)
                      ),
                      onPressed: () async {

    if (_formKey.currentState!.validate()) {
                        var res = await AppWriteService.createAccount(
                            registrationPageController.userIDController.text, registrationPageController.emailController.text, registrationPageController.passwordController.text);
                        if (res is AppwriteException) {
                        //  Get.defaultDialog(content:Text(res.code.toString().tr));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(duration: Duration(seconds: 2), content: Text(res.code.toString().tr,
                            ),
                            ),
                          );



                        } else if (res is User) {
                          //var b = await AppWriteService.login(res.email, registrationPageController.passwordController.text);
                          //var c =  await AppWriteService.sentVerificationEmail();
                          // Get.snackbar("Zarejestrowano: ", "${res.$id}");
                          // await AppSettings.setLoginInfo(res.userId, res2.name, res.providerUid, res.$id);
                          // await AppSettings.setShowHomeScreen(true);
                          // Get.snackbar("Zarejestrowano", "Witaj ${AppSettings.loginInfo.userName}");
                          Get.back(result: true);

                        }

                      }},

                      child: Text(Translation.register.tr),
                    ),
                  )



                ],
              ),
            ),
          ),
        ));
  }
}
