import 'dart:convert';
import 'dart:convert' as dc;

String RevisionToJson(Revision data) => dc.json.encode(data.toJson());

List<Revision> RevisionFromJson(String str) =>
    List<Revision>.from(json.decode(str).map((x) => Revision.fromJson(x)));

class Revision {
  Revision({
    this.revisionId,
    this.page,
    required this.createUserId,
    this.place,
    this.description,
    this.weblink,
    this.lord,
    this.geoLat,
    this.geoLon,

  });

  String? revisionId;
   int ? page;
  late String createUserId;
  String? place;
  String? description;
  String? weblink;
  String? lord;
  String? geoLat;
  String? geoLon;




  Revision.fromJson(Map<String, dynamic> json) {
    revisionId = json['RevisionID'];
    page = json['Page']??"";
    createUserId = json['CreateUserID'];
    place = json['Place']??"";
    description = json['Description']??"";
    weblink = json['WebLink']??"";
    lord = json['Lord']??"";
    geoLat = json['GeoLat'] ??"";
    geoLon = json['GeoLon'] ??"";

  }

  Map<String, dynamic> toJson() => {
    "RevisionID": revisionId,
    "Page": page,
    "CreateUserID": createUserId,
    "Place": place,
    "Description": description,
    "WebLink": weblink,
    "Lord": lord,
    "GeoLat": geoLat,
    "GeoLon": geoLon,
  };

}




