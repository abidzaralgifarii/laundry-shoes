import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TambahPromoController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final nameC = TextEditingController();
  final valueC = TextEditingController();

  var type = 'percent'.obs;
  var isLoading = false.obs;

  Future<void> simpanPromo() async {
    if (nameC.text.trim().isEmpty) {
      Get.snackbar('Validasi', 'Nama promo wajib diisi');
      return;
    }

    final value = int.tryParse(valueC.text.trim());

    if (value == null || value <= 0) {
      Get.snackbar('Validasi', 'Nilai harus angka > 0');
      return;
    }

    try {
      isLoading.value = true;

      final data = {
        'name': nameC.text.trim(),
        'type': type.value,
        'value': value,
      };

      await _firestore.collection('promos').add(data);

      Get.back(result: data);

      Get.snackbar('Sukses', 'Promo berhasil ditambahkan');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameC.dispose();
    valueC.dispose();
    super.onClose();
  }
}