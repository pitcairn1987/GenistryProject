import 'package:camera_app/translations.dart';
import 'package:get/get.dart';

class Languages extends Translations {
  @override

  Map<String, Map<String, String>> get keys => {
    'en_US': En().messages,
    'pl_PL': Pl().messages,
    'be_BY': By().messages,
    'ru_RU': By().messages,
  };

}