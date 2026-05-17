import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class LaporanController extends GetxController {

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  /// ================= SUMMARY =================
  var pendapatan = 0.obs;

  var pengeluaran = 0.obs;

  var laba = 0.obs;

  var totalPesanan = 0.obs;

  /// ================= LIST =================
  var orders = <Map<String, dynamic>>[].obs;

  var purchases = <Map<String, dynamic>>[].obs;

  /// ================= FILTER BULAN =================
  var selectedMonth =
    DateTime(
      DateTime.now().year,
      DateTime.now().month,
      1,
    ).obs;

  /// ================= GET LAPORAN =================
  Future<void> getLaporan() async {

    try {

      /// ================= FILTER BULAN =================
      final bulan =
          selectedMonth.value;

      final awalBulan =
          DateTime(
            bulan.year,
            bulan.month,
            1,
          );

      final akhirBulan =
          DateTime(
            bulan.year,
            bulan.month + 1,
            1,
          );

      /// ================= ORDERS =================
      final orderSnapshot =
          await _firestore
              .collection('orders')
              .where(
                'status',
                isEqualTo: 'Selesai',
              )
              .where(
                'created_at',
                isGreaterThanOrEqualTo:
                    Timestamp.fromDate(
                      awalBulan,
                    ),
              )
              .where(
                'created_at',
                isLessThan:
                    Timestamp.fromDate(
                      akhirBulan,
                    ),
              )
              .get();

      int totalPendapatan = 0;

      List<Map<String, dynamic>>
          tempOrders = [];

      for (var doc in orderSnapshot.docs) {

        final data =
            Map<String, dynamic>.from(
              doc.data(),
            );

        data['id'] = doc.id;

        final total =
            data['final_price']
            ??
            data['total_price']
            ??
            0;

        totalPendapatan +=
            (total as num).toInt();

        tempOrders.add(data);
      }

      /// ================= PURCHASE =================
      final purchaseSnapshot =
          await _firestore
              .collection(
                'material_purchases',
              )
              .where(
                'created_at',
                isGreaterThanOrEqualTo:
                    Timestamp.fromDate(
                      awalBulan,
                    ),
              )
              .where(
                'created_at',
                isLessThan:
                    Timestamp.fromDate(
                      akhirBulan,
                    ),
              )
              .get();

      int totalPengeluaran = 0;

      List<Map<String, dynamic>>
          tempPurchases = [];

      for (var doc in purchaseSnapshot.docs) {

        final data =
            Map<String, dynamic>.from(
              doc.data(),
            );

        data['id'] = doc.id;

        final price =
            data['price'] ?? 0;

        totalPengeluaran +=
            (price as num).toInt();

        tempPurchases.add(data);
      }

      /// ================= SET VALUE =================
      pendapatan.value =
          totalPendapatan;

      pengeluaran.value =
          totalPengeluaran;

      laba.value =
          totalPendapatan -
          totalPengeluaran;

      totalPesanan.value =
          tempOrders.length;

      orders.value =
          tempOrders;

      purchases.value =
          tempPurchases;

    } catch (e) {

      Get.snackbar(
        'Error',
        e.toString(),
      );
    }
  }

  /// ================= GANTI BULAN =================
  void changeMonth(DateTime date) {

    selectedMonth.value = date;

    getLaporan();
  }

  /// ================= REFRESH =================
  Future<void> refreshData() async {
    await getLaporan();
  }

  /// ================= INIT =================
  @override
  void onInit() {
    super.onInit();

    getLaporan();
  }
}