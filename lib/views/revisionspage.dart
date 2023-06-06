
import 'package:camera_app/controllers/revpage_constroller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:latlong2/latlong.dart';

import '../apptheme.dart';
class RevisionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final RevPageController revPageController = Get.put(RevPageController());




    Widget flutterMap() {
      return FlutterMap(
        mapController: revPageController.mapController,
        options: MapOptions(
          onMapEvent: (MapEvent e) {
            if (e is MapEventMoveEnd) {
              revPageController.latController.value =
                  revPageController.mapController.center.latitude;
              revPageController.lonController.value =
                  revPageController.mapController.center.longitude;
            }
          },
          center: LatLng(revPageController.latController.value,
              revPageController.lonController.value),
          zoom: 5.0,
        ),
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


          MarkerLayer(markers: revPageController.revisionsMarkers)
        ],
      );
    }




    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(title: Text("Опись. Дело № 680 - Ревизские сказки крестьян помещиков на буквы «А-Г» Вилейского уезда"),),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(

                    color: AppTheme.backgroundColor2,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                          children: [

                            Row(
                              children: [
                                Expanded(child: Padding(
                                  padding: const EdgeInsets.only(left:8, right:8),
                                  child: Text("Miejsce", style: TextStyle(fontSize: 20, color: Colors.black87, fontWeight: FontWeight.w600),softWrap: true,),
                                )),
                                Expanded(child: Padding(
                                  padding: const EdgeInsets.only(left:8, right:8),
                                  child: Text("Opis", style: TextStyle(fontSize: 20, color: Colors.black87, fontWeight: FontWeight.w600),softWrap: true,),
                                )),
                                Expanded(child: Padding(
                                  padding: const EdgeInsets.only(left:8, right:8),
                                  child: Text("Właściciel", style: TextStyle(fontSize: 20, color: Colors.black87, fontWeight: FontWeight.w600),softWrap: true,),
                                )),
                                Expanded(child: Text("Nr strony", style: TextStyle(fontSize: 20, color: Colors.black87, fontWeight: FontWeight.w600),softWrap: true,)),
                                Expanded(child: Text("Link", style: TextStyle(fontSize: 20, color: Colors.black87, fontWeight: FontWeight.w600),softWrap: true,)),
                                Expanded(child: Text("GeoInfo", style: TextStyle(fontSize: 20, color: Colors.black87, fontWeight: FontWeight.w600),softWrap: true,)),

                              ],
                            ),
                            SizedBox(height: 10,),
                            Divider(height: 5, color:Colors.black12),
                            Row(
                              children: [
                                Expanded(child: Padding(
                                  padding: const EdgeInsets.only(left:8, right:8),
                                  child: TextFormField(
                                    style: TextStyle(fontSize: 18, color: AppTheme.inputFontColor),
                                    controller: revPageController.searchPlaceController,
                                    decoration: InputDecoration(
                                        suffixIcon: Container(
                                          margin: const EdgeInsets.only(right: 8),
                                          child: IconButton(
                                            color: AppTheme.searchButtonColor,
                                            onPressed: () async {
                                              revPageController.generateFilters();
                                              await revPageController.fetchRevisions();

                                            },
                                            icon: Icon(Icons.search, color: AppTheme.searchButtonIconColor,),
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



                                  ),
                                )),
                                Expanded(child: Padding(
                                  padding: const EdgeInsets.only(left:8, right:8),
                                  child: TextFormField(
                                    style: TextStyle(fontSize: 18, color: AppTheme.inputFontColor),
                                    controller: revPageController.searchDescriptionController,
                                    decoration: InputDecoration(
                                        suffixIcon: Container(
                                          margin: const EdgeInsets.only(right: 8),
                                          child: IconButton(
                                            color: AppTheme.searchButtonColor,
                                            onPressed: () async {

                                              revPageController.generateFilters();
                                              await revPageController.fetchRevisions();

                                            },
                                            icon: Icon(Icons.search, color: AppTheme.searchButtonIconColor,),
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



                                  ),
                                )),
                                Expanded(child: Padding(
                                  padding: const EdgeInsets.only(left:8, right:8),
                                  child: TextFormField(
                                    style: TextStyle(fontSize: 18, color: AppTheme.inputFontColor),
                                    controller: revPageController.searchLordController,
                                    decoration: InputDecoration(
                                        suffixIcon: Container(
                                          margin: const EdgeInsets.only(right: 8),
                                          child: IconButton(
                                            color: AppTheme.searchButtonColor,
                                            onPressed: () async {

                                             revPageController.generateFilters();
                                             await revPageController.fetchRevisions();
                                            },
                                            icon: Icon(Icons.search, color: AppTheme.searchButtonIconColor,),
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



                                  ),
                                )),
                                Expanded(child: Container()),
                                Expanded(child: Container()),
                                Expanded(child: Container()),

                              ],
                            ),

                            SizedBox(height: 10,),
                            Divider(height: 5, color:Colors.black12),

                            Expanded(
                              child:Obx(()=> ListView.builder(
                              padding: EdgeInsets.zero,
                              physics: BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics(),),
                              itemCount: revPageController.revisionsList.length,
                              itemBuilder: (context, index) {

                                print(revPageController.revisionsList[index]);
                                return
                                  Row(
                                    children: [
                                      Expanded(child: Padding(
                                        padding: const EdgeInsets.only(left:8, right:8),
                                        child: Text(revPageController.revisionsList[index].place!, style: TextStyle(fontSize: 20, color: Colors.black87),softWrap: true,),
                                      )),
                                      Expanded(child: Padding(
                                        padding: const EdgeInsets.only(left:8, right:8),
                                        child: Text(revPageController.revisionsList[index].description!, style: TextStyle(fontSize: 20, color: Colors.black87),softWrap: true,),
                                      )),
                                      Expanded(child: Padding(
                                        padding: const EdgeInsets.only(left:8, right:8),
                                        child: Text(revPageController.revisionsList[index].lord!, style: TextStyle(fontSize: 20, color: Colors.black87),softWrap: true,),
                                      )),
                                      Expanded(child: Text(revPageController.revisionsList[index].page!.toString(), style: TextStyle(fontSize: 20, color: Colors.black87),softWrap: true,)),
                                      Expanded(
                                          child: IconButton(
                                            onPressed: () async {

                                              final Uri _url = Uri.parse(revPageController.revisionsList[index].weblink!);

                                              if (!await launchUrl(_url)) {
                                              throw Exception('Could not launch $_url');
                                              }


                                            },
                                            icon: Icon(Icons.link, color: Colors.blueAccent,),

                                          )
                                      ),

                                      Expanded(
                                          child: IconButton(
                                            onPressed: () async {
                                              revPageController.setLocation(
                                                  double.parse(revPageController.revisionsList[index].geoLat!), double.parse(revPageController.revisionsList[index].geoLon!));
                                            },
                                            icon: Icon(Icons.location_on_outlined, color: Colors.blueAccent,),

                                          )
                                      ),

                                    ],
                                  );


                              }
                    )),
                            ),
                          ],
                        ),
                  ),
                ),
              ),

              SizedBox(height: 20,),
              Expanded(
                  flex: 4,
                  child: flutterMap()),

            ],
          ),
        )
    );

}
}
