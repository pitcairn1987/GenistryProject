import 'dart:async';
import 'dart:typed_data';
import 'package:camera_app/services/AppWriteService.dart';
import 'package:flutter/material.dart';

import '../../model/customdocument_model.dart';

class GridPhotoWidget extends StatefulWidget {
  Photo photo;

  GridPhotoWidget(this.photo);

  @override
  GridPhotoWidgetState createState() => GridPhotoWidgetState();
}

class GridPhotoWidgetState extends State<GridPhotoWidget> {
  Future<Uint8List>? myFuture;

  Future<Uint8List>? fetchPhotoOnline() async {
    if (widget.photo.byteImage == null) {
      var res = await AppWriteService.getImagePreview(widget.photo.photoFileId, "", quality: 30);
      widget.photo.byteImage = res;
    }
    return widget.photo.byteImage!;
  }

  @override
  void initState() {
    super.initState();

    print("GraveTitle init execute getimagepreview photo for:" + widget.photo.photoFileId);
    myFuture = fetchPhotoOnline();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: myFuture
      // future: AppWriteService.getImagePreviewFiles(addPageController.doc.photos[index].photoFileId!)
      , //works for both public file and private file, for private files you need to be logged in
      builder: (context, snapshot) {
        Uint8List? bytes = snapshot.data;
        //String? path = snapshot.data;
        return snapshot.hasData && snapshot.data != null
            ? Container(
                child: Image(
                  image: MemoryImage(bytes!),
                ),
              )
            : CircularProgressIndicator();
      },
    );
  }
}
