import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:osm_nominatim/osm_nominatim.dart';


class GeoInfoController extends GetxController {
  late Position position;
  var latController = 0.0.obs;
  var lonController = 0.0.obs;
  final searchPlaceController = TextEditingController();
  dynamic argumentData = Get.arguments;

  final mapController = MapController();
  bool updateMode = false;

  var graveMarkers = <Marker>[].obs;
   var dropdownValue = "One".obs;
  var myFocusNode = FocusNode().obs;
  var searchController = TextEditingController();

  var suggestionList = <Place>[].obs;

   searchPlace ()async{
     suggestionList.value = await Nominatim.searchByName(
      query: searchPlaceController.text,
      limit: 5,
      addressDetails: true,
      extraTags: false,
      nameDetails: true,
    );

  }

  @override
  void onInit() {

    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (argumentData != null) {
        updateMode = true;

        setLocation(double.parse(argumentData[0]), double.parse(argumentData[1]));

        graveMarkers.clear();

        var marker = Marker(
            width: 80.0,
            height: 80.0,
            point: LatLng(double.parse(argumentData[0]), double.parse(argumentData[1])),
            builder: (ctx) => Container(child: FaIcon(FontAwesomeIcons.cross, color: Colors.blue[700], size: 30)));
        graveMarkers.add(marker);
      }
    });
  }

  void onClose() {
    super.onClose();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  void setLocation(double lat, double lon) async {
    mapController.center.latitude = lat;
    mapController.center.longitude = lon;
    latController.value = lat;
    lonController.value = lon;

    LatLng currentCenter = LatLng(lat, lon);
    mapController.move(currentCenter, 17.0);
  }

  Future<String?> getAddressFromLatLong(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      //   print(placemarks);
      Placemark place = placemarks[0];
      return '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    } catch (e) {
      return null;
    }
  }

  Future<Position> getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }



}
