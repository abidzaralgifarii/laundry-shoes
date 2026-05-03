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
}
