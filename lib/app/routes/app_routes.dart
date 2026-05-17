part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const DASHBOARD = _Paths.DASHBOARD;
  static const PESANAN = _Paths.PESANAN;
  static const TAMBAH_PESANAN = _Paths.TAMBAH_PESANAN;
  static const TAMBAH_CUST = _Paths.TAMBAH_CUST;
  static const TREATMENT = _Paths.TREATMENT;
  static const ORDER_DETAIL = _Paths.ORDER_DETAIL;
  static const TAMBAH_PROMO = _Paths.TAMBAH_PROMO;
  static const DATA_PELANGGAN = _Paths.DATA_PELANGGAN;
  static const FORM_PELANGGAN = _Paths.FORM_PELANGGAN;
  static const RIWAYAT_PELANGGAN = _Paths.RIWAYAT_PELANGGAN;
  static const STOK_BAHAN = _Paths.STOK_BAHAN;
  static const FORM_STOK_BAHAN = _Paths.FORM_STOK_BAHAN;
  static const LAPORAN = _Paths.LAPORAN;
  static const AUTH = _Paths.AUTH;
  static const SPLASHSCREEN = _Paths.SPLASHSCREEN;
  static const SPLASH = _Paths.SPLASH;
}

abstract class _Paths {
  _Paths._();
  static const DASHBOARD = '/dashboard';
  static const PESANAN = '/pesanan';
  static const TAMBAH_PESANAN = '/tambah-pesanan';
  static const TAMBAH_CUST = '/tambah-cust';
  static const TREATMENT = '/treatment';
  static const ORDER_DETAIL = '/order/:id';
  static const TAMBAH_PROMO = '/tambah-promo';
  static const DATA_PELANGGAN = '/data-pelanggan';
  static const FORM_PELANGGAN = '/form-pelanggan';
  static const RIWAYAT_PELANGGAN = '/riwayat-pelanggan';
  static const STOK_BAHAN = '/stok-bahan';
  static const FORM_STOK_BAHAN = '/form-stok-bahan';
  static const LAPORAN = '/laporan';
  static const AUTH = '/auth';
  static const SPLASHSCREEN = '/splashscreen';
  static const SPLASH = '/splash';
}
