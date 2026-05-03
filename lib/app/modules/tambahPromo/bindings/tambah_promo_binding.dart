import 'package:get/get.dart';
import '../controllers/tambah_promo_controller.dart';

class TambahPromoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TambahPromoController>(
      () => TambahPromoController(),
    );
  }
}