import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TambahCustomerController extends GetxController {
  final namaC = TextEditingController();
  final waC = TextEditingController();

  Future<void> simpanCustomer() async {
    if (namaC.text.isEmpty || waC.text.isEmpty) {
      Get.snackbar('Validasi', 'Nama & WhatsApp wajib diisi');
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('customers')
          .add({
        'name': namaC.text,
        'phone': waC.text,
        'created_at': Timestamp.now(),
      });

      Get.back(result: {
        'id': doc.id,
        'name': namaC.text,
        'phone': waC.text,
      });

      Get.snackbar('Sukses', 'Customer berhasil ditambahkan');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  @override
  void onClose() {
    namaC.dispose();
    waC.dispose();
    super.onClose();
  }
}