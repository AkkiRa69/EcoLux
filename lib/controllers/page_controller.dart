import 'package:get/get.dart';

class PageNavigatorController extends GetxController {
  var selectedIndex = 0.obs;
  RxBool isVisible = true.obs;

  void changeTabIndex(int index) {
    selectedIndex.value = index;
    if (index == 2) {
      isVisible.value = false;
    } else {
      isVisible.value = true;
    }
  }
}
