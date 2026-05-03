import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TreatmentController extends GetxController {
  final namaC = TextEditingController();
  final hargaC = TextEditingController();
  final durasiC = TextEditingController();

  Future<void> simpanTreatment() async {
    if (namaC.text.isEmpty ||
        hargaC.text.isEmpty ||
        durasiC.text.isEmpty) {
      Get.snackbar('Validasi', 'Semua field wajib diisi');
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('treatments')
          .add({
        'name': namaC.text,
        'price': int.parse(hargaC.text),
        'duration': durasiC.text,
        'created_at': Timestamp.now(),
      });

      /// 🔥 KEMBALIKAN DATA KE HALAMAN SEBELUMNYA
      Get.back(result: {
        'id': doc.id,
        'name': namaC.text,
        'price': int.parse(hargaC.text),
        'duration': durasiC.text,
      });

      Get.snackbar('Sukses', 'Treatment berhasil ditambahkan');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  @override
  void onClose() {
    namaC.dispose();
    hargaC.dispose();
    durasiC.dispose();
    super.onClose();
  }
}