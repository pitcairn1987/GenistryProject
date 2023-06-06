import 'dart:typed_data';
import 'package:appwrite/appwrite.dart' ;
import 'package:appwrite/models.dart' as model;
import 'package:appwrite/models.dart';
import 'package:camera_app/appsettings.dart';
import 'package:camera_app/model/customdocument_model.dart';
import 'package:camera_app/model/dictionaries_model.dart';
import 'package:camera_app/model/revision_model.dart';
import 'package:camera_app/services/HiveService.dart';
import 'dart:io' as IO;

import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';

class AppWriteService {



 static const String DataBaseID = '63fcc803d9ebf1fb309f';
  static const String CustomDocumentsTableID = '63fcc817496ce12b9452';
  static const String RevisionsTableID = '6475ababc75380030118';
  static const String DictionariesTableID = '634e8bc39c9cd41eee95';
  static const String endPoint = 'https://api.genistry.pl/v1';
  static const String projectID = '63fcc7985333af8e4dfa';
  static const String bucketID = '63fcf5d136cdf2569f8f';




/*


 static const String DataBaseID = '63d02e6d999b22bb75d3';
 static const String CustomDocumentsTableID = '63d02e7b285559f9d50e';
 static const String RevisionsTableID = '6475ababc75380030118';
 static const String DictionariesTableID = '634e8bc39c9cd41eee95';
 static const String endPoint = 'https://cloud.appwrite.io/v1';
 static const String projectID = '63d0123102a437b647c0';
 static const String bucketID = '63d02f7f90494beb8432';

*/







  static late Client client;
  static late Databases databases;
  static late Account account;
  static late bool isLogged;
  static late Storage storage;

  static  init()  {
    print("AppWriteService init");
    isLogged = false;
    client = Client();
    client
            .setEndpoint(endPoint) // Your API Endpoint
            .setProject(projectID)
           // .setSelfSigned(status: true)// Your project ID
        ;
    databases = new Databases(client);
    account = Account(client);
    storage = Storage(client);

  /*  final realtime = Realtime(client);

// Subscribe to files channel
    final subscription = realtime.subscribe(['files']);

    subscription.stream.listen((response) {
      if(response.events.contains('buckets.*.files.*.create')) {
        // Log when a new file is uploaded
        print(response.payload);
      }
    });*/


  }



  static Future<void> sentVerificationEmail() async {
    var res;
    try {
      res = await account.createVerification( url: '');

    } catch (error) {
      res = error;
    }
    return res;
  }

  static Future<dynamic> logout() async {
    var res;
    try {
      res = await account.deleteSession(sessionId: 'current');
    } catch (error) {
      res = error;
    }
    return res;
  }

  static Future<dynamic> getAccountInfo() async {
    var res;
    try {
      res = await account.get();
    } catch (error) {
      res = error;
    }
    return res;
  }


  static Future<dynamic> getSession() async {
    var res;
    try {
      res = await account.getSession(sessionId: 'current');
    } catch (error) {
      res = error;
    }
    return res;
  }


  static Future<dynamic> login(String email, String password) async {
    var res;
    try {
      res = await account.createEmailSession(email: email, password: password);
    } catch (error) {
      res = error;
    }
    return res;
  }


  static Future<dynamic> loginByProvider(String provider) async {
    var res;
    try {
      res = await account.createOAuth2Session(
          provider: provider,
          success:   kIsWeb ?  "https://genistry.pl/auth.html" : null
          );
    } catch (error) {
      res = error;
    }
    print(res);
    return res;
  }

  static Future<dynamic> createAccount(String userID, String email, String pass) async {
    var res;
    try {
      res = await account.create(userId: userID, email: email, password: pass);
    } catch (error) {
      res = error;
    }
    return res;
  }


  static Future<dynamic> fetchDictionariesByCode(String code) async {
    var res;
    var resDoc;
    try {
      resDoc = await databases
          .listDocuments(collectionId: DictionariesTableID, queries: [Query.equal('DictionaryCode', code)], databaseId: DataBaseID);

      List<Dictionary> items = [];

      resDoc.documents.forEach((element) {
        var doc = Dictionary.fromJson(element.data);
        items.add(doc);
      });
      res = items;
    } catch (error) {
      res = error;
    }

    return res;
  }

  static Future<dynamic> fetchAllDictionaries() async {
    var res;
    var resDoc;
    try {
      resDoc = await databases.listDocuments(
        collectionId: DictionariesTableID, databaseId: DataBaseID,
      );

      List<Dictionary> items = [];

      resDoc.documents.forEach((element) {
        var doc = Dictionary.fromJson(element.data);
        items.add(doc);
      });
      res = items;
    } catch (error) {
      res = error;
    }

    return res;
  }

  static Future<dynamic> getGrave(String id) async {
    var res;
    var doc;
    try {
      res = await databases.getDocument(collectionId: CustomDocumentsTableID, documentId: id, databaseId: DataBaseID);

      doc = CustomDocument.fromJson(res.data);
      doc.customDocumentId = res.$id;
      res = doc;
    } catch (error) {
      res = error;
    }

    return res;
  }

  static Future<dynamic> updateGrave(String id, Map data) async {
    var res;
    try {
      res = await databases.updateDocument(collectionId: CustomDocumentsTableID, documentId: id, data: data, databaseId: DataBaseID);
    } catch (error) {
      res = error;
    }

    return res;
  }


  static Future<dynamic> fetchGraves_without_pag(List<String>? listQueries) async {
    var res;
    var resDoc;


    var defaultQueries = [Query.limit(30), Query.orderDesc('\$createdAt')];

    try {
      if(listQueries == null){

        resDoc = await databases.listDocuments(
          collectionId: CustomDocumentsTableID, databaseId:DataBaseID,
          queries: defaultQueries
        );
      }

      else {

        listQueries.addAll(defaultQueries);
        resDoc = await databases.listDocuments(
            collectionId: CustomDocumentsTableID,
            queries: listQueries, databaseId: DataBaseID
        );
      }


      List<CustomDocument> items = [];

      resDoc.documents.forEach((element) {
        CustomDocument? doc;
        if (element is model.Document) {
          doc = CustomDocument.fromJson(element.data);
          doc.customDocumentId = element.$id;
        }
        items.add(doc!);
      });
      res = items;
    } catch (error) {
      res = error;
    }

    return res;
  }




 static Future<dynamic> fetchGraves(List<String>? listQueries, [String ? lastId]) async {
   var res;
   var resDoc;


   var defaultQueries = [
     Query.orderDesc('\$createdAt'),
     Query.limit(15),
     if (lastId != null) Query.cursorAfter(lastId),
   ];

   try {
     if(listQueries == null){

       resDoc = await databases.listDocuments(
           collectionId: CustomDocumentsTableID, databaseId:DataBaseID,
           queries: defaultQueries
       );
     }

     else {

       listQueries.addAll(defaultQueries);
       resDoc = await databases.listDocuments(
           collectionId: CustomDocumentsTableID,
           queries: listQueries, databaseId: DataBaseID
       );
     }




     List<CustomDocument> items = [];

     resDoc.documents.forEach((element) {
       CustomDocument? doc;
       if (element is model.Document) {
         doc = CustomDocument.fromJson(element.data);
         doc.customDocumentId = element.$id;
       }
       items.add(doc!);
     });
     res = items;
   } catch (error) {
     res = error;
   }

   return res;
 }











 static Future<dynamic> fetchGravesByFilter(List<String> list) async {
    var res;
    var resDoc;

    try {
      resDoc = await databases.listDocuments( collectionId: CustomDocumentsTableID, queries: list, databaseId: DataBaseID);

      List<CustomDocument> items = [];

      resDoc.documents.forEach((element) {
        CustomDocument? doc;
        if (element is model.Document) {
          doc = CustomDocument.fromJson(element.data);
          doc.customDocumentId = element.$id;
        }
        items.add(doc!);
      });
      res = items;
    } catch (error) {
      res = error;
    }

    return res;
  }



  static Future<List<CustomDocument>> fetchThumbnails(List<CustomDocument> docs) async {
    print("fetching photos");
    var cc = await Future.wait(docs.map((cd) => getImagePreviewBytes(cd)));

    return cc;
  }

  static Future<void> fetchGraveThumbnails(List<Photo> list) async {
    print("fetching photos");
    var cc = await Future.wait(list.map((ph) => getImagePreviewFiles(ph.photoFileId)));
  }

  static Future<dynamic> postAllGraves(List<CustomDocument> docs) async {
    var res = await Future.wait(docs.map((cd) => createGrave(cd, AppSettings.loginInfo.userId)));

    if (res[0] is model.Document) {
      var list = res.map((item) => item as model.Document).toList();
      return list;
    } else if (res[0] is AppwriteException) {
      return res[0];
    }
  }

  static Future<dynamic> sentImage(Photo photo) async {

    var res;
    if(kIsWeb)
    {
      try {
        List<int>? intList = photo.byteImageForWeb?.cast<int>().toList(); //This is the magical line.
      //  File createFileFromBytes(Uint8List bytes) => File.fromRawPath(photo.byteImageForWeb!);


       // List<int> fileBytes = await file.readAsBytes();
        res = await storage.createFile(
          bucketId: bucketID,
          fileId: 'unique()',
          file:  InputFile.fromBytes(
             // bytes: intList!,
            bytes: photo.byteImageForWeb!,
              filename: photo.photoFileName + '.jpg'
          )
        );

        var newPhoto = new Photo(photoFileId: res.$id, photoFileName: "aaa", ocr: photo.ocr);
        res = newPhoto;
      } catch (error) {
        res = error;
      }

    }
    else{


      IO.File file = IO.File(AppSettings.temporaryDirectoryPath + "/" + photo.photoFileName);

      try {
        res = await storage.createFile(
          bucketId: bucketID,
          fileId: 'unique()',
          file: InputFile(
              path: AppSettings.temporaryDirectoryPath + "/" + photo.photoFileName, filename: photo.photoFileName),
        );

        var newPhoto = new Photo(photoFileId: res.$id, photoFileName: photo.photoFileName, ocr: photo.ocr);
        res = newPhoto;
      } catch (error) {
        res = error;
      }

      print(file.path);

    //  await file.delete();


    }
    return res;


  }

  static Future<void> deleteImage(Photo photo) async {
    var res;
    try {
      res = storage.deleteFile(bucketId: bucketID, fileId: photo.photoFileId);
    } catch (error) {
      res = error;
    }
  }

  static Future<dynamic> deleteImages(List<Photo> photos) async {
    var res = await Future.wait(photos.map((cd) => deleteImage(cd)));
  }

  static Future<String> getImagePreviewFiles(String photoFileID) async {
    print("Ściągam thumbnail");
    var result = await storage.getFilePreview(bucketId: bucketID, fileId: photoFileID, quality: 10);

    IO.File file = IO.File(AppSettings.temporaryDirectoryPath + "/" + photoFileID + '.png');
    file.create();
    file.writeAsBytesSync(result);

    return AppSettings.temporaryDirectoryPath + "/" + photoFileID + '.png';
  }

  static Future<CustomDocument> getImagePreviewBytes(CustomDocument doc) async {
    // print("downloading file $photo.photoFileId");

    //  Storage storage = Storage(client);
    var byteImage = await storage.getFilePreview(
      //  width: 10,
      //   height: 10,
      bucketId: bucketID,
      fileId: doc.photos[0].photoFileId,
      //quality: 1
    );

    // print(byteImage);
    doc.photos[0].byteImage = byteImage;
    return doc;
  }

  static Future<Uint8List> getImagePreview(String photoFileID, String test, {int  quality = 10}) async {
    print("downloading file $photoFileID for $test");

    // Storage storage = Storage(client!);
    var byteImage = await storage.getFilePreview(
      bucketId: bucketID,
      fileId: photoFileID,
      quality: quality,
      //output:
    );

    return byteImage;

    //return byteImage;
  }



 static Future<dynamic> downloadImage(String photoFileID) async {
   //print("downloading file $photoFileID for $test");

   // Storage storage = Storage(client!);
   var result = await storage.getFileDownload(
     bucketId: bucketID,
     fileId: photoFileID,
     //output:
   );

   print(result);
   return result;

   //return byteImage;
 }



 static Future<Uint8List> getFileView(String photoFileID) async {
   //print("downloading file $photoFileID for $test");

   // Storage storage = Storage(client!);
   var result = await storage.getFileView(
     bucketId: bucketID,
     fileId: photoFileID,
     //output:
   );

   print(result);
   return result;

   //return byteImage;
 }











 static Future<dynamic> createGrave(CustomDocument doc, String userid) async {
    var photosRes = await Future.wait(doc.photos.map((photo) async => sentImage(photo)));

    if (photosRes[0] is Photo) {
      var updatedPhotos = photosRes.map((item) => item as Photo).toList();
      doc.photos = updatedPhotos;
      doc.status = 1;
      doc.createUserId = userid;

      var res;

      try {
        res = await databases.createDocument(
            collectionId: CustomDocumentsTableID,
            documentId: 'unique()',
            data: doc.toJson(),
            databaseId: DataBaseID);
        HiveService.removeGrave(doc.customDocumentId!);
      } catch (error) {
        res = error;
      }

      return res;
    } else if (photosRes[0] is AppwriteException) {
      return photosRes[0];
    }
  }




 static Future<dynamic> fetchRevisions({List<String>? listQueries}) async {
   var res;
   var resDoc;


   var defaultQueries = [
     Query.limit(100),
   ];

   try {

     if(listQueries == null){

       resDoc = await databases.listDocuments(
           collectionId: RevisionsTableID, databaseId:DataBaseID,
           queries:  defaultQueries

       );

     }

     else{
       listQueries.addAll(defaultQueries);
       resDoc = await databases.listDocuments(
           collectionId: RevisionsTableID, databaseId:DataBaseID,
           queries:  listQueries
       );

     }




     List<Revision> items = [];

     resDoc.documents.forEach((element) {
       Revision? doc;
       if (element is model.Document) {
         doc = Revision.fromJson(element.data);
         doc.revisionId = element.$id;
       }
       items.add(doc!);
     });
     res = items;
   } catch (error) {
     res = error;
   }

   return res;
 }








}















