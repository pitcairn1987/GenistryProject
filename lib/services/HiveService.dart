import 'package:camera_app/appsettings.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../model/customdocumentHiveModel.dart';
import '../model/customdocument_model.dart';
import 'dart:io';

class HiveService {
  static const String hive_box = "myBox";

  static Future<List<CustomDocument>> fetchGraves() async {
    final box = await Hive.openBox<CustomDocumentHiveModel>(hive_box);

    var list = box.values.toList();
    List<CustomDocument> graves = [];

    list.forEach((element) {
      var doc = CustomDocument.fromCustomDocumentHiveModel(element);
      graves.add(doc);
    });

    return graves;
  }

  static Future<void> removeGrave(String key) async {
    final box = await Hive.openBox<CustomDocumentHiveModel>(hive_box);
    var grave = box.values.toList().firstWhere((element) => element.key.toString() == key);

    var doc = CustomDocument.fromCustomDocumentHiveModel(grave);

    if(!kIsWeb){
      for (int i = 0; i < doc.photos.length; i++) {
        var file = AppSettings.temporaryDirectoryPath + "/" + doc.photos[i].photoFileName;
        File(file).delete();
      }
    }

    await grave.delete();
  }


  static Future<CustomDocumentHiveModel?> addGrave(CustomDocument doc) async {
    var newDoc = CustomDocumentHiveModel.fromCustomDocument(doc);
    var box = await Hive.openBox<CustomDocumentHiveModel>(hive_box);
    var key = await box.add(newDoc);

    var grave = box.values.toList().firstWhere((element) => element.key == key);

    return grave;
  }

  static updateGrave(CustomDocument doc) async {
    var updDoc = CustomDocumentHiveModel.fromCustomDocument(doc);
    var box = await Hive.openBox<CustomDocumentHiveModel>(hive_box);

    var grave = box.values.toList().firstWhere((element) => element.key.toString() == doc.customDocumentId);
    int index = box.values.toList().indexOf(grave);
    await box.putAt(index, updDoc);
  }

  Future<List<CustomDocumentHiveModel>> getGraves() async {
    var box = await Hive.openBox(hive_box);

    List<CustomDocumentHiveModel> list = [];

    for (int i = 0; i < box.length; i++) {
      var doc = box.getAt(i);
      list.add(doc);
    }

    return list;
  }

  close() => Hive.close();

}
