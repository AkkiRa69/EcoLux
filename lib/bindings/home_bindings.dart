import 'package:get/get.dart';
import 'package:homework_api_simple_state_getx/controllers/product_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ProductController(),
    );
  }
}
