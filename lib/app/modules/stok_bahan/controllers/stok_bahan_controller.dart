import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class StokBahanController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getBahan() {
    return _firestore
        .collection('materials')
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  Future<void> hapusBahan(String id) async {
    try {
      await _firestore.collection('materials').doc(id).delete();

      Get.snackbar('Sukses', 'Bahan berhasil dihapus');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}