
import 'package:appwrite/appwrite.dart' hide Locale;
import 'package:camera_app/appsettings.dart';
import 'package:camera_app/model/customdocument_model.dart';
import 'package:camera_app/views/addpage/addpage.dart';
import 'package:camera_app/views/filterpage/filterpage.dart';
import 'package:camera_app/views/homepage/drawer.dart';
import 'package:camera_app/views/homepage/gravetile.dart';
import 'package:camera_app/views/revisionspage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../apptheme.dart';
import '../../controllers/homepage_controller.dart';
import 'package:latlong2/latlong.dart';
import '../../services/AppWriteService.dart';
import '../myobjects.dart';
import '../offlinegravespage.dart';




class HomePage extends StatelessWidget {






  @override
  Widget build(BuildContext context) {
    final HomePageController homePageController = Get.put(HomePageController());


    const ColorFilter invert = ColorFilter.matrix(<double>[
      -1,  0,  0, 0, 255,
      0, -1,  0, 0, 255,
      0,  0, -1, 0, 255,
      0,  0,  0, 1,   0,
    ]);

    Widget flutterMap() {
      return FlutterMap(
        options: MapOptions(
          center: LatLng(
              homePageController.graveList
                          .where((element) =>
                              element.geoLon != "" && element.geoLat != "")
                          .toList()
                          .length >
                      0
                  ? double.parse(homePageController.graveList
                      .where((element) =>
                          element.geoLon != "" && element.geoLat != "")
                      .toList()
                      .first
                      .geoLat!)
                  : 50.0,
              homePageController.graveList
                          .where((element) =>
                              element.geoLon != "" && element.geoLat != "")
                          .toList()
                          .length >
                      0
                  ? double.parse(homePageController.graveList
                      .where((element) =>
                          element.geoLon != "" && element.geoLat != "")
                      .toList()
                      .first
                      .geoLon!)
                  : 20.0),
          zoom: 5,
          boundsOptions: FitBoundsOptions(padding: EdgeInsets.all(8.0)),
          interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
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




          MarkerLayer(markers: homePageController.graveMarkers)
        ],
      );
    }

    Widget listGraves() {
      if (homePageController.isLoading.value)
        return Center(child: CircularProgressIndicator());
      else
        return RefreshIndicator(
          onRefresh: () async {
            if(homePageController.activeFilters.value.length>0){
              //homePageController.fetchGravesAll(homePageController.activeFilters.value);
              homePageController.fetchGravesPaginated(filtersList:homePageController.activeFilters.value, reset: true);
            }
            else{
              //homePageController.fetchGravesPaginated(filtersList:homePageController.activeFilters.value);
              homePageController.fetchGravesPaginated(reset: true);
            }

            print(homePageController.activeFilters.length);
          },
          child:
          Obx(()=> ListView.builder(
              padding: EdgeInsets.zero,
              controller: homePageController.scrollController,
              //addAutomaticKeepAlives: true,
              // shrinkWrap: true,
              cacheExtent: 9999,
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemCount: homePageController.graveList.length + 1,
              itemExtent: 110,
              itemBuilder: (context, index) {

                if(index < homePageController.graveList.length){
                  return Padding(
                    padding: EdgeInsets.only(left:5, right: 5, top:3, bottom: 3),
                    child: InkWell(
                      // splashColor: Colors.redAccent,

                      borderRadius: BorderRadius.circular(30),

                      child: GraveTile(homePageController.graveList[index]),
                      onTap: () async {

                        /*   if (homePageController.graveList[index].status == 0) {
                          await Get.to(AddPage(), arguments: homePageController.graveList[index]);
                        }
                        else if (homePageController.graveList[index].status == 1) {
                          await Get.toNamed("/details" , arguments: {'cid': homePageController.graveList[index].customDocumentId!,});
                        }
*/




                        if (homePageController.graveList[index].status == 0) {
                          await Get.to(AddPage(), arguments: homePageController.graveList[index]);
                        }
                        else if (homePageController.graveList[index].status == 1) {
                          var res = await AppWriteService.getGrave(homePageController.graveList[index].customDocumentId!);
                          if (res is AppwriteException) {
                            // Get.defaultDialog(content: Text(res.message!));

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(duration: Duration(seconds: 2), content: Text(res.message!,
                              ),
                              ),
                            );


                          } else if (res is CustomDocument) {

                            var updDoc = await Get.toNamed("/details" , parameters:  {'cid': res.customDocumentId!,}, arguments:res );

                            if (updDoc != null) {
                              homePageController.graveList[index] = updDoc;
                              homePageController.graveList.refresh();
                              var newMarker =
                              homePageController.newMarker(updDoc);
                              homePageController.graveMarkers[index] =
                              newMarker!;
                              homePageController.graveMarkers.refresh();
                            }


                          }
                        }
                      },
                    ),
                  );
                }

                else{

                  print("koniec listy");
                 // return  Center(child: CircularProgressIndicator());

                }






              })),
        );
    }

    Widget listColumnView() {
      return Row(
        children: [
          Expanded(flex: 3, child: listGraves()),
          Expanded(flex: 5, child: flutterMap()),
        ],
      );
    }

    Widget listMapStackView() {
      return Obx(() => IndexedStack(
            index: homePageController.stackIndex.value,
            children: [flutterMap(), listGraves()],
          ));
    }

    showTypeDialog() async{
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return

            Dialog(
                child:
                Container(
                  constraints: BoxConstraints( maxWidth: 500),
                  child: Padding(
                    padding: const EdgeInsets.only(top:15.0, bottom: 20, left:20),
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),),
                        itemCount: listTypes.length,
                        itemBuilder: (context, index) {
                          return
                            ListTile(
                              leading: listTypes[index].icon,
                              title: Text(listTypes[index].label.tr, style: TextStyle(fontSize: 20),softWrap: true,),
                              onTap: () {

                                homePageController.typeId.value = listTypes[index].typeID;
                                Navigator.pop(context);
                                Get.to(AddPage(), arguments:homePageController.typeId.value);
                              },
                            );

                        }
                        )
                  ),
                )


            );





        },
      );

    }


    return Scaffold(
      drawer: HomePageDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
           // iconTheme: IconThemeData(color: Colors.black54),
          //  backgroundColor: mainBackgroundColor,
            centerTitle: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

               // SizedBox(width: 30,),




           /*     Visibility(
                  visible: false,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:10, right:10),
                        child: Container(
                          padding: EdgeInsets.all(1),

                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              //color: Colors.yellow,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton( onPressed: () {  }, icon: FaIcon(FontAwesomeIcons.cross,size: 23, ))
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left:10, right:10),
                        child: Container(
                            padding: EdgeInsets.all(1),

                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              //color: Colors.yellow,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton( onPressed: () {  }, icon: Icon(Icons.church_outlined,size: 23, ))
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left:10, right:10),
                        child: Container(
                            padding: EdgeInsets.all(1),

                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              //color: Colors.yellow,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                                onPressed: () async {
                                //  var c = await Get.to(RevisionsPage());

                                 // var c = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => RevisionsPage()));

                                  var c = await Get.toNamed("/revisions");

                                },
                                icon: FaIcon(FontAwesomeIcons.list,size: 23, ))
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left:10, right:10),
                        child: Container(
                            padding: EdgeInsets.all(1),

                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              //color: Colors.yellow,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton( onPressed: () {  }, icon: FaIcon(FontAwesomeIcons.book,size: 23, ))
                        ),
                      ),

                    ],
                  ),
                ),*/


               // Spacer(),

                Container(
                    height: 40,
                    child: Image(
                        //fit: BoxFit.fitHeight,
                        image: AssetImage(
                          AppTheme.isThemeDark
                              ? 'assets/images/night_logo.png'
                              :'assets/images/light_logo.png',
                        ))),
                SizedBox(
                  width: 30,
                ),
                Obx(() => ElevatedButton(
                      onPressed: () async {

                        var filterResult;
                        if(homePageController.activeFilters.length>0){
                          filterResult =await Get.to(FilterPage(), arguments: homePageController.activeFilters.value);
                        }

                        else{
                          filterResult = await Get.to(FilterPage());
                        }

                        if (filterResult != null ) {
                          var filters = filterResult as List<Filter>;
                          if(filters.length > 0)
                            {
                              //await homePageController.fetchGravesAll(filters);
                              await homePageController.fetchGravesPaginated(filtersList: filters,reset: true);
                            }
                          else{
                            homePageController.activeFilters.clear();
                            //await homePageController.fetchGravesAll();
                            await homePageController.fetchGravesPaginated(reset: true);
                          }
                        }

                      },
                      child: Icon(
                        Icons.search,
                        // color: Colors.black54,
                        color: AppTheme.searchButtonIconColor,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.searchButtonColor,
                        shape: CircleBorder(
                            side: homePageController.activeFilters.value.length > 0
                                ? BorderSide(
                                    color: AppTheme.activeFiltersBorderColor,
                                    width: 2)
                                : BorderSide.none),
                        padding: EdgeInsets.all(12),
                      ),
                    )),
                SizedBox(
                  width: 20,
                ),
               // Spacer(),
              ],
            )),
      ),
      backgroundColor: AppTheme.backgroundColor2,
      floatingActionButton: Obx(() => Container(
          child: homePageController.isFabsVisible.value == true
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Visibility(
                      visible: kIsWeb && AppSettings.loginInfo.userId == '' ? false : true,
                      child: FloatingActionButton(
                        heroTag: "btnAddGrave",
                        onPressed: () async {

                         // Get.to(OfflineGravesPage());

                           await showTypeDialog();
                        },
                        child: Icon(Icons.add, color: AppTheme.onButtonColor1),
                          backgroundColor: AppTheme.buttonColor1
                      ),
                    ),

                    SizedBox(
                      width: 15,
                    ),



                    Visibility(
                      visible: !kIsWeb,
                    child: FloatingActionButton(
                        heroTag: "btnOfflineGraves",
                        onPressed: () async {

                          Get.to(
                              OfflineGravesPage()
                              ,transition: Transition.downToUp
                              ,duration: const Duration(milliseconds: 300),
                          );

                          // await showTypeDialog();
                        },
                        child: Icon(Icons.edit_note_sharp,color:AppTheme.onButtonColor2),
                          backgroundColor: AppTheme.buttonColor2
                      ),
                    ),

                    SizedBox(
                      width: 15,
                    ),
                    FloatingActionButton(
                      heroTag: "btnStackMap",
                      onPressed: () {
                        homePageController.stackIndex.value =
                            homePageController.stackIndex.value == 0 ? 1 : 0;
                      },
                      child: Obx(() => Icon(
                          homePageController.stackIndex.value == 0
                              ? Icons.list
                              : Icons.map,
                        color:AppTheme.onButtonColor3,

                      )),
                      backgroundColor: AppTheme.buttonColor3,
                    ),
                  ],
                )
              : null)),
      body:

     // listMapStackView()



    LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {

          if (constraints.maxWidth > 800) {
            return listColumnView();
          } else {
            return listMapStackView();
          }
        },
      ),

   //  listMapStackView()
    );
  }
}
