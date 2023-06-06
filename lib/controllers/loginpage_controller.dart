import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/AppWriteService.dart';

class LoginPageController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var lat;
  var lon;

  var size;

  @override
  void onInit() {
    emailController.text = "";
    passwordController.text = "";

    super.onInit();
  }

  Future<dynamic> login() async {
    var ses = await AppWriteService.login(emailController.text, passwordController.text);
    return ses;
  }

  void onClose() {

    super.onClose();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }
}
