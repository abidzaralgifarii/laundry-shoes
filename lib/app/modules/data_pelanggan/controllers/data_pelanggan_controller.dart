import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DataPelangganController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ================= STREAM DATA =================
  Stream<List<Map<String, dynamic>>> getPelanggan() {
    return _firestore
        .collection('customers')
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        /// 🔥 inject id document
        data['id'] = doc.id;

        return data;
      }).toList();
    });
  }

  /// ================= DELETE =================
  Future<void> hapusPelanggan(String id) async {
    try {
      await _firestore
          .collection('customers')
          .doc(id)
          .delete();

      Get.snackbar(
        'Sukses',
        'Pelanggan berhasil dihapus',
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
      );
    }
  }
}