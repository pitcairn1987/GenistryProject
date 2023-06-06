import 'package:camera_app/appsettings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../model/customdocument_model.dart';

class FilterPageController extends GetxController {

  final placeController = TextEditingController();
  final addressController = TextEditingController();
  final yearController = TextEditingController();
  final personController = TextEditingController();

  var graveTypeSelected = false.obs;
  var chapelTypeSelected = false.obs;
  var chapel2TypeSelected = false.obs;
  var crossTypeSelected = false.obs;
  var figureTypeSelected = false.obs;
  var choleraCemeteryTypeSelected = false.obs;
  var otherTypeSelected = false.obs;

  var typeIDs = <dynamic>[].obs;

  var selectedItems = <dynamic>[];
  var onlyMine = false.obs;

  late List<Filter> listFilters;

  dynamic argumentData = Get.arguments;


  @override
  void onInit() {

    if(argumentData!=null){

      listFilters = List.from(argumentData);
      populateView();

    }
    super.onInit();

  }

  populateView(){

    listFilters.forEach((element) {
      if(element.dictionaryCode == "Address") addressController.text = element.filterValues[0];
      if(element.dictionaryCode == "yearTAGS") yearController.text = element.filterValues[0];
      if(element.dictionaryCode == "personsTAGS") personController.text = element.filterValues[0];
      if(element.dictionaryCode == "CreateUserID") onlyMine.value = true;
      if(element.dictionaryCode == "CustomDocumentTypeID") typeIDs.value = element.filterValues;


    });

    if(typeIDs.value.contains(0))  graveTypeSelected.value = true;
    if(typeIDs.value.contains(1))  chapelTypeSelected.value = true;
    if(typeIDs.value.contains(2))  chapel2TypeSelected.value = true;
    if(typeIDs.value.contains(3))  crossTypeSelected.value = true;
    if(typeIDs.value.contains(4))  figureTypeSelected.value = true;
    if(typeIDs.value.contains(5))  choleraCemeteryTypeSelected.value = true;
    if(typeIDs.value.contains(6))  otherTypeSelected.value = true;



  }


  generateFilters(){

    listFilters = <Filter>[];

    var place = placeController.text;
    var address = addressController.text;
    var year = yearController.text;
    var persons = personController.text;
    var types = typeIDs.value;


    var filter;


    if(types.length > 0){

      var values = types;
     // values.add(place);
      filter = Filter("CustomDocumentTypeID", "equal", values);
      listFilters.add(filter);

    }


    if(place!= "") {
      var values = <dynamic>[];
      values.add(place);
      filter = Filter("Place", "search", values);
      listFilters.add(filter);
    }

    if(address!= "") {
      var values = <dynamic>[];
      values.add(address);
      filter = Filter("Address", "search", values);
      listFilters.add(filter);
    }

    if(year!= "") {
      var values = <dynamic>[];
      values.add(year);
      filter = Filter("yearTAGS", "search", values);
      listFilters.add(filter);
    }

    if(persons!= "") {
      var values = <dynamic>[];
      values.add(persons);
      filter = Filter("personsTAGS", "search", values);
      listFilters.add(filter);
    }



    if(onlyMine.value == true) {
      var values = <dynamic>[];
      values.add(AppSettings.loginInfo.userId);
      filter = Filter("CreateUserID", "equal", values);
      listFilters.add(filter);
    }

   // return listFilters;

  }


/*
 generateQueries(){

     generateFilters();

     if(listFilters.length> 0){
       queries.clear();
       listFilters.forEach((element) {
         var qr;
         if(element.type == "equal") {
           qr = Query.equal(element.dictionaryCode, element.filterValues);
         }
         else if (element.type == "search") {
           qr = Query.search(element.dictionaryCode, element.filterValues[0]);
         }
         queries.add(qr);

       }
       );
     }

  }
*/


  void onClose() {
    placeController.dispose();
    addressController.dispose();
    yearController.dispose();
    personController.dispose();

    super.onClose();
  }






}