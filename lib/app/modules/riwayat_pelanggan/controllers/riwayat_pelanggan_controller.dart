import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class RiwayatPelangganController extends GetxController {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  late String namaPelanggan;

  @override
  void onInit() {
    super.onInit();

    final data = Get.arguments;

    namaPelanggan = data['name'];
  }

  /// ================= GET HISTORY =================
  Stream<List<Map<String, dynamic>>> getRiwayat() {
    return _firestore
        .collection('orders')
        .where(
          'customer_name',
          isEqualTo: namaPelanggan,
        )
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) {

      return snapshot.docs.map((doc) {

        final data = doc.data();

        data['id'] = doc.id;

        return data;

      }).toList();
    });
  }
}