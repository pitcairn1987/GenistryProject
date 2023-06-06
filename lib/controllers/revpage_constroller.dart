
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'package:appwrite/appwrite.dart';
import 'package:camera_app/model/revision_model.dart';
import 'package:get/get.dart';

import '../apptheme.dart';
import '../model/customdocument_model.dart';
import '../services/AppWriteService.dart';
import 'package:flutter_map/flutter_map.dart';



class RevPageController extends GetxController {

  var revisionsList = <Revision>[].obs;
  var revisionsMarkers = <Marker>[].obs;
  final mapController = MapController();
  var latController = 0.0.obs;
  var lonController = 0.0.obs;
  late List<Filter> listFilters;

  var searchPlaceController = TextEditingController();
  var searchDescriptionController = TextEditingController();
  var searchLordController = TextEditingController();


  generateFilters(){

    listFilters.clear();


    var place = searchPlaceController.text;
    var description = searchDescriptionController.text;
    var lord = searchLordController.text;

    var filter;



    if(place!= "") {
      var values = <dynamic>[];
      values.add(place);
      filter = Filter("Place", "search", values);
      listFilters.add(filter);
    }

    if(description!= "") {
      var values = <dynamic>[];
      values.add(description);
      filter = Filter("Description", "search", values);
      listFilters.add(filter);
    }

    if(lord!= "") {
      var values = <dynamic>[];
      values.add(lord);
      filter = Filter("Lord", "search", values);
      listFilters.add(filter);
    }

    print(listFilters.length);

    // return listFilters;

  }








  @override
  void onInit() {
    listFilters = <Filter>[];
    fetchRevisions();

    super.onInit();

  }







  Marker? newMarker(Revision doc) {
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
                  child:  Icon(Icons.location_on, size: 30, color: Colors.blue[700]),

                  )));
      return marker;
    }
  }

  List<Marker> getMarkers(List<Revision> c) {
    List<Marker> _markers = [];
    c.forEach((element) {
      _markers.add(newMarker(element)!);

    });

    return _markers;
  }




  void setLocation(double lat, double lon) async {
    mapController.center.latitude = lat;
    mapController.center.longitude = lon;
    latController.value = lat;
    lonController.value = lon;

    LatLng currentCenter = LatLng(lat, lon);
    mapController.move(currentCenter, 17.0);
  }




  Future<void> fetchRevisions() async {
    print("FETCHING..........");
    revisionsList.clear();
    revisionsMarkers.clear();

    List<String>? queries;
    var res;
    res =await AppWriteService.fetchRevisions();


    if(listFilters !=null && listFilters.length > 0)  {
      queries =  listFilters.map((e) => e.generatedQuery).toList();
      // isLoading(true);
      res =await AppWriteService.fetchRevisions(listQueries:   queries);
    }

    else{
      // isLoading(true);
      res =await AppWriteService.fetchRevisions();

    }





    if (res is AppwriteException) {
      await Get.defaultDialog(content:Text(res.message!, style: TextStyle(color: AppTheme.inputFontColor), ), title: "", backgroundColor: AppTheme.backgroundColor1 );
    }
    else if ( res is List<Revision>)
    {
      revisionsList.addAll(res);
      revisionsMarkers.value.addAll(getMarkers(res.where((element) => element.geoLat != "" &&  element.geoLon != "").toList()));

    }


  }














  void onClose() {
    super.onClose();
  }

  @override
  void dispose() {

    super.dispose();
  }



}
