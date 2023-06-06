import 'dart:convert';
import 'dart:convert' as dc;
import 'package:get/get.dart';

String DictionaryToJson(Dictionary data) => dc.json.encode(data.toJson());

List<Dictionary> DictionaryFromJson(String str) =>
    List<Dictionary>.from(json.decode(str).map((x) => Dictionary.fromJson(x)));

class Dictionary {
  Dictionary({
    required this.description,
    required this.dictionaryCode,
    required this.status,
    this.dictionaryValue,
  });

  late String description;
  late String dictionaryCode;
  late int status;
  dynamic dictionaryValue;
  var isSelected = false.obs;
  var prevValue = false;

  Dictionary.fromJson(Map<String, dynamic> json) {
    description = json['Description'];
    dictionaryCode = json['DictionaryCode'];
    status = json['Status'];
    dictionaryValue = json['DictionaryValue'];
  }

  Map<String, dynamic> toJson() => {
        "Description": description,
        "DictionaryCode": dictionaryCode,
        "Status": status,
      };
}
