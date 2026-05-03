import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var totalOrders = 0.obs;
  var totalIncomeToday = 0.obs;
  var totalIncomeMonth = 0.obs;

  var diterima = 0.obs;
  var diproses = 0.obs;
  var selesai = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      final ordersSnapshot = await _firestore.collection('orders').get();

      int total = ordersSnapshot.docs.length;
      int incomeToday = 0;
      int incomeMonth = 0;

      int countDiterima = 0;
      int countDiproses = 0;
      int countSelesai = 0;

      final now = DateTime.now();

      for (var doc in ordersSnapshot.docs) {
        final data = doc.data();

        final price = data['total_price'] ?? 0;
        final status = data['status'] ?? '';
        final createdAt = (data['created_at'] as Timestamp).toDate();

        // STATUS
        if (status == 'Diterima') countDiterima++;
        if (status == 'Diproses') countDiproses++;
        if (status == 'Selesai') countSelesai++;

        // HARI INI
        if (createdAt.day == now.day &&
            createdAt.month == now.month &&
            createdAt.year == now.year) {
          incomeToday += (price as int);
        }

        // BULAN INI
        if (createdAt.month == now.month &&
            createdAt.year == now.year) {
          incomeMonth += (price as int);
        }
      }

      totalOrders.value = total;
      totalIncomeToday.value = incomeToday;
      totalIncomeMonth.value = incomeMonth;

      diterima.value = countDiterima;
      diproses.value = countDiproses;
      selesai.value = countSelesai;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}