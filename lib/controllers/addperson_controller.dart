import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/customdocument_model.dart';


import '../translation_keys.dart';

class AddPersonController extends GetxController {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final maidenNameController = TextEditingController();
  final birthYearController = TextEditingController();
  final deathYearController = TextEditingController();
  final addInfoController = TextEditingController();
  final ageController = TextEditingController();


  dynamic argumentData = Get.arguments;
  bool updateMode = false;
  Person person = new Person(firstName: '', lastName: '', maidenName: "", birthYear: '', deathYear: '', age: '');



  void populatePerson(){
    person.firstName = firstNameController.text.trim();
    person.lastName = lastNameController.text.trim();
    person.maidenName = maidenNameController.text.trim();
    person.birthYear = birthYearController.text.trim();
    person.deathYear = deathYearController.text.trim();
    person.addInfo = addInfoController.text.trim();
    person.age = ageController.text.trim();
  }


  Future<dynamic> updatePerson() async {
    populatePerson();
    if(validatePersonEmptyFields() == false){
      return Translation.complete_name.tr;
    }
    else return person;
  }




  Future<dynamic> insertPerson() async {
    populatePerson();
    if(validatePersonEmptyFields() == false){
      return Translation.complete_name.tr;
    }
    else return person;
  }



  bool validatePersonEmptyFields(){
    bool result = true;
    if(person.firstName == "" && person.lastName =="") result = false;
    return result;
  }


  void initPerson(){

    var per = argumentData as Person;
    person.firstName = per.firstName;
    person.lastName = per.lastName;
    person.maidenName = per.maidenName;
    person.birthYear = per.birthYear;
    person.deathYear = per.deathYear;
    person.addInfo = per.addInfo;
    person.age = per.age;


  }








  @override
  void onInit() {
    if (argumentData != null) {
      initPerson();
      updateMode = true;

      firstNameController.text = person.firstName ?? "";
      lastNameController.text = person.lastName ?? "";
      maidenNameController.text = person.maidenName ?? "";
      birthYearController.text = person.birthYear ?? "";
      deathYearController.text = person.deathYear ?? "";
      addInfoController.text = person.addInfo ?? "";
      ageController.text = person.age ?? "";
    }

    super.onInit();
  }

  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    maidenNameController.dispose();
    birthYearController.dispose();
    deathYearController.dispose();
    addInfoController.dispose();
    ageController.dispose();

    super.onClose();
  }
}
