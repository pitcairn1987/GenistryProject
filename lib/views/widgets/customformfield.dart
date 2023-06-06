import 'package:camera_app/apptheme.dart';
import 'package:camera_app/controllers/addpage_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../translation_keys.dart';

class CustomFormField extends StatelessWidget {

   String fieldDescription = "";
   bool enabled = false;
   TextEditingController fieldController;
   String ? regExp;
   int ? maxLength;
   int ? minLength;
   var  obscuredText = false.obs;
   TextInputType ?  inputType;
   Color ? inputFillColor;
   String ? message;
   bool ? checkIfEmpty = false;
   AutovalidateMode  validateMode;
   var showPassword = false.obs;
   bool ? isPasswordInput = false;


  CustomFormField( {
    required this.fieldDescription, required this.enabled, required this.fieldController,
    this.maxLength,
    this.minLength,
    this.isPasswordInput = false,
    this.regExp = r"^[A-Za-z0-9]+$",
    this.inputType = TextInputType.text,
    this.inputFillColor,
    this.message,
    this.checkIfEmpty,
    required this.validateMode

  });


  @override
  Widget build(BuildContext context) {


    if(isPasswordInput == true) obscuredText.value = true;

    //print(validateMode);
    String  ? validateField(String val){
      print(validateMode);

      if(checkIfEmpty ==true && val.trim()==''){
        return "Pole obowiązkowe";
       // return "";
      }


      if(regExp !=null && val.length > 0)
      {
        RegExp regex = new RegExp(regExp!, unicode: true);
        if (!regex.hasMatch(val!)) return message;

      }

      if(maxLength != null)
      {
        if (val.length > maxLength! ) return Translation.limit_signs.tr +  ' ' + maxLength!.toString();

      }


      if(minLength != null)
      {
        if (val.length < minLength! ) return Translation.min_signs.tr +  ' ' + minLength!.toString();

      }


     else return null;

    }

    return  Obx(()=> TextFormField(


      style: TextStyle(fontSize: 20, color: AppTheme.inputFontColor,decorationThickness:0.0),


        obscureText: obscuredText.value == true && showPassword.value == false ? true: false,

        autovalidateMode: validateMode,
     //autovalidateMode: validateMode,
        validator: (value) {

          return validateField(value!);
        },

    /*    inputFormatters: [

            FilteringTextInputFormatter.deny(
                RegExp(r'\s')),
        ],*/
         keyboardType: inputType,
        maxLines: obscuredText.value ? 1 : null,
        //readOnly: !readOnly,
        enabled: enabled,
        controller: fieldController,
        decoration:  InputDecoration(



          suffixIcon: obscuredText.value == true ?
          GestureDetector(
            onTap: () {
              showPassword.value = !showPassword.value;
            },
            child:  Icon(

              showPassword.value ? Icons.visibility : Icons.visibility_off,
              color:AppTheme.formIconColor
            ),
          ): null,

          floatingLabelBehavior: FloatingLabelBehavior.always,
          helperText: " ",

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(color: AppTheme.errorColor, width: 1.0),
          ) ,



          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(color: AppTheme.buttonColor1, width: 1.0),
          ) ,

          contentPadding: EdgeInsets.only(left:15, right: 15, top:15, bottom: 15),
          errorMaxLines: 2,
           // fillColor: Color(0xfffeebe3),
            fillColor: inputFillColor,
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: AppTheme.focusedBorder, width: 0.4),
            ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(color: AppTheme.errorColor, width: 1.0),
          ),
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xff81939d),
                  style: BorderStyle.none,
                ),
                borderRadius: BorderRadius.all(Radius.circular(30))
            ),
            enabledBorder: OutlineInputBorder(
               borderSide: BorderSide(color: AppTheme.inputLabelFontColor, width: 0.2),
                borderRadius: BorderRadius.all(Radius.circular(30))),
            labelText: fieldDescription,
        labelStyle: TextStyle(fontSize: 22, color: AppTheme.inputLabelFontColor),
        prefixStyle: TextStyle(fontSize: 18, color: Colors.black87),

          errorStyle: TextStyle(
            fontSize: 14.0,
            color: AppTheme.errorBorder
          ),
        ),

    ));

  }
}
