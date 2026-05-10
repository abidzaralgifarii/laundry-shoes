import 'package:get/get.dart';

import '../modules/Dashboard/bindings/dashboard_binding.dart';
import '../modules/Dashboard/views/dashboard_view.dart';
import '../modules/data_pelanggan/bindings/data_pelanggan_binding.dart';
import '../modules/data_pelanggan/views/data_pelanggan_view.dart';
import '../modules/form_pelanggan/bindings/form_pelanggan_binding.dart';
import '../modules/form_pelanggan/views/form_pelanggan_view.dart';
import '../modules/form_stok_bahan/bindings/form_stok_bahan_binding.dart';
import '../modules/form_stok_bahan/views/form_stok_bahan_view.dart';
import '../modules/orderDetail/bindings/order_detail_binding.dart';
import '../modules/orderDetail/views/order_detail_view.dart';
import '../modules/pesanan/bindings/pesanan_binding.dart';
import '../modules/pesanan/views/pesanan_view.dart';
import '../modules/riwayat_pelanggan/bindings/riwayat_pelanggan_binding.dart';
import '../modules/riwayat_pelanggan/views/riwayat_pelanggan_view.dart';
import '../modules/stok_bahan/bindings/stok_bahan_binding.dart';
import '../modules/stok_bahan/views/stok_bahan_view.dart';
import '../modules/tambahPromo/bindings/tambah_promo_binding.dart';
import '../modules/tambahPromo/views/tambah_promo_view.dart';
import '../modules/tambah_cust/bindings/tambah_cust_binding.dart';
import '../modules/tambah_cust/views/tambah_cust_view.dart';
import '../modules/tambah_pesanan/views/tambah_pesanan_view.dart';
import '../modules/treatment/bindings/treatment_binding.dart';
import '../modules/treatment/views/treatment_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.DASHBOARD;

  static final routes = [
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.PESANAN,
      page: () => const PesananView(),
      binding: PesananBinding(),
    ),
    GetPage(
      name: Routes.TAMBAH_PESANAN,
      page: () => const TambahPesananView(),
      binding: PesananBinding(),
    ),
    GetPage(
      name: _Paths.TAMBAH_CUST,
      page: () => const TambahCustomerView(),
      binding: TambahCustBinding(),
    ),
    GetPage(
      name: _Paths.TREATMENT,
      page: () => const TreatmentView(),
      binding: TreatmentBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_DETAIL,
      page: () => const OrderDetailView(),
      binding: OrderDetailBinding(),
    ),
    GetPage(
      name: _Paths.TAMBAH_PROMO,
      page: () => const TambahPromoView(),
      binding: TambahPromoBinding(),
    ),
    GetPage(
      name: _Paths.DATA_PELANGGAN,
      page: () => const DataPelangganView(),
      binding: DataPelangganBinding(),
    ),
    GetPage(
      name: _Paths.FORM_PELANGGAN,
      page: () => const FormPelangganView(),
      binding: FormPelangganBinding(),
    ),
    GetPage(
      name: _Paths.RIWAYAT_PELANGGAN,
      page: () => const RiwayatPelangganView(),
      binding: RiwayatPelangganBinding(),
    ),
    GetPage(
      name: _Paths.STOK_BAHAN,
      page: () => const StokBahanView(),
      binding: StokBahanBinding(),
    ),
    GetPage(
      name: _Paths.FORM_STOK_BAHAN,
      page: () => const FormStokBahanView(),
      binding: FormStokBahanBinding(),
    ),
  ];
}
