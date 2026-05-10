import 'package:get/get.dart';
import '../controllers/riwayat_pelanggan_controller.dart';

class RiwayatPelangganBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<RiwayatPelangganController>(
      () => RiwayatPelangganController(),
    );
  }
}