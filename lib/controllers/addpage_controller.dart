import 'dart:io';
import 'package:camera_app/appsettings.dart';
import 'package:camera_app/services/AppWriteService.dart';
import 'package:camera_app/services/HiveService.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import '../model/customdocument_model.dart';
import 'package:image_picker/image_picker.dart';

class AddPageController extends GetxController {
  final placeController = TextEditingController();
  final addressController = TextEditingController();
  final yearController = TextEditingController();
  final geoController = TextEditingController();
  final typeController = TextEditingController();
  final addInfoController = TextEditingController();

  dynamic argumentData = Get.arguments;

  var selectedTypes = <bool>[false, false].obs;

  String lat ="";
  String lon="";

  var selectedType = 0.obs;

  var selectedIndexBar = 0.obs;

  var images = <Photo>[].obs;
  var imagesTrash = <Photo>[].obs;
  var personsList = <Person>[].obs;
  var personsTrash = <Person>[];
  late Position position;
  bool addMode = false;
  bool editModePopupVisible = false;
  var editControlsVisible = false.obs;
  var typeId = 0;


  CustomDocument doc = new CustomDocument(
      customDocumentTypeId: 0,
      createUserId: '',
      status: 0,
      geoLat: "",
      geoLon: "",
      place: "",
      address: "",
      year: "",
      persons: <Person>[],
      photos: <Photo>[],
      additionalInfo: "",
      personsTags_: ",",
      yearTags_: ""
  );

  var editOptionVisible = false.obs;
  var opacityGridItem = 1.0.obs;
  var removeIconGridItemVisible = false.obs;
  var selectedPhotoIndex = 0.obs;
  bool photosEditMode = false;
  var photoSelectedValue = false.obs;

  @override
  void onInit() {
   // var doc = Get.arguments['cid'];
    if(argumentData is CustomDocument){
      addMode = false;
      doc = argumentData as CustomDocument;
      typeId = doc.customDocumentTypeId;

      if (doc.status == 0) {
        editControlsVisible.value = true;
      }

      if(doc.status == 1 && doc.createUserId == AppSettings.loginInfo.userId && addMode == false  ) editModePopupVisible = true;

      images.addAll(doc.photos);
      personsList.addAll(doc.persons!);
      addressController.text = doc.address?? "";
      placeController.text = doc.place?? "";
      yearController.text = doc.year ?? "";
      addInfoController.text = doc.additionalInfo ?? "";
      lat = doc.geoLat ?? "";
      lon = doc.geoLon ?? "";
      if (lat != "" && lon != "") geoController.text = lat + ';' + lon;

  } else if (argumentData is int) {
    addMode = true;
    typeId = argumentData as int;
    doc.customDocumentTypeId = typeId;
   //   print(c);

    editModePopupVisible = false;
    editControlsVisible.value = true;

  }

    else  addMode = false;

    super.onInit();
  }

  void onClose() {
    placeController.dispose();
    addressController.dispose();
    yearController.dispose();
    addInfoController.dispose();
    typeController.dispose();
    geoController.dispose();
    Get.delete<AddPageController>();
    super.onClose();
  }

  void addPerson(Person p) {
    personsList.add(p);
  }



  void populateDoc(){
    //doc.customDocumentTypeId = selectedType.value;// KAPLICZKI!!
    doc.createUserId = AppSettings.loginInfo.userId;
    doc.place = placeController.text.trim();
    doc.address = addressController.text.trim();
    doc.year = yearController.text.trim();
    doc.geoLon = lon ?? "";
    doc.geoLat = lat ?? "";
    doc.persons = personsList;
    doc.photos = images;
    doc.additionalInfo = addInfoController.text.trim();


   String? personsTags;
    String? yearsTags="";

   personsTags = doc.persons?.map((e) => e.lastName + e.firstName).join(";").toLowerCase();


   if(doc.customDocumentTypeId == 0){

     doc.persons?.forEach((element) {

       var birthYear;
       if(element.birthYear.contains("-")){
         birthYear = element.birthYear.substring(0,4);
       }
       else{
         birthYear = element.birthYear;
       }

       yearsTags = yearsTags! + ';' + birthYear;



       var deathYear;
       if(element.deathYear.contains("-")){
         deathYear = element.deathYear.substring(0,4);
       }
       else{
         deathYear = element.deathYear;
       }

       yearsTags = yearsTags! + ';' + deathYear;

     });

   }

   else{
     yearsTags = doc.year;

   }



    doc.yearTags_ = yearsTags;
    doc.personsTags_ = personsTags;
  }


  Future<CustomDocument> insertGraveLocal() async {

    imagesTrash.forEach((element) {
      var file = AppSettings.temporaryDirectoryPath + "/" + element.photoFileName;
      File(file).delete();
    });

    images.forEach((element) {
      element.photoFileId = "1"; //zapisane lokalnie
    });

    populateDoc();


    var c = await HiveService.addGrave(doc);
    if (c != null) doc = CustomDocument.fromCustomDocumentHiveModel(c);

    return doc;
  }



  Future<CustomDocument> updateGraveLocal() async {

    imagesTrash.forEach((element) {
      var file = AppSettings.temporaryDirectoryPath + "/" + element.photoFileName;
      File(file).delete();
    });

    images.forEach((element) {
      element.photoFileId = "1"; //zapisane lokalnie
    });

    populateDoc();
    var c = await HiveService.updateGrave(doc);
    if (c != null) doc = CustomDocument.fromCustomDocumentHiveModel(c);

    return doc;
  }



  Future<CustomDocument> insertGraveRemote() async {


    populateDoc();
    doc.status = 1;


    return doc;
  }









  Future<dynamic> updateGraveOnline() async {

    var imagesTrashCopy = List<Photo>.from(imagesTrash);
    var imagesCopy = List<Photo>.from(images);

    populateDoc();

   // if(doc.isValid){
    var imagesToSent = imagesCopy.where((element) => element.photoFileId == "0");
    if (imagesToSent.length > 0) {
      var photosRes = await Future.wait(imagesToSent.map((photo) async => AppWriteService.sentImage(photo)));
      var newPhotos;
      if (photosRes[0] is Photo) {
        newPhotos = photosRes.map((item) => item as Photo).toList();
        images.removeWhere((element) => element.photoFileId == "0");
        images.addAll(newPhotos);
      }
    }


      var imagesOfflineTrash = imagesTrashCopy.where((element) => element.photoFileId == "0");
      if (imagesOfflineTrash.length > 0) {
        imagesOfflineTrash.forEach((element) {
          var file = AppSettings.temporaryDirectoryPath + "/" + element.photoFileName;
          File(file).delete();
          //  imagesTrash.remove(element);
        });
      }

      var imagesOnlineTrash = imagesTrashCopy.where((element) => element.photoFileId != "0" && element.photoFileId != "0");
      if (imagesOnlineTrash.length > 0) {
        AppWriteService.deleteImages(imagesTrash.where((element) => element.photoFileId != "0").toList());
      }

      await AppWriteService.updateGrave(doc.customDocumentId!, doc.toJson());
      if (imagesToSent.length > 0) {
        imagesToSent.forEach((element) {
          var file = AppSettings.temporaryDirectoryPath + "/" + element.photoFileName;
          File(file).delete();
        });
      }

      return doc;

 /*   }

    else {

      return Translation.complete_data.tr;

    }*/

  }





  void clearImageCacheOnCancel() {
    var imagesTrashCopy = List<Photo>.from(imagesTrash);
    var imagesCopy = List<Photo>.from(images);

    imagesTrashCopy.where((element) => element.photoFileId == "0").forEach((element) {
      var file = AppSettings.temporaryDirectoryPath + "/" + element.photoFileName;
      File(file).delete();
      //imagesTrash.remove(element);
    });

    imagesCopy.where((element) => element.photoFileId == "0").forEach((element) {
      var file = AppSettings.temporaryDirectoryPath + "/" + element.photoFileName;
      File(file).delete();
      // images.remove(element);
    });
  }

  void setGeoLocation(double latValue, double lonValue) {
    lat = latValue.toStringAsFixed(4);
    lon = lonValue.toStringAsFixed(4);
    geoController.text = lat! + ';' + lon!;
  }

  Future<String?>  getImage(ImageSource imageSource) async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile != null) {
      var selectedImagePath = pickedFile.path;

     // File file = File(selectedImagePath);

      //var test = await pickedFile.readAsBytes();
   //   var test = await file.readAsBytes();
      List<int> test = await pickedFile.readAsBytes();
      /*var size = test.lengthInBytes;
      if(size > 3000000){
        var sizeInMb = size.toDouble()/1000000;
        return sizeInMb.toStringAsFixed(2);
      }

      else{*/
     /*  var ocr = await getOcrFromImage(selectedImagePath);
       var ph = new Photo(
              photoFileId: "0", //nowe jeszcze nie zapisane lokalnie w bazie
             // photoFileName: selectedImagePath.split('/').last,
              photoFileName: selectedImagePath.replaceAll(AppSettings.temporaryDirectoryPath + "/", ""),
              ocr: ocr
          );
*/
      var ocr = await  getOcrFromImage(selectedImagePath);
      var ph;
      if(kIsWeb){
        ph = new Photo(
            photoFileId: "0" //nowe jeszcze nie zapisane lokalnie w bazie
            ,
            photoFileName: selectedImagePath.replaceAll(AppSettings.temporaryDirectoryPath + "/", ""),
            byteImageForWeb: test
            //,photoFileName: selectedImagePath
            ,
            ocr: ocr);
      }

      else{

        ph = new Photo(
            photoFileId: "0" //nowe jeszcze nie zapisane lokalnie w bazie
            ,
            photoFileName: selectedImagePath.replaceAll(AppSettings.temporaryDirectoryPath + "/", ""),
            byteImageForWeb: null
            //,photoFileName: selectedImagePath
            ,
            ocr: ocr);

      }



        images.add(ph);


    }
  }
  Future<String> getOcrFromImage(String path) async {
    final inputImage = InputImage.fromFile(File(path));
    var  textDetector;
    String ocr="";
    try {
      textDetector = GoogleMlKit.vision.textRecognizer();
      final RecognizedText recognisedText = await textDetector.processImage(inputImage);
      ocr = recognisedText.text;
    } on Exception catch (_) {

      print("ocr no supported");

    }

    return ocr;
  }

  @override
  void dispose() {
    Get.delete<AddPageController>();
    // TODO: implement dispose
    super.dispose();

    //  subscriptionConnection.cancel();
  }
}
