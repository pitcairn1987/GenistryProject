import 'package:camera_app/controllers/addpage_controller.dart';
import 'package:camera_app/controllers/addperson_controller.dart';
import 'package:camera_app/model/customdocument_model.dart';
import 'package:camera_app/views/widgets/customformfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../apptheme.dart';
import '../translation_keys.dart';

class AddPerson extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    final addPageController = Get.find<AddPageController>();
    final AddPersonController addPersonController = Get.put(AddPersonController());

    final _formKey = GlobalKey<FormState>();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        floatingActionButton: Visibility(
          visible: addPageController.editControlsVisible.value,
          child: FloatingActionButton(
            heroTag: "btn2",
            onPressed: () async {
                if (_formKey.currentState!.validate()) {
                if (addPersonController.updateMode)
                {
                  var result = await addPersonController.updatePerson();
                  if(result is Person){
                    Get.back(result: result);
                  }
                  else if(result is String)
                  {

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(duration: Duration(seconds: 2), content: Text(result,
                      ),
                      ),
                    );



                  }
                }
                else
                {
                  var result = await addPersonController.insertPerson();
                  if(result is Person){
                    addPageController.personsList.insert(0, result);
                    Get.back();
                  }
                  else if(result is String)
                  {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(duration: Duration(seconds: 2), content: Text(result,
                      ),
                      ),
                    );

                  }
                }
              }


            },
            child:  Icon(Icons.check,color: AppTheme.onButtonColor1),
            backgroundColor: AppTheme.buttonColor1
          ),
        ),
        body: Container(
          color:   AppTheme.backgroundColor1,
          child: Form(
            key: _formKey,
            child: ListView(
              // mainAxisSize: MainAxisSize.min,
              children: [


                SizedBox(
                  height: 10,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    child: CustomFormField(
                      inputFillColor: AppTheme.inputFillColor,
                      validateMode: AutovalidateMode.always,
                      fieldDescription: Translation.name.tr,
                      enabled: addPageController.editControlsVisible.value,
                      fieldController: addPersonController.firstNameController,
                      maxLength: 30,
                      regExp: r"^[\p{L} ]*$",
                      message: Translation.only_letters.tr,

                    )),
                Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    child: CustomFormField(
                      inputFillColor: AppTheme.inputFillColor,
                      validateMode: AutovalidateMode.always,
                      fieldDescription: Translation.lastname.tr,
                      enabled: addPageController.editControlsVisible.value,
                      fieldController: addPersonController.lastNameController,
                      maxLength: 100,
                      regExp: r"^[\p{L} ]*$",
                      message: Translation.only_letters.tr,

                    )),
                Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    child: CustomFormField(
                      inputFillColor: AppTheme.inputFillColor,
                      validateMode: AutovalidateMode.always,
                      fieldDescription: Translation.maiden_name.tr,
                      enabled: addPageController.editControlsVisible.value,
                      fieldController: addPersonController.maidenNameController,
                      maxLength: 100,
                      regExp: r"^[\p{L} ]*$",
                      message: Translation.only_letters.tr,

                    )),

                Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    child: CustomFormField(
                        inputFillColor: AppTheme.inputFillColor,
                        validateMode: AutovalidateMode.always,
                      fieldDescription: Translation.date_birth.tr,
                      enabled: addPageController.editControlsVisible.value,
                      fieldController: addPersonController.birthYearController,
                      maxLength: 10,
                      regExp: r"\b([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]))\b|\b^\d{4}$\b",
                      message: Translation.date_format.tr

                    )
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    child: CustomFormField(
                        inputFillColor: AppTheme.inputFillColor,
                        validateMode: AutovalidateMode.always,
                      fieldDescription: Translation.date_death.tr,
                      enabled: addPageController.editControlsVisible.value,
                      fieldController: addPersonController.deathYearController,
                      maxLength: 10,
                      regExp: r"\b([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]))\b|\b^\d{4}$\b",
                      message: Translation.date_format.tr

                    )),
                Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    child: CustomFormField(
                        inputFillColor: AppTheme.inputFillColor,
                        validateMode: AutovalidateMode.always,
                      fieldDescription: Translation.age.tr,
                      enabled: addPageController.editControlsVisible.value,
                      fieldController: addPersonController.ageController,
                      maxLength: 3,
                      inputType: TextInputType.number,
                      regExp: r"^[0-9]*$",
                      message: Translation.only_numbers.tr
                    )),
                Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    child: CustomFormField(
                      inputFillColor: AppTheme.inputFillColor,
                      validateMode: AutovalidateMode.always,
                      fieldDescription: Translation.additional_info.tr,
                      enabled: addPageController.editControlsVisible.value,
                      fieldController: addPersonController.addInfoController,
                      maxLength: 400,
                      regExp: r"^[\p{L}0-9., -/]*$",
                      message: Translation.letters_numbers_signs_allowed.tr + " .,-/",
                    )),
                SizedBox(
                  height: 30.0,
                ),



              ],
            ),
          ),
        ));
  }
}
