import 'package:camera_app/apptheme.dart';
import 'package:camera_app/controllers/addpage_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/customdocument_model.dart';
import '../addperson.dart';



class AddPagePersonListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final addPageController = Get.find<AddPageController>();

    return Obx(() => ListView.builder(
      padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        //  physics: BouncingScrollPhysics(),
        itemCount: addPageController.personsList.length,
        itemExtent: 60,
        cacheExtent: 10,
        itemBuilder: (context, index) {
          return Container(
            margin: new EdgeInsets.only(top:4, bottom: 4),
            child: InkWell(
                onTap: () async {
                 var result =  await Get.to(AddPerson(), arguments: addPageController.personsList[index]);
                 if(result !=null){
                   addPageController.personsList[index] = result;
                   addPageController.personsList.refresh();

                 }
                },
                child: Obx(() => Dismissible(
                  background: Container(),
                  secondaryBackground: Container(

                    color:Colors.white,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right:20.0),
                        child: Icon(

                        Icons.cancel_sharp,
                        color: AppTheme.buttonColor1,
                          size: 30,

                  ),
                      ),
                    ),),
                  direction: addPageController.editControlsVisible.value == true
                      ? DismissDirection.endToStart
                      : DismissDirection.none,
                  key: ValueKey<Person>(addPageController.personsList[index]),
                  onDismissed: (DismissDirection direction) {
                    //  addPageController.personsList.removeAt(index);
                   // addPageController.personsTrash.add(addPageController.personsList[index]);
                    addPageController.personsList.removeAt(index);
                  },
                  child: Container(

                    height: 80,

                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 0.5,
                            blurRadius: 2,
                            offset: Offset(1.5, 1.5),  // changes position of shadow
                          ),
                        ],
                        color: AppTheme.backgroundColor1,
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                      ),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            SizedBox(width: 10,),
                            Icon(
                              Icons.person_outline_sharp,
                              color: AppTheme.textColorMediumBolded,

                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Text(
                                addPageController.personsList[index].firstName +
                                    ' ' +
                                    addPageController.personsList[index].lastName +
                                    ' ' +
                                    addPageController.personsList[index].birthYear +
                                    ' ',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 18,
                                    color: AppTheme.textColorHardBolded,
                                 /* fontFamily: GoogleFonts.inter(
                                      height: 1.2,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 16

                                  ).fontFamily*/

                                ),
                              ),
                            )
                          ],
                        )),
                  ),
                ))),
          );
        }));
  }
}
