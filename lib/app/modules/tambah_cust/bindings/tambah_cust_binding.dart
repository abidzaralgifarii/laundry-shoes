import 'package:get/get.dart';

import '../controllers/tambah_cust_controller.dart';

class TambahCustBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TambahCustomerController>(
      () => TambahCustomerController(),
    );
  }
}
