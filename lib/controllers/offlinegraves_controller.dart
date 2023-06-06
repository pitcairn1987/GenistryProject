import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../model/customdocument_model.dart';
import '../services/HiveService.dart';

class OfflineGravesController extends GetxController {
  var isLoading = true.obs;
  var graveOfflineList = <CustomDocument>[].obs;
  var typeId = 0.obs;
  @override
  void onInit() {
    fetchOfflineGraves();
    super.onInit();
  }


  Future<void> fetchOfflineGraves() async {
    print("FETCHING OFFLINE GRAVES..........");
    List<String>? queries;
    graveOfflineList.clear();

    isLoading(true);

    await HiveService.fetchGraves().then((value) => graveOfflineList.addAll(value));
    
   /* graveOfflineList.forEach((element) {
      print(element.photos[0].photoFileName);
      print(element.photos[1].photoFileName);
    });*/

    isLoading(false);
  }

}