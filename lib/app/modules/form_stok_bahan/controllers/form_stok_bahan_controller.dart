import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormStokBahanController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final namaC = TextEditingController();
  final stockC = TextEditingController();
  final unitC = TextEditingController();

  var isEdit = false.obs;
  String? bahanId;

  @override
  void onInit() {
    super.onInit();

    final data = Get.arguments;

    if (data != null) {
      isEdit.value = true;
      bahanId = data['id'];

      namaC.text = data['name'] ?? '';
      stockC.text = (data['stock'] ?? '').toString();
      unitC.text = data['unit'] ?? '';
    }
  }

  Future<void> simpanBahan() async {
    if (namaC.text.trim().isEmpty) {
      Get.snackbar('Validasi', 'Nama bahan wajib diisi');
      return;
    }

    if (stockC.text.trim().isEmpty) {
      Get.snackbar('Validasi', 'Stok wajib diisi');
      return;
    }

    if (unitC.text.trim().isEmpty) {
      Get.snackbar('Validasi', 'Satuan wajib diisi');
      return;
    }

    final stock = int.tryParse(stockC.text.trim());

    if (stock == null || stock < 0) {
      Get.snackbar('Validasi', 'Stok harus angka valid');
      return;
    }

    final data = {
      'name': namaC.text.trim(),
      'stock': stock,
      'unit': unitC.text.trim(),
    };

    try {
      if (isEdit.value) {
        await _firestore.collection('materials').doc(bahanId).update(data);
            Get.back();
        Get.snackbar('Sukses', 'Bahan berhasil diupdate');
      } else {
        await _firestore.collection('materials').add(data);
         Get.back();
        Get.snackbar('Sukses', 'Bahan berhasil ditambahkan');
      }

    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  @override
  void onClose() {
    namaC.dispose();
    stockC.dispose();
    unitC.dispose();
    super.onClose();
  }
}