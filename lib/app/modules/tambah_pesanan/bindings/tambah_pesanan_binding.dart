import '../controllers/tambah_pesanan_controller.dart';
import 'package:get/get.dart';
class PesananBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TambahPesananController>(() => TambahPesananController());
  }
}