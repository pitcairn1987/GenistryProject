import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/AppWriteService.dart';

class RegistrationPageController extends GetxController {
  final userIDController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var lat;
  var lon;

  @override
  void onInit() {
    emailController.text = "";
    passwordController.text = "";
    userIDController.text = "";

    super.onInit();
  }

  Future<dynamic> register() async {
    var ses = await AppWriteService.createAccount(userIDController.text,emailController.text, passwordController.text);
    return ses;
  }

  void onClose() {


    super.onClose();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    userIDController.dispose();
    super.dispose();
  }
}
