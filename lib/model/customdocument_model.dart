import 'dart:convert';
import 'dart:typed_data';
import 'package:appwrite/appwrite.dart';
import 'dart:convert' as dc;
import 'customdocumentHiveModel.dart';


String CustomDocumentToJson(CustomDocument data) => dc.json.encode(data.toJson());

List<CustomDocument> CustomDocumentFromJson(String str) =>
    List<CustomDocument>.from(json.decode(str).map((x) => CustomDocument.fromJson(x)));

class CustomDocument {
  CustomDocument({
    this.customDocumentId,
    required this.customDocumentTypeId,
    required this.createUserId,
    this.validateUserId,
    this.place,
    this.address,
    this.year,
    this.geoLat,
    this.geoLon,
    required this.photos,
    this.persons,
    required this.status,
    this.additionalInfo,
    this.personsTags_,
    this.yearTags_
  });

  String? customDocumentId;
  late int customDocumentTypeId;
  late String createUserId;
  int? validateUserId;
  String? place;
  String? address;
  String? year;
  String? geoLat;
  String? geoLon;
  late List<Photo> photos;
  List<Person>? persons;
  late int status;
  String? additionalInfo;
  String? personsTags_;
  String? yearTags_;

  String? get personsString {
    return persons!.map((item) => item.lastName).toList().join(", ");
  }

  CustomDocument.fromJson(Map<String, dynamic> json) {
    customDocumentId = json['CustomDocumentID'];
    customDocumentTypeId = json['CustomDocumentTypeID'];
    createUserId = json['CreateUserID'];
    validateUserId = json['ValidateUserID'];
    place = json['Place'];
    address = json['Address'];
    year = json['Year'];
    geoLat = json['GeoLat'] ??"";
    geoLon = json['GeoLon'] ??"";
    photos = List<Photo>.from(dc.json.decode(json['Photos']).map((x) => Photo.fromJson(x)));
    persons = List<Person>.from(dc.json.decode(json['Persons']).map((x) => Person.fromJson(x)));
    status = json['Status'];
    additionalInfo = json['AdditionalInfo'];
    personsTags_ = json['personsTAGS'];
    yearTags_ = json['yearTAGS'];
  }

  Map<String, dynamic> toJson() => {
        "CustomDocumentID": customDocumentId,
        "CustomDocumentTypeID": customDocumentTypeId,
        "CreateUserID": createUserId,
        "ValidateUserID": validateUserId,
        "Place": place,
        "Address": address,
        "Year": year,
        "GeoLat": geoLat,
        "GeoLon": geoLon,
        "Photos": jsonEncode(photos),
        "Persons": jsonEncode(persons),
        "Status": status,
        "AdditionalInfo": additionalInfo,
        "personsTAGS": personsTags_,
        "yearTAGS": yearTags_,
      };

  factory CustomDocument.fromCustomDocumentHiveModel(CustomDocumentHiveModel doc) {
    return CustomDocument(
      customDocumentId: doc.key.toString(),
      customDocumentTypeId: doc.CustomDocumentTypeID,
      createUserId: doc.CreateUserID,
      validateUserId: doc.ValidateUserID,
      place: doc.Place,
      address: doc.Address,
      year: doc.Year,
      geoLat: doc.GeoLat,
      geoLon: doc.GeoLon,
      photos: List<Photo>.from(dc.json.decode(doc.Photos).map((x) => Photo.fromJson(x))),
      persons: List<Person>.from(dc.json.decode(doc.Persons!).map((x) => Person.fromJson(x))),
      status: doc.Status,
      additionalInfo: doc.AdditionalInfo,
      personsTags_: doc.personsTags,
      yearTags_: doc.yearTags
    );
  }
}

class Photo {
  Photo({required this.photoFileId, required this.photoFileName, required this.ocr, this.byteImage,   this.byteImageForWeb});

  String photoFileId;
  String photoFileName;
  String ocr;
  Uint8List? byteImage;
 // List<dynamic >? byteImageForWeb;
  List<int>? byteImageForWeb;

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        photoFileId: json["PhotoFileID"],
        photoFileName: json["PhotoFileName"],
        ocr: json["Ocr"],
      byteImageForWeb: json["ByteImageForWeb"]
      );

  Map<String, dynamic> toJson() => {
        "PhotoFileID": photoFileId,
        "PhotoFileName": photoFileName,
        "Ocr": ocr,
    "ByteImageForWeb": byteImageForWeb,

      };
}

class Person {
  Person(
      {required this.firstName,
      required this.lastName,
        required this.maidenName,
      required this.birthYear,
      required this.deathYear,
      required this.age,
      this.addInfo});

  String firstName;
  String lastName;
  String maidenName;
  String birthYear;
  String deathYear;
  String? age;
  String? addInfo;

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        firstName: json["FirstName"],
        lastName: json["LastName"],
        maidenName: json["MaidenName"],
        birthYear: json["BirthYear"],
        deathYear: json["DeathYear"],
        age: json["Age"],
        addInfo: json["AddInfo"],
      );

  Map<String, dynamic> toJson() => {
        "FirstName": firstName,
        "LastName": lastName,
        "MaidenName": maidenName,
        "BirthYear": birthYear,
        "DeathYear": deathYear,
        "Age": age,
        "AddInfo": addInfo,
      };
}




class Filter {
  late String dictionaryCode;
  late String type;
  late List<dynamic> filterValues;
 String  generatedQuery="";


  Filter(String dictionaryCode, String type, List<dynamic>filterValues){
    this.dictionaryCode = dictionaryCode;
    this.type = type;
    this.filterValues = filterValues;

    if(filterValues.length>0){
      if(type == "equal") {
        this.generatedQuery = Query.equal(dictionaryCode, filterValues);
      }
      else if (type == "search") {
        this.generatedQuery = Query.search(dictionaryCode, filterValues[0]);
      }

    }

  }
}


