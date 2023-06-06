import 'package:appwrite/models.dart' as model;
import 'package:appwrite/appwrite.dart' hide Locale;
import 'package:appwrite/models.dart';
import 'package:camera_app/appsettings.dart';
import 'package:camera_app/controllers/offlinegraves_controller.dart';
import 'package:camera_app/model/customdocument_model.dart';
import 'package:camera_app/services/HiveService.dart';
import 'package:camera_app/views/addpage/addpage.dart';
import 'package:camera_app/views/homepage/gravetile.dart';
import 'package:camera_app/views/homepage/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../services/AppWriteService.dart';
import '../../translation_keys.dart';
import '../apptheme.dart';
import 'loginpage.dart';
import 'myobjects.dart';


class OfflineGravesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final OfflineGravesController offlineGravesController = Get.put(OfflineGravesController());

   // print("OFFLINE LIST")


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

                                  offlineGravesController.typeId.value = listTypes[index].typeID;
                                  Navigator.pop(context);
                                  Get.to(AddPage(), arguments:offlineGravesController.typeId.value);
                                },
                              );

                          }
                      )
                  ),
                )


            );






            AlertDialog(
          //  backgroundColor: AppTheme.backgroundColor1,
              title: Text(Translation.choose_type.tr),
              actions: [
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Get.to(AddPage(), arguments:offlineGravesController.typeId.value);
                  },
                  child: Text(Translation.save.tr),
                ),
              ],
              content: Container(
               // color: Theme.of(context).colorScheme.primary,
                height: 100,
                padding: EdgeInsets.only(top:10),
                child: Column(
                  children: [
                    Obx(() => SegmentedButton<int>(
                      segments: <ButtonSegment<int>>[
                        ButtonSegment<int>(


                            value: 0,
                            label: Text(
                                Translation.grave.tr),
                            icon: FaIcon(
                              FontAwesomeIcons.cross,
                            )),
                        ButtonSegment<int>(
                            value: 1,
                            label: Text(
                                Translation.chapel.tr),
                            icon: Icon(
                                Icons.church_outlined)),
                      ],
                      selected: <int>{
                        offlineGravesController.typeId.value
                      },
                      onSelectionChanged: (newSelection) {
                        offlineGravesController.typeId.value =
                            newSelection.first;
                      },
                    )),
                  ],
                ),
              )
          );







        },
      );

    }

    Widget listGraves() {
      if (offlineGravesController.isLoading.value)
        return Center(child: CircularProgressIndicator());
      else
        return RefreshIndicator(
          onRefresh: () => offlineGravesController.fetchOfflineGraves(),
          child: ListView.builder(
              //controller: offlineGravesController.scrollController,

              // shrinkWrap: true,
              cacheExtent: 9999,
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemCount: offlineGravesController.graveOfflineList.length,
              itemExtent: 120,
              itemBuilder: (context, index) {
                print("OFFLINE list item build");

                return Padding(
                  padding: EdgeInsets.all(5),
                  child: Dismissible(
                      direction: offlineGravesController.graveOfflineList[index].status == 0
                          ? DismissDirection.endToStart
                          : DismissDirection.none,
                      key: ObjectKey(offlineGravesController.graveOfflineList[index]),
                      confirmDismiss: (DismissDirection direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: AppTheme.backgroundColor1,
                              title: Text("Usuwanie"),
                              content: Text("Czy na pewno chcesz usunąć"),
                              actions: <Widget>[
                                FilledButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: Text("Tak")),
                                OutlinedButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text("Nie"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onDismissed: (direction) {
                        HiveService.removeGrave(offlineGravesController
                            .graveOfflineList[index].customDocumentId!);
                        offlineGravesController.graveOfflineList.removeAt(index);
                      },
                      child: InkWell(
                        child: GraveTile(offlineGravesController.graveOfflineList[index]),
                        onTap: () async {

                          print("STATUS");
                          print(offlineGravesController.graveOfflineList[index].status);
                            await Get.to(AddPage(), arguments: offlineGravesController.graveOfflineList[index]);

                        },
                      )),
                );
              }),
        );
    }


    showSendGravesDialog() async {

      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) {
            return WillPopScope(
              onWillPop: () async => false,
              child: Dialog(
                // The background color
              //  backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // The loading indicator
                      LinearProgressIndicator(),
                      SizedBox(
                        height: 15,
                      ),
                      // Some text
                      Text(
                        Translation.sending_please_wait.tr,
                        style: TextStyle(fontSize: 20, color: AppTheme.inputFontColor),
                      )
                    ],
                  ),
                ),
              ),
            );
          });

      var b = List<CustomDocument>.from(offlineGravesController.graveOfflineList);
      var res = await AppWriteService.postAllGraves(b);
     // await Future.delayed(const Duration(seconds: 6));
      if (res is AppwriteException) {
        Navigator.of(context).pop();
        //Get.defaultDialog(content: Text(res.message!));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(duration: Duration(seconds: 2), content: Text(res.message!,
          ),
          ),
        );
      } else {
        Get.snackbar("", Translation.sent.tr, colorText: AppTheme.appBarIconFontColor);
        Navigator.of(context).pop();
        await offlineGravesController.fetchOfflineGraves();
      }


    }



    return WillPopScope(

      onWillPop: () async {
        Get.offAll(HomePage()
          ,transition: Transition.native
          ,duration: const Duration(milliseconds: 300),
        );
        return true;
      },


      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor2,
        appBar: AppBar(

            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {

                Get.offAll(HomePage()
                ,transition: Transition.native
                ,duration: const Duration(milliseconds: 300),
                );


              }
            ),
           // iconTheme: IconThemeData(color: AppTheme.textColorHardBolded),
          //  backgroundColor:  AppTheme.backgroundColor1,
            centerTitle: true,
            title: Text(Translation.records_to_send.tr)
        ),
       // backgroundColor: Color(0xfffff6f7),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            FloatingActionButton(

              heroTag: "btnAddGrave",
              onPressed: () async {

               // Get.to(OfflineGravesPage());

                 await showTypeDialog();
              },
              child: Icon(Icons.add, color:AppTheme.onButtonColor1),
               backgroundColor:  AppTheme.buttonColor1
            ),

            SizedBox(
              width: 15,
            ),

            Obx(() =>   Visibility(
              visible: AppSettings.loginInfo.userName !='' && offlineGravesController.graveOfflineList.length > 0 ? true : false,
              child:

              Badge(
                offset: Offset(4.0, -6.0),
                padding: EdgeInsets.only(left:8, right: 8),
               // padding: EdgeInsets.all(8),
                backgroundColor: AppTheme.badgeBackground,
               // child: Icon(Icons.sync),
                largeSize: 24,
                label: Text(
                  offlineGravesController.graveOfflineList
                      .length
                      .toString(),
                  style: TextStyle(color: AppTheme.badgeFontColor, fontSize: 10, fontWeight: FontWeight.w600),

                ),
                alignment: AlignmentDirectional.topEnd,
                isLabelVisible: true,

                child: FloatingActionButton(

                  heroTag: "btnSendGraves",
                  onPressed: () async {

                    if (offlineGravesController.graveOfflineList.length == 0) {

                      //Get.defaultDialog(title: Translation.alert.tr, content: Text(Translation.no_complete_records.tr));


                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(duration: Duration(seconds: 2), content: Text(Translation.no_complete_records.tr,
                        ),
                        ),
                      );


                    } else {
                      var res2 = await AppWriteService.getAccountInfo();
                      if (res2 is AppwriteException) {
                        if (res2.code == 401) {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                    Translation.you_have_to_login.tr),
                                content: Text(
                                    Translation.do_you_want_login.tr),
                                actions: <Widget>[
                                  OutlinedButton(
                                      onPressed: () async {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          // the new route
                                          MaterialPageRoute(
                                            builder: (BuildContext
                                            context) =>
                                                LoginPage(),
                                          ),
                                              (Route route) => false,
                                        );
                                      },
                                      child: Text(Translation.yes.tr)),
                                  FilledButton(
                                    onPressed: () =>
                                        Navigator.of(context)
                                            .pop(false),
                                    child: Text(Translation.no.tr),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                        //  Get.defaultDialog(content: Text(res2.message!));

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(duration: Duration(seconds: 2), content: Text(res2.message!,
                            ),
                            ),
                          );

                        }
                      } else if (res2 is User) {
                        await showSendGravesDialog();
                      }
                    }
                  },

                    child: Icon(Icons.sync, color:AppTheme.onButtonColor2),
                  backgroundColor:  AppTheme.buttonColor2

                ),
              )),
            ),
          ],
        ),
        body:Obx(() =>listGraves())

        //   listColumnView()
      ),
    );
  }
}
