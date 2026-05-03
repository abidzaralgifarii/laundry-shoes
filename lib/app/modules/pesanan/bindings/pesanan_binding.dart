import 'package:get/get.dart';
import 'package:laundry_sepatu/app/modules/pesanan/controllers/pesanan_controller.dart';
import 'package:laundry_sepatu/app/modules/tambah_pesanan/controllers/tambah_pesanan_controller.dart';

class PesananBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PesananController>(() => PesananController());
    Get.lazyPut<TambahPesananController>(() => TambahPesananController());
  }
}