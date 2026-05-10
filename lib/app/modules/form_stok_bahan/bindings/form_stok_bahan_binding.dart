import 'package:get/get.dart';
import '../controllers/form_stok_bahan_controller.dart';

class FormStokBahanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FormStokBahanController>(
      () => FormStokBahanController(),
    );
  }
}