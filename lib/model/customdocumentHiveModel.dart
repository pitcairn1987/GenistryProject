import 'dart:convert';
import 'package:hive/hive.dart';
import 'customdocument_model.dart';
part 'customdocumentHiveModel.g.dart';

@HiveType(typeId: 0)
class CustomDocumentHiveModel extends HiveObject {
  CustomDocumentHiveModel({
    this.CustomDocumentID,
    required this.CustomDocumentTypeID,
    required this.CreateUserID,
    this.ValidateUserID,
    this.Place,
    this.Address,
    this.Year,
    this.GeoLat,
    this.GeoLon,
    required this.Photos,
    this.Persons,
    required this.Status,
    this.AdditionalInfo,
    this.personsTags,
    this.yearTags
  });

  @HiveField(0)
  String? CustomDocumentID;
  @HiveField(1)
  int CustomDocumentTypeID;
  @HiveField(2)
  String CreateUserID;
  @HiveField(3)
  int? ValidateUserID;
  @HiveField(4)
  String? Place;
  @HiveField(5)
  String? Address;
  @HiveField(6)
  String? Year;
  @HiveField(7)
  String? GeoLat;
  @HiveField(8)
  String? GeoLon;
  @HiveField(9)
  String Photos;
  @HiveField(10)
  String? Persons;
  @HiveField(11)
  int Status;
  @HiveField(12)
  String ? AdditionalInfo;
  @HiveField(13)
  String ? personsTags;
  @HiveField(14)
  String ? yearTags;

  factory CustomDocumentHiveModel.fromCustomDocument(CustomDocument doc) {
    return CustomDocumentHiveModel(
        CustomDocumentID: doc.customDocumentId,
        CustomDocumentTypeID: doc.customDocumentTypeId,
        CreateUserID: doc.createUserId,
        ValidateUserID: doc.validateUserId,
        Place: doc.place,
        Address: doc.address,
        Year: doc.year,
        GeoLat: doc.geoLat,
        GeoLon: doc.geoLon,
        Photos: jsonEncode(doc.photos),
        Persons: jsonEncode(doc.persons),
        Status: doc.status,
        AdditionalInfo: doc.additionalInfo,
        personsTags: doc.personsTags_,
        yearTags: doc.yearTags_
    );
  }
}