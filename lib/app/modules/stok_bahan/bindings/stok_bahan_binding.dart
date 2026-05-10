import 'package:get/get.dart';
import '../controllers/stok_bahan_controller.dart';

class StokBahanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StokBahanController>(
      () => StokBahanController(),
    );
  }
}