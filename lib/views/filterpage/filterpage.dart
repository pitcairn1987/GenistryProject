
import 'package:camera_app/appsettings.dart';
import 'package:camera_app/apptheme.dart';
import 'package:camera_app/views/myobjects.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/filterpage_controller.dart';
import '../../translation_keys.dart';
import '../widgets/customformfield.dart';

class FilterPage extends StatelessWidget {









  @override
  Widget build(BuildContext context) {

    final FilterPageController filterPageController = Get.put(FilterPageController());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppTheme.backgroundColor1,
      appBar: AppBar(),
      body: Container(
        margin: EdgeInsets.only(left:24,right:24,bottom: 24),
        child: ListView(

          children: [

            SizedBox(
              height: 20,
            ),
            CustomFormField(
              validateMode: AutovalidateMode.disabled,
              fieldDescription: Translation.person.tr,
              enabled: true,
              fieldController: filterPageController.personController,
              maxLength: 10,
              regExp: r"^[A-Za-z0-9.,-/]*$",
              inputFillColor: AppTheme.inputFillColor
            ),
            SizedBox(
              height: 20,
            ),
            CustomFormField(
              validateMode: AutovalidateMode.disabled,
              fieldDescription: Translation.year.tr,
              enabled: true,
              fieldController: filterPageController.yearController,
              maxLength: 10,
              regExp: r"^[A-Za-z0-9.,-/]*$",
              inputFillColor: AppTheme.inputFillColor
            ),
            SizedBox(
              height: 20,
            ),
            CustomFormField(
              validateMode: AutovalidateMode.disabled,
              fieldDescription: Translation.address.tr,
              enabled: true,
              fieldController: filterPageController.addressController,
              maxLength: 10,
              regExp: r"^[A-Za-z0-9.,-/]*$",
              inputFillColor: AppTheme.inputFillColor
            ),


            Align(
              alignment: Alignment.topLeft,
              child: Wrap(
                runSpacing: 0,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Obx(()=> FilterChip(
                      selected:  filterPageController.graveTypeSelected.value,
                      label: Text(listTypes[0].label.tr),
                      onSelected: (bool value) {
                        filterPageController.graveTypeSelected.value = value!;
                        if(filterPageController.typeIDs.contains(0)){
                          filterPageController.typeIDs.removeWhere((element) => element == 0);
                        }
                        else filterPageController.typeIDs.add(0);
                      },
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Obx(()=> FilterChip(
                      selected:  filterPageController.chapelTypeSelected.value,
                      label: Text(listTypes[1].label.tr),
                      onSelected: (bool value) {
                        filterPageController.chapelTypeSelected.value = value!;
                        if(filterPageController.typeIDs.contains(1)){
                          filterPageController.typeIDs.removeWhere((element) => element == 1);
                        }
                        else filterPageController.typeIDs.add(1);
                      },
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Obx(()=> FilterChip(
                      selected:  filterPageController.chapel2TypeSelected.value,
                      label: Text(listTypes[2].label.tr),
                      onSelected: (bool value) {
                        filterPageController.chapel2TypeSelected.value = value!;
                        if(filterPageController.typeIDs.contains(2)){
                          filterPageController.typeIDs.removeWhere((element) => element == 2);
                        }
                        else filterPageController.typeIDs.add(2);
                      },
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Obx(()=> FilterChip(
                      selected:  filterPageController.crossTypeSelected.value,
                      label: Text(listTypes[3].label.tr),
                      onSelected: (bool value) {
                        filterPageController.crossTypeSelected.value = value!;
                        if(filterPageController.typeIDs.contains(3)){
                          filterPageController.typeIDs.removeWhere((element) => element == 3);
                        }
                        else filterPageController.typeIDs.add(3);
                      },
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Obx(()=> FilterChip(
                      selected:  filterPageController.figureTypeSelected.value,
                      label: Text(listTypes[4].label.tr),
                      onSelected: (bool value) {
                        filterPageController.figureTypeSelected.value = value!;
                        if(filterPageController.typeIDs.contains(4)){
                          filterPageController.typeIDs.removeWhere((element) => element == 4);
                        }
                        else filterPageController.typeIDs.add(4);
                      },
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Obx(()=> FilterChip(
                      selected:  filterPageController.choleraCemeteryTypeSelected.value,
                      label: Text(listTypes[5].label.tr),
                      onSelected: (bool value) {
                        filterPageController.choleraCemeteryTypeSelected.value = value!;
                        if(filterPageController.typeIDs.contains(5)){
                          filterPageController.typeIDs.removeWhere((element) => element == 5);
                        }
                        else filterPageController.typeIDs.add(5);
                      },
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Obx(()=> FilterChip(
                      selected:  filterPageController.otherTypeSelected.value,
                      label: Text(listTypes[6].label.tr),
                      onSelected: (bool value) {
                        filterPageController.otherTypeSelected.value = value!;
                        if(filterPageController.typeIDs.contains(6)){
                          filterPageController.typeIDs.removeWhere((element) => element == 6);
                        }
                        else filterPageController.typeIDs.add(6);
                      },
                    )),
                  ),

                ],
              ),
            ),


            Visibility(
              visible: AppSettings.loginInfo.userId =="" ? false: true,
              child: Padding(
                padding: const EdgeInsets.only(left:10, top: 20),
                child: Row(

                  children: [
                    Text(
                        "Tylko moje",
                style: TextStyle(fontSize: 17, color: AppTheme.inputLabelFontColor),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Transform.scale(
                       scale: 1.3,
                       child:
                     Obx(() =>Checkbox(
                       activeColor: AppTheme.buttonColor3,
                       fillColor: MaterialStateProperty.resolveWith<Color>(
                             (Set<MaterialState> states) {
                           if (states.contains(MaterialState.selected)){
                             return Colors.white;
                           }
                           return Colors.white;
                         },
                       ),
                       shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(10)),
                       checkColor: AppTheme.onButtonColor3,
                       value: filterPageController.onlyMine.value,
                       onChanged: (bool? value) {
                         filterPageController.onlyMine.value = !filterPageController.onlyMine.value;

                         print(filterPageController.onlyMine.value);


                       },
                     ))),

                   // Text("Tylko moje"),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30,),




            Column(
              children: [
                FilledButton(
                    onPressed: () async {
                      filterPageController.generateFilters();
                       Get.back(result: filterPageController.listFilters);
                    },
                    child:  Text(Translation.search.tr)
                ),

                SizedBox(
                  height: 10.0,
                ),
                OutlinedButton(
                    onPressed: () {
                      filterPageController.listFilters.clear();
                      Get.back(result: filterPageController.listFilters);
                    },
                    child:  Text(Translation.clear.tr)
                )
              ],
            ),
          ],
        ),
      ),
    );


  }
}


