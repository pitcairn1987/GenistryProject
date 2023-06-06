import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:camera_app/apptheme.dart';
import 'package:camera_app/model/customdocument_model.dart';
import 'package:camera_app/model/dictionaries_model.dart';
import 'package:camera_app/services/AppWriteService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../appsettings.dart';
import '../views/addpage/addpage.dart';

class HomePageController extends GetxController
{


  final searchController = TextEditingController();

  var isLoading = false.obs;
  var graveList = <CustomDocument>[].obs;
  var dictionaryList = <Dictionary>[];
  //var filtersList = <Filter>[];
  var newFilter = Filter("","", []).obs;
  var queriesList = <dynamic>[];
  var graveMarkers = <Marker>[].obs;
  var stackIndex = 0.obs;
  var userName = "".obs;
  var logoWidth = 100.0.obs;
  var expanded = true.obs;
  var filterOwn = false.obs;
  var typeId = 0.obs;
  late ScrollController scrollController;
  var iconContainerHeight = 55.00.obs;

  var isFabsVisible = true.obs;
  var selectedItems;

  var activeFilters = <Filter>[].obs;


  var checkBoxValue = false.obs;

  var lastId;
  var page = 0;

  var filterTypeId = 0.obs;

  void _scrollListener() {
    if (scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (isFabsVisible.value == true) isFabsVisible.value = false;
    }
    if (scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (isFabsVisible.value == false) isFabsVisible.value = true;
    }

    if(scrollController.position.maxScrollExtent == scrollController.offset){

      print("fetch more");
      fetchGravesPaginated(filtersList: activeFilters.value);
    }
  }



  @override
  void onInit() {

    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
     Directory dir = Directory(AppSettings.temporaryDirectoryPath);

// execute an action on each entry
   /* print("FILE LIST:");

    dir.list(recursive: true).forEach((f) {
        print(f);
    });*/


   // fetchGravesAll();
    fetchGravesPaginated(reset: true);
    super.onInit();

  }


  void setGraveListAndMarkers(List<CustomDocument> list) {
    graveList.addAll(list);
   // graveList.insertAll(graveList.length, list);
  //  graveMarkers.value = getMarkers(list.where((element) => element.geoLat != "" &&  element.geoLon != "").toList());
    graveMarkers.value.addAll(getMarkers(list.where((element) => element.geoLat != "" &&  element.geoLon != "").toList()));
  }


  Marker? newMarker(CustomDocument doc) {
    if (doc.geoLat != "" && doc.geoLon != "") {
      var lat = double.parse(doc.geoLat!);
      var lon = double.parse(doc.geoLon!);

      var marker = Marker(
          //customdocument: element,
          width: 80.0,
          height: 80.0,
          point: LatLng(lat, lon),
          builder: (ctx) => Container(
              child: GestureDetector(
                  child: doc.customDocumentTypeId == 0
                      ? FaIcon(FontAwesomeIcons.cross, color: Colors.blue[700], size: 30)
                      : Icon(Icons.church_sharp, size: 30, color: Colors.blue[700]),
                  onTap: () {
                    // print(element.jData);
                    Get.to(AddPage(), arguments: doc);
                  })));
      return marker;
    }
  }

  List<Marker> getMarkers(List<CustomDocument> c) {
    List<Marker> _markers = [];
    c.forEach((element) {
      _markers.add(newMarker(element)!);

    });

    return _markers;
  }

  Future<void> fetchGravesAll([List<Filter>? filtersList]) async {
    print("FETCHING..........");
   List<String>? queries;
  //  graveList.clear();

    var res;

    if(filtersList !=null && filtersList.length > 0)  {
      queries =  filtersList.map((e) => e.generatedQuery).toList();
      isLoading(true);
      res =await AppWriteService.fetchGraves(queries);
    }

    else{
      isLoading(true);
      res =await AppWriteService.fetchGraves(null);

    }

    //isLoading(true);

    //var res =await AppWriteService.fetchGraves(queries);


   if (res is AppwriteException) {
      await Get.defaultDialog(content:Text(res.message!, style: TextStyle(color: AppTheme.inputFontColor), ), title: "", backgroundColor: AppTheme.backgroundColor1 );
    } else {
     graveList.clear();
     print(res.length);
       setGraveListAndMarkers(res);
       if(filtersList !=null && filtersList.length > 0) {
         //activeFilters.value.clear() ;
         activeFilters.value= filtersList;
       //  activeFilters.value = filtersList;
       }
    }

    isLoading(false);


  }




  Future<void> fetchGravesPaginated({List<Filter>? filtersList, bool  reset = false}) async {
    print("FETCHING..........");
    List<String>? queries;
     // graveList.clear();

    if(reset == true){
      graveList.clear();
      graveMarkers.clear();
      page = 0;
      lastId = null;
    }

    var res;

    if(filtersList !=null && filtersList.length > 0)  {
      queries =  filtersList.map((e) => e.generatedQuery).toList();
      activeFilters.value= filtersList;
     // isLoading(true);
      res =await AppWriteService.fetchGraves( queries,lastId = lastId);
    }

    else{
     // isLoading(true);
      res =await AppWriteService.fetchGraves(null,lastId = lastId);

    }

    //isLoading(true);

    //var res =await AppWriteService.fetchGraves(queries);


    if (res is AppwriteException) {
      await Get.defaultDialog(content:Text(res.message!, style: TextStyle(color: AppTheme.inputFontColor), ), title: "", backgroundColor: AppTheme.backgroundColor1 );
    }
    else if ( res is List<CustomDocument>)
    {
      print(res.length);

      if(res.length> 0){
        lastId =  res[res.length - 1].customDocumentId;
        page = page + 1;
        print(page);
        setGraveListAndMarkers(res);


      /*  if(filtersList !=null && filtersList.length > 0) {
          activeFilters.value= filtersList;
        }*/

      }


    }

   // isLoading(false);


  }











  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
