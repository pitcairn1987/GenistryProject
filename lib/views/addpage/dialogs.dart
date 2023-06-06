import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import '../../appsettings.dart';
import '../../apptheme.dart';
import '../../model/customdocument_model.dart';
import '../../services/AppWriteService.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;

import '../../translation_keys.dart';

class ImageDialog extends StatelessWidget {
  Photo photo;

  ImageDialog(this.photo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: Stack(
            children: [

              (photo.photoFileId == "0" || photo.photoFileId == "1")
                  ? Image.file(File(AppSettings.temporaryDirectoryPath + "/" + photo.photoFileName))
                  : FutureBuilder<Uint8List>(
                future: AppWriteService.getImagePreview(photo.photoFileId, "", quality: 100),
                builder: (context, snapshot) {
                  Uint8List? bytes = snapshot.data;
                  //String? path = snapshot.data;
                  return snapshot.hasData && snapshot.data != null
                      ? Stack(
                        children: [


                          Container(
                    child: Image(
                          image: MemoryImage(bytes!),
                    ),
                  ),



                          Positioned(
                            top: 40,
                            right: 25,
                            child: IconButton(
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
                              color: AppTheme.drawerIconColor,
                              iconSize: 30,
                              icon: const Icon(Icons.download),
                              selectedIcon: const Icon(Icons.download),
                              // isSelected: addPageController.editControlsVisible.value,
                              onPressed: () async {

                                  if (!kIsWeb && Platform.isAndroid){

                                    await ImageGallerySaver.saveImage(
                                        bytes!,
                                        quality: 100,
                                        name: photo.photoFileId + '.jpg');
                                  }
                                  else if (kIsWeb){
                                    final base64data = base64Encode(bytes!,);
                                    final a = html.AnchorElement(href: 'data:image/jpeg;base64,$base64data');
                                    a.download = photo.photoFileId + '.jpg';
                                    a.click();
                                    a.remove();
                                  }
                                  Get.snackbar("", Translation.saved.tr);
                               /*   ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(duration: Duration(seconds: 2), content: Text(Translation.saved.tr,
                                    ),
                                    ),
                                  );*/






                              },
                            ),
                          ),





                        ],
                      )
                      : CircularProgressIndicator();
                },
              ),


            ],
          ),
        ),
      ),
    );
  }
}

class OcrDialog extends StatelessWidget {
  String ocr = "";

  OcrDialog(this.ocr);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Container(
                color: Colors.white60,
                child: Text(
                  ocr,
                  style: TextStyle(fontSize: 20),
                )),
          ],
        ),
      ),
    );
  }
}