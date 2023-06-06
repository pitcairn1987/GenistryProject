import 'dart:io';
import 'dart:typed_data';
import 'package:camera_app/controllers/addpage_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../appsettings.dart';
import '../widgets/gridphotowidget.dart';
import 'dialogs.dart';

class AddPagePhotoGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final addPageController = Get.find<AddPageController>();

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {


      return Obx(() => GridView.builder(
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          // to disable GridView's scrolling
          shrinkWrap: true,
          gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: constraints.maxWidth > 800 ? 4: 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
          ),
          itemCount: addPageController.images.length,
          itemBuilder: (BuildContext context, int index) {



            return GestureDetector(
                key: ObjectKey(addPageController.images[index]),
                onLongPress: () async {
                  if (addPageController.removeIconGridItemVisible.value == false) {
                    addPageController.opacityGridItem.value = 0.3;
                    addPageController.removeIconGridItemVisible.value = true;
                  } else {
                    addPageController.opacityGridItem.value = 1.0;
                    addPageController.removeIconGridItemVisible.value = false;
                  }
                },
                onTap: () async {
                  if (addPageController.removeIconGridItemVisible.value == false)
                    await Get.to(ImageDialog(addPageController.images[index]));
                },
                onDoubleTap: () async {
                  if (addPageController.removeIconGridItemVisible.value == false)
                    await Get.to(OcrDialog(addPageController.images[index].ocr));
                },
                child:


                Stack(
                  fit: StackFit.expand,
                  children: [
                    if (addPageController.doc.status == 0 ||
                        (addPageController.doc.status == 1 &&
                            addPageController.images[index].byteImage == null &&
                            addPageController.images[index].photoFileId == "0"))
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child:

                        FittedBox(
                            fit: BoxFit.fill,
                            child:
                            kIsWeb == true ? Image.memory(Uint8List.fromList( addPageController.images[index].byteImageForWeb!.cast<int>().toList()))
                                :
                            Image.file(
                                File(AppSettings.temporaryDirectoryPath + "/" + addPageController.images[index].photoFileName)
                            )
                        )

                   /*     FittedBox(
                            fit: BoxFit.fill,
                            child:
                            Image.file(
                                File(AppSettings.temporaryDirectoryPath + "/" + addPageController.images[index].photoFileName)
                            )
                        ),*/
                      )
                    else
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: FittedBox(
                          //  key:ObjectKey(addPageController.images[index]),
                            fit: BoxFit.fill,
                            child: GridPhotoWidget(addPageController.images[index])
                        ),
                      ),
                    Obx(() => Visibility(
                      visible: addPageController.editControlsVisible.value,
                      child: Positioned(
                          right: 5,
                          top: 2,
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: ElevatedButton(
                              onPressed: () {
                                addPageController.imagesTrash
                                    .add(addPageController.images[index]);
                                addPageController.images.removeAt(index);
                              },
                              child: Icon(
                                Icons.remove,
                                color: Colors.white,
                                size: 28,
                              ),
                              //child: FaIcon(FontAwesomeIcons.trash, color: Colors.white, size: 20),
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(
                                    side: BorderSide(width: 1, color: Colors.white)),
                                padding: EdgeInsets.all(1),
                                backgroundColor: Colors.redAccent,
                                // <-- Button color
                                foregroundColor: Colors.white, // <-- Splash color
                              ),
                            ),
                          )),
                    ))
                  ],
                )

            );
          }));},
    );
  }
}
