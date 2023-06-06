import 'package:camera_app/controllers/addpage_controller.dart';
import 'package:camera_app/controllers/geoinfopage_controller.dart';
import 'package:camera_app/views/widgets/customformfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../apptheme.dart';
import '../translation_keys.dart';


class GeoInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final GeoInfoController geoInfoController = Get.put(GeoInfoController());
    final addPageController = Get.find<AddPageController>();

void showSuggestionsDialog() async{
    showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(

        child:

        Container(
          constraints: BoxConstraints( maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.only(top:15.0, bottom: 15),
            child: ListView.separated(
                cacheExtent: 10,
                physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                itemCount: geoInfoController.suggestionList.length,
              //  itemExtent: 10,
                itemBuilder: (context, index) {
                  return InkWell(

                    onTap: () async {

                      geoInfoController.setLocation(geoInfoController.suggestionList[index].lat,geoInfoController.suggestionList[index].lon);
                      Navigator.of(context).pop();
                      //print(geoInfoController.suggestionList[index].lat);

                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left:15, right:15),
                      child: Text(geoInfoController.suggestionList[index].displayName, style: TextStyle(fontSize: 20, color:AppTheme.inputFontColor),),
                    ),
                  );

                }, separatorBuilder: (BuildContext context, int index) { return const Divider(); },),
          ),
        )


      );
    },
  );


}




    return Scaffold(
      appBar: AppBar(title:
      Visibility(
        visible: addPageController.editControlsVisible.value,
        child: Row(
          children: [
            Expanded(
                child:

                TextFormField(

                  style: TextStyle(fontSize: 18, color: AppTheme.inputFontColor),
                  controller: geoInfoController.searchPlaceController,


                  decoration: InputDecoration(
                    prefixIcon: Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: IconButton(
                        color: AppTheme.searchButtonColor,
                        onPressed: () async {

                          var position = await geoInfoController
                              .getGeoLocationPosition();
                          geoInfoController.setLocation(
                              position.latitude, position.longitude);

                          var geoInfo = await geoInfoController.getAddressFromLatLong(
                              geoInfoController.mapController.center.latitude,
                              geoInfoController.mapController.center.longitude);
                          geoInfoController.searchPlaceController.text = geoInfo!;

                          //geoInfoController.searchPlaceController.text = Translation.my_location.tr;

                        },
                        icon: Icon(Icons.gps_fixed, color: AppTheme.searchButtonIconColor,),
                      ),
                    ),

                    contentPadding:  const EdgeInsets.only(top:10, bottom:10, left:15, right: 15),
                    isDense: true,
                    // fillColor: Color(0xfffeebe3),
                    //  fillColor: inputFillColor,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(color: Color(0xff81939d), width: 0.4),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(color: Color(0xff81939d), width: 0.2),

                    ),
                    fillColor: AppTheme.inputFillColor

                  ),

                )





            ),

            SizedBox(width:5),


            ElevatedButton(
              onPressed: () async {
                await  geoInfoController.searchPlace();
                // print(geoInfoController.suggestionList.length);
                if(geoInfoController.suggestionList.length>0)  showSuggestionsDialog();
              },
              child: Icon(
                Icons.search,
                // color: Colors.black54,
                color: AppTheme.searchButtonIconColor
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.searchButtonColor,
                shape: CircleBorder(),
                fixedSize: Size(45,45),
                /*    shape: CircleBorder(
                          side: homePageController.activeFilters.length > 0
                              ? BorderSide(
                              color: Colors.blue.withOpacity(0.8),
                              width: 2)
                              : BorderSide.none),*/
                padding: EdgeInsets.all(12),
              ),
            )





            /*      ElevatedButton(
                    onPressed: () async {
                      await  geoInfoController.searchPlace();
                      // print(geoInfoController.suggestionList.length);
                      if(geoInfoController.suggestionList.length>0)  showSuggestionsDialog();

                    },
                    child: Icon(
                      Icons.search,
                     // color: Colors.white,
                      size: 30.0,
                    ),
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                      fixedSize: Size(45,45)
                    ),
                  )*/

          ],
        ),
      )
        ,),
      backgroundColor: AppTheme.backgroundColor1,

        floatingActionButton: Visibility(
          visible: addPageController.editControlsVisible.value,
          child: FloatingActionButton(
              heroTag: "btnSaveGeo",
              onPressed: () async {
                addPageController.setGeoLocation(
                    geoInfoController.mapController.center.latitude,
                    geoInfoController.mapController.center.longitude);
                var geoInfo = await geoInfoController.getAddressFromLatLong(
                    geoInfoController.mapController.center.latitude,
                    geoInfoController.mapController.center.longitude);

                if (geoInfo != null)
                  await showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            title: Text(Translation.enter_this_address.tr),
                            content: Text(
                              '$geoInfo ?',

                            ),
                            actions: [
                              FilledButton(
                                  onPressed: () async {
                                    addPageController.addressController.text =
                                        geoInfo;
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Yes')),
                              OutlinedButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('No'))
                            ],
                          ));

                Get.back();
              },
              child: Icon(Icons.check,color: AppTheme.onButtonColor1),
              backgroundColor: AppTheme.buttonColor1),
        ),
        body: Container(
            //color: Color(0xfffee6dc).withOpacity(0.2),
            child: Obx(() => FlutterMap(
                  mapController: geoInfoController.mapController,
                  options: MapOptions(
                    onMapEvent: (MapEvent e) {
                      if (e is MapEventMoveEnd) {
                        geoInfoController.latController.value =
                            geoInfoController.mapController.center.latitude;
                        geoInfoController.lonController.value =
                            geoInfoController.mapController.center.longitude;
                      }
                    },
                    center: LatLng(geoInfoController.latController.value,
                        geoInfoController.lonController.value),
                    zoom: 5.0,
                  ),
                  nonRotatedChildren: [
                    Visibility(
                      visible: addPageController.editControlsVisible.value,
                      child: Center(
                        child: IconButton(
                          icon: Icon(Icons.gps_fixed),
                          iconSize: 25.0,
                          color: Colors.redAccent,
                          onPressed: () {},
                        ),
                      ),
                    ),


                  /*  AttributionWidget(attributionBuilder: (_) {
                      return Container(
                        color: Colors.white.withOpacity(0.7),
                        child: Row(
                          children: [
                            IconButton(
                              iconSize: 25.0,
                              icon: const Icon(Icons.gps_fixed),
                              color: Colors.redAccent,
                              padding: EdgeInsets.zero,
                              onPressed: () async {
                                var position = await geoInfoController
                                    .getGeoLocationPosition();
                                geoInfoController.setLocation(
                                    position.latitude, position.longitude);
                              },
                            ),
                            Obx(() => Text(
                                geoInfoController.latController.value
                                    .toStringAsFixed(4),
                                style: TextStyle(fontSize: 20))),
                            SizedBox(
                              width: 20,
                            ),
                            Obx(() => Text(
                                geoInfoController.lonController.value
                                    .toStringAsFixed(4),
                                style: TextStyle(fontSize: 20))),
                          ],
                        ),
                      );
                    })*/


                  ],
                  children: [
                    AppTheme.isThemeDark == true ?

                    ColorFiltered(
                      colorFilter: ColorFilter.matrix(<double>[
                        -1,  0,  0, 0, 255,
                        0, -1,  0, 0, 255,
                        0,  0, -1, 0, 255,
                        0,  0,  0, 1,   0,
                      ]),
                      child: ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                            Color(0xffb9b7ac),
                            BlendMode.saturation
                        ),
                        child: TileLayer(
                          //backgroundColor: Colors.yellow,

                          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                          userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                        ),
                      ),
                    ):
                    TileLayer(
                      //backgroundColor: Colors.yellow,

                      urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                    ),

                    MarkerLayer(markers: geoInfoController.graveMarkers)
                  ],
                ))));
  }
}
