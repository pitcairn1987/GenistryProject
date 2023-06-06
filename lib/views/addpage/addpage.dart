
import 'package:appwrite/appwrite.dart';
import 'package:camera_app/appsettings.dart';
import 'package:camera_app/controllers/addpage_controller.dart';
import 'package:camera_app/controllers/offlinegraves_controller.dart';
import 'package:camera_app/model/customdocument_model.dart';
import 'package:camera_app/services/AppWriteService.dart';
import 'package:camera_app/views/addpage/personslistview.dart';
import 'package:camera_app/views/addpage/photogridview.dart';
import 'package:camera_app/views/addpage/phototopbar.dart';
import 'package:camera_app/views/addperson.dart';
import 'package:camera_app/views/geoinfopage.dart';
import 'package:camera_app/views/myobjects.dart';
import 'package:camera_app/views/offlinegravespage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../apptheme.dart';
import '../../translation_keys.dart';
import '../widgets/customformfield.dart';
import 'package:connectivity/connectivity.dart';


class AddPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


  //  final homePageController = Get.find<HomePageController>();
    final AddPageController addPageController = Get.put(AddPageController());

    final OfflineGravesController offlineGravesController = Get.put(OfflineGravesController());

    final _formKey = GlobalKey<FormState>();




    Widget graveForm(){



      return Form(
        key: _formKey,
        child: Column(
          children: [
            Visibility(
              visible: addPageController.typeId == 0 ? true : false,
              child: Padding(
                padding: const EdgeInsets.only(top:10, bottom:5, left:13, right:8),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom:25, right:10),
                      child:  Icon(Icons.info_outline, color:AppTheme.formIconColor),
                    ),
                    Expanded(
                        child: Obx(() => CustomFormField(
                          inputFillColor: addPageController.editControlsVisible.value==true ? AppTheme.inputFillColor:  AppTheme.backgroundColor1,
                          validateMode: AutovalidateMode.onUserInteraction,
                          fieldDescription: Translation.cemetery.tr,
                          enabled: addPageController.editControlsVisible.value,
                          fieldController: addPageController.placeController,
                          maxLength: 50,
                          checkIfEmpty: false,
                          regExp: r"^[\p{L}0-9. -]*$",
                          message: Translation.letters_numbers_signs_allowed.tr +  " .-",
                        ))),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top:10, bottom:5,  right:8),
              child: Row(
                children: [
                  Obx(() => Padding(
                    padding: EdgeInsets.only(bottom:30),
                    child: IconButton(
                      iconSize: 25.0,
                      icon: addPageController.editControlsVisible.value == false
                          ? Icon(Icons.location_on_outlined)
                          : Icon(Icons.location_on),
                      color: Colors.blueAccent,
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        if (addPageController.geoController.text == '') {
                          Get.to(GeoInfoPage());
                        } else
                          Get.to(GeoInfoPage(), arguments: [
                            addPageController.lat,
                            addPageController.lon,
                          ]);

                        //  addPageController.getGeoInfo();
                      },
                    ),
                  )),
                  Expanded(
                      child: Obx(() => CustomFormField(
                        inputFillColor: addPageController.editControlsVisible.value==true ? AppTheme.inputFillColor:  AppTheme.backgroundColor1,
                        validateMode: AutovalidateMode.onUserInteraction,
                        fieldDescription: Translation.address.tr,
                        enabled: addPageController.editControlsVisible.value,
                        fieldController: addPageController.addressController,
                        maxLength: 100,
                        regExp: r"^[\p{L}0-9., -/]*$",
                        checkIfEmpty: true,
                        message: Translation.letters_numbers_signs_allowed.tr +  " .,-/",
                      ))),
                ],
              ),
            ),

            Visibility(
              visible: addPageController.typeId == 0 ? false : true,
              child: Padding(
                padding: const EdgeInsets.only(top:10, bottom:5, left:13, right:8),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom:25, right:10),
                      child:  Icon(Icons.calendar_month_sharp, color:AppTheme.formIconColor),

                    ),
                    Expanded(
                        child: Obx(() => CustomFormField(
                            inputFillColor: addPageController.editControlsVisible.value==true ? AppTheme.inputFillColor:  AppTheme.backgroundColor1,
                            validateMode: AutovalidateMode.onUserInteraction,
                            fieldDescription: Translation.year.tr,
                            enabled: addPageController.editControlsVisible.value,
                            fieldController: addPageController.yearController,
                            maxLength: 10,
                            regExp: r"^\d{4}$",
                            message: Translation.four_digits_allowed.tr
                        ))),
                  ],
                ),
              ),
            ),

     /*       Padding(
              padding: const EdgeInsets.only(top:10, bottom:5,  right:8),
              child: Row(
                children: [
                  Obx(() => Padding(
                    padding: EdgeInsets.only(bottom:30),
                    child: IconButton(
                      iconSize: 25.0,
                      icon: addPageController.editControlsVisible.value == false
                          ? Icon(Icons.location_on_outlined)
                          : Icon(Icons.location_on),
                      color: Colors.blueAccent,
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        if (addPageController.geoController.text == '') {
                          Get.to(GeoInfoPage());
                        } else
                          Get.to(GeoInfoPage(), arguments: [
                            addPageController.lat,
                            addPageController.lon,
                          ]);

                        //  addPageController.getGeoInfo();
                      },
                    ),
                  )),
                  Expanded(
                      child: CustomFormField(
                        validateMode: AutovalidateMode.disabled,
                        fieldDescription: Translation.geolocation.tr,
                        enabled: false,
                        fieldController: addPageController.geoController,
                        regExp: r"^[A-Za-z0-9.,;/]*$",
                      )),
                ],
              ),
            ),*/

            Padding(
              padding: const EdgeInsets.only(top:10, bottom:5, left:13, right:8),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom:25, right:10),
                    child:  Icon(Icons.description_outlined, color: AppTheme.formIconColor),

                  ),
                  Expanded(
                      child: Obx(() => CustomFormField(
                        inputFillColor: addPageController.editControlsVisible.value==true ? AppTheme.inputFillColor:  AppTheme.backgroundColor1,
                        validateMode: AutovalidateMode.onUserInteraction,
                        fieldDescription: Translation.description.tr,
                        enabled: addPageController.editControlsVisible.value,
                        fieldController: addPageController.addInfoController,
                        regExp: r"^[\p{L}0-9., -/]*$",
                        message: Translation.letters_numbers_signs_allowed.tr + " .,-/",
                      ))),

                ],
              ),
            ),
          ],
        ),
      );

    }



    Widget portraitView() {

      return CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.black,
            automaticallyImplyLeading: false,
            expandedHeight: 350.0,
            flexibleSpace: FlexibleSpaceBar(
                background: AddPagePhotoTopBar()
            ),
          ),
          //3
          SliverToBoxAdapter(
              child: Container(
                  decoration: BoxDecoration(

                    color: AppTheme.backgroundColor2,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                  ),
                  height: 1200,
                  child: Column(
                    children: [
                      SizedBox(height: 15),

                      ...listTypes.where((element) => element.typeID == addPageController.typeId).map((e) {
                        return   Padding(
                          padding: const EdgeInsets.only(left:35),
                          child: Align(
                            child: Row(
                              children: [
                                e.icon,
                                SizedBox(width: 15,),
                                Text(e.label.tr, style: TextStyle(color: AppTheme.inputLabelFontColor, fontSize: 22),),

                              ],
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                        );
                      }),

                      SizedBox(height: 15,),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                        child: Container(

                          decoration: BoxDecoration(




                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                spreadRadius: 0.5,
                                blurRadius: 2,
                                offset: Offset(1.5, 1.5), // changes position of shadow
                              ),
                            ],
                           // color: Color(0xfffeebe3),
                            color: AppTheme.backgroundColor1,
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 5, right: 5, top: 20, bottom: 15),
                            child: graveForm() ,
                          ),
                        ),
                      ),

                    //  SizedBox(height: 10),

                      Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15, bottom:15),
                          child: AddPagePersonListView()
                      ),

                     // SizedBox(height: 20),
                      //    SizedBox(height:20),
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: AddPagePhotoGridView()
                        ),
                      ),

                      SizedBox(height: 20),
                    ],
                  ))),
        ],
      );
    }



    return WillPopScope(
        onWillPop: () async {
          bool willLeave = false;
          // show the confirm dialog
          if (addPageController.editControlsVisible.value == true) {
            await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                      title:  Text(Translation.leave_without_saving.tr,),
                      actions: [
                        FilledButton(
                            onPressed: () async {
                            if(!kIsWeb) addPageController.clearImageCacheOnCancel();
                            willLeave = true;
                            Get.back();
                            },
                            child:  Text(Translation.yes.tr)),
                        OutlinedButton(onPressed: () => Navigator.of(context).pop(), child:  Text(Translation.no.tr))
                      ],
                    ));
            return willLeave;
          } else {
            willLeave = true;
           // Navigator.of(context).pop();
            Get.back();
            return willLeave;
          }
        },
        child: Scaffold(
          //appBar: AppBar(),
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.black,
          floatingActionButton: Obx(() => Visibility(
                visible: addPageController.editControlsVisible.value,
                child: Row(
                  children: [
                    // SizedBox(width: 90),
                    Spacer(),
                    Row(
                      children: [
                        Visibility(
                          visible: addPageController.typeId == 0 ? true : false,
                          child: FloatingActionButton(
                            backgroundColor: AppTheme.buttonColor3 ,
                            heroTag: "btnAddPerson",
                            onPressed: () {
                              Get.to(AddPerson());
                            },
                            child:  Icon(Icons.person_add, color: AppTheme.onButtonColor3),
                          ),
                        ),
                        SizedBox(width: 10),
                        FloatingActionButton(
                            backgroundColor: AppTheme.buttonColor2 ,
                          heroTag: "btnCamera",
                          onPressed: () async {
                           var result = await addPageController.getImage(ImageSource.camera);
                         //  if(result is String)   Get.defaultDialog(title: "", content: Text(Translation.file_wrong_size.tr + ': ' + result.toString() + ' mb'));
                          },
                          child:  Icon(Icons.camera ,color: AppTheme.onButtonColor2),

                        ),
                        SizedBox(width: 10),
                        FloatingActionButton(

                          heroTag: "btnGallery",
                          onPressed: () async {
                            var result = await addPageController.getImage(ImageSource.gallery);
                          //  if(result is String)   Get.defaultDialog(title: "", content: Text(Translation.file_wrong_size.tr + ': ' + result.toString() + ' mb'));
                          },
                          child:  Icon(Icons.photo_library_sharp, color: AppTheme.onButtonColor2),
                          backgroundColor: AppTheme.buttonColor2 ,
                        ),
                      ],
                    ),
                    SizedBox(width: 50),
                    FloatingActionButton(
                      heroTag: "btnSave",
                      onPressed: () async {
                        if (_formKey.currentState!.validate())
                        {
                          if(addPageController.images.length> 0){
                            if (addPageController.addMode == false)
                            {
                              if (addPageController.doc.status == 0)
                              {
                                var updDoc = await addPageController.updateGraveLocal();
                                offlineGravesController.graveOfflineList.refresh();
                                Get.back();
                              }
                              else if (addPageController.doc.status == 1)
                              {

                                var connectivityResult = await (Connectivity().checkConnectivity());
                                if (connectivityResult == ConnectivityResult.none) {
                                  // Get.defaultDialog(content:Text(Translation.no_connection.tr));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(duration: Duration(seconds: 2), content: Text(Translation.no_connection.tr,
                                    ),
                                    ),
                                  );

                                }

                                else
                                {
                                  var result = await addPageController.updateGraveOnline();
                                  if (result != null && result is CustomDocument) {
                                    Get.back(result: result);
                                  }
                                  else
                                  {
                                  //  await Get.defaultDialog(title: "", content:Text(result) );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(duration: Duration(seconds: 2), content: Text(result,
                                      ),
                                      ),
                                    );

                                  }
                                }
                              }
                            }
                            else {
                              if(kIsWeb){
                                var doc = await addPageController.insertGraveRemote();
                                var res = await AppWriteService.createGrave(doc, AppSettings.loginInfo.userId);

                                if (res is AppwriteException) {

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(duration: Duration(seconds: 2), content: Text(res.code
                                        .toString()
                                        .tr,
                                    ),
                                    ),
                                  );
                                }
                                else
                                {
                                  //  await Get.defaultDialog(title: "", content:Text(result) );

                                  Get.back(result: res);

                                }



                              }
                              else{
                                var doc = await addPageController.insertGraveLocal();
                                offlineGravesController.graveOfflineList.insert(0, doc);
                                //if (doc.geoLat != "" && doc.geoLon != "")
                                //homePageController.graveMarkers.add(homePageController.newMarker(doc)!);
                                // Get.back();
                                Get.off(OfflineGravesPage());
                              }

                            }

                          }
                          else

                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                 SnackBar(duration: Duration(seconds: 2), content: Text(Translation.must_add_photo.tr,
                                  ),
                                ),
                              );

                            }


                      }

                        },
                      child:  Icon(Icons.check, color: AppTheme.onButtonColor1),
                        backgroundColor: AppTheme.buttonColor1
                    ),
                  ],
                ),
              )),
         body:  portraitView()
   /*      LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth > 800) {
                return landscapeView();
              } else {
                return portraitView();
              }
            },
          )*/


        ));
  }
}


