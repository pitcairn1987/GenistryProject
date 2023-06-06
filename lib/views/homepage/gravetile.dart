import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera_app/appsettings.dart';
import 'package:camera_app/apptheme.dart';
import 'package:camera_app/model/customdocument_model.dart';
import 'package:camera_app/services/AppWriteService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../myobjects.dart';

class GraveTile extends StatefulWidget   {
  CustomDocument doc;
  GraveTile(this.doc);

  @override
  GraveTileState createState() => GraveTileState();
}

class GraveTileState extends State<GraveTile>
    //with  AutomaticKeepAliveClientMixin
{
  Future<Uint8List>? myFuture;
  String imagePath = "";
  @override
  // TODO: implement wantKeepAlive
  //bool get wantKeepAlive => true;

  Future<Uint8List>? fetchPhotoOnline() async {
    if (widget.doc.photos[0].byteImage == null) {


      var res = await AppWriteService.getImagePreview(widget.doc.photos[0].photoFileId, widget.doc.place!);
      widget.doc.photos[0].byteImage = res;
    }
    return widget.doc.photos[0].byteImage!;
  }

  @override
  void initState() {
    super.initState();

    if (widget.doc.status == 1) {
      myFuture = fetchPhotoOnline();
    }
  }

  @override
  Widget build(BuildContext context) {

  //  final MyColors myColors = Theme.of(context).extension<MyColors>()!;

    imagePath = "";
      //super.build(context);
    //print("gravetile build");
    if (widget.doc.status == 0 && widget.doc.photos.length > 0) {
      imagePath = AppSettings.temporaryDirectoryPath +
          "/" +
          widget.doc.photos[0].photoFileName;
    }


    return Container(

      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 0.5,
            blurRadius: 4,
            offset: Offset(1, 1), // changes position of shadow
          ),
        ],

        borderRadius: BorderRadius.circular(5),
        //color: widget.doc.status == 0 ? Color(0xffDDF0DA) : Color(0xfffee6dc),
        color: AppTheme.graveTileBackground
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 10,
          ),
          if (widget.doc.status == 0)
            CircleAvatar(
              backgroundColor: AppTheme.backgroundColor1,
                    radius: 40
                    , backgroundImage: FileImage(File(imagePath)))

          else if (widget.doc.status == 1)
            FutureBuilder(
              future: myFuture,
              builder: (context, snapshot) {
                //print("build photo for:" + widget.doc.place!);
                Uint8List? bytes = snapshot.data as Uint8List?;
                return snapshot.hasData && snapshot.data != null
                    ? CircleAvatar(
                  backgroundColor: AppTheme.backgroundColor1,
                        radius: 40,
                        //child: Icon(Icons.no_photography_sharp,color: Colors.redAccent,)
                        backgroundImage: MemoryImage(bytes!),
                      )
                    : CircularProgressIndicator();
              },
            ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Visibility(
                  visible:  widget.doc.year !="" && widget.doc.customDocumentTypeId > 0 ? true: false,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom:10.0),
                    child: Text(

                        widget.doc.year ?? "",
                        //  style: graveInfoTextStyle.copyWith(fontWeight:FontWeight.w600 ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:  TextStyle(fontSize: 21.0, color: AppTheme.textColorHardBolded)
                    ),
                  ),
                ),


                Visibility(
                  visible:  widget.doc.personsString !="" && widget.doc.customDocumentTypeId==0 ? true: false,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom:10.0),
                    child: Text(

                      widget.doc.personsString ?? "",
                    //  style: graveInfoTextStyle.copyWith(fontWeight:FontWeight.w600 ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                        style:  TextStyle(fontSize: 21.0, color: AppTheme.textColorHardBolded)
                     // style: TextStyle(color: Theme.of(context).switchTheme.copyWith()),
                    ),
                  ),
                ),
               /* SizedBox(
                  height: 10,
                ),*/
                Text(
                    widget.doc.address!,
                   // style: graveInfoTextStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:  TextStyle(fontSize: 17.0, color: AppTheme.textColorMediumBolded)
                ),
                SizedBox(
                  height: 10,
                ),

              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              Container(
                child: listTypes[widget.doc.customDocumentTypeId].icon,
              ),



          /*    Container(
                  child: widget.doc.customDocumentTypeId == 0
                     // ? FaIcon(FontAwesomeIcons.cross, color: Colors.blue[700], size: 25)

                  ?   Image.asset('assets/images/cross_icon.png',
                    height: 25,
                    width: 25,

                  )
                      : Icon(Icons.church_outlined,
                          size: 23, color: AppTheme.typeIconColor)

              ),*/

              Container(
                  child: widget.doc.geoLat != "" && widget.doc.geoLon != ""
                      ? Icon(Icons.location_on_outlined,
                          size: 25, color: AppTheme.geoIconColor)
                      : Container(
                          height: 25,
                        )),
              /*SizedBox(
                height: 10,
              ),
              Container(
                  child: !widget.doc.isValid && widget.doc.status == 0
                      ? Icon(Icons.priority_high,
                          size: 23, color: Colors.redAccent)
                      : Container(
                          height: 23,
                        )),*/
            ],
          ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }
}
