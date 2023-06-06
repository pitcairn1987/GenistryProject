import 'dart:io';
import 'dart:typed_data';
import 'package:camera_app/controllers/addpage_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../appsettings.dart';
import '../../apptheme.dart';
import '../../services/AppWriteService.dart';
import '../../translation_keys.dart';

class AddPagePhotoTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final addPageController = Get.find<AddPageController>();

    return Stack(
      children: [
        if (addPageController.addMode == true)
          Container()
        else if (addPageController.addMode == false && addPageController.doc.status == 1)
          FutureBuilder<Uint8List>(
            future: AppWriteService.getImagePreview(addPageController.images[0].photoFileId, "", quality: 70),
            builder: (context, snapshot) {
              Uint8List? bytes = snapshot.data;
              return snapshot.hasData && snapshot.data != null
                  ? Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: Colors.black, width: 10),
                    right: BorderSide(color: Colors.black, width: 10),
                  ),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: MemoryImage(bytes!),
                  ),
                ),
              )
                  : CircularProgressIndicator();
            },
          )
        else if (addPageController.addMode == false &&
              addPageController.doc.status == 0 &&
              addPageController.doc.photos.length > 0)
            Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.black, width: 10),
                  right: BorderSide(color: Colors.black, width: 10),
                ),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: FileImage(File(AppSettings.temporaryDirectoryPath +
                        "/" +
                        addPageController.images[0].photoFileName))),
              ),
            )
          else if (addPageController.addMode == false &&
                addPageController.doc.status == 0 &&
                addPageController.doc.photos.length == 0)
              Container(),
        if (addPageController.editModePopupVisible == true)
          Positioned(
            top: 40,
            right: 25,
            child: Visibility(
              visible: addPageController.editModePopupVisible ,
              child:

            Obx(()=> IconButton(
              style: ButtonStyle(
                side: MaterialStateProperty.resolveWith<BorderSide>((_) {
                  return BorderSide(
                      color:AppTheme.drawerIconColor,
                      width: 0.4);

                }),
                backgroundColor:MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return AppTheme.backgroundColor1 ;
                  },
                ),


              ),
              color: AppTheme.drawerIconColor ,
                iconSize: 40,
                icon: const Icon(Icons.settings_outlined),
                selectedIcon: const Icon(Icons.settings),
                isSelected: addPageController.editControlsVisible.value,
                onPressed: () {

                  if(addPageController.editControlsVisible.value == false){

                    addPageController.editControlsVisible.value = true;
                    Get.snackbar("", Translation.edit_mode.tr,
                        duration: Duration(seconds: 2), animationDuration: Duration(seconds: 2), colorText: AppTheme.appBarIconFontColor
                    );





                  }
                },
              )),





            /*  ElevatedButton(
                    onPressed: () {

                      if(addPageController.editControlsVisible.value == false){

                        addPageController.editControlsVisible.value = true;
                        Get.snackbar("", Translation.edit_mode.tr,
                            duration: Duration(seconds: 1), animationDuration: Duration(seconds: 1));
                      }

                    },
                    child:  Icon(Icons.edit, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black38.withOpacity(0.9),
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(12),
                    ),
                    ),*/
            ),
          ),
      ],
    );
  }
}
