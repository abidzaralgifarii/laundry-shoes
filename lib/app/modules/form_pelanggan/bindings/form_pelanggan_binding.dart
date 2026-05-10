import 'package:get/get.dart';
import '../controllers/form_pelanggan_controller.dart';

class FormPelangganBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<FormPelangganController>(
      () => FormPelangganController(),
    );
  }
}