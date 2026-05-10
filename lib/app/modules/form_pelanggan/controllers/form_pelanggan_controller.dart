import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormPelangganController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ================= CONTROLLER =================
  final namaC = TextEditingController();
  final phoneC = TextEditingController();

  /// ================= EDIT MODE =================
  var isEdit = false.obs;

  String? pelangganId;

  /// ================= INIT =================
  @override
  void onInit() {
    super.onInit();

    final data = Get.arguments;

    /// 🔥 JIKA EDIT
    if (data != null) {
      isEdit.value = true;

      pelangganId = data['id'];

      namaC.text = data['name'] ?? '';
      phoneC.text = data['phone'] ?? '';
    }
  }

  /// ================= SIMPAN =================
  Future<void> simpanPelanggan() async {

    /// VALIDASI
    if (namaC.text.trim().isEmpty) {
      Get.snackbar(
        'Validasi',
        'Nama pelanggan wajib diisi',
      );
      return;
    }

    if (phoneC.text.trim().isEmpty) {
      Get.snackbar(
        'Validasi',
        'Nomor HP wajib diisi',
      );
      return;
    }

    try {

      /// 🔥 DATA
      final data = {
        'name': namaC.text.trim(),
        'phone': phoneC.text.trim(),
      };

      /// ================= EDIT =================
      if (isEdit.value) {

        await _firestore
            .collection('customers')
            .doc(pelangganId)
            .update(data);

        Get.back();

        Get.snackbar(
          'Sukses',
          'Pelanggan berhasil diupdate',
        );

      } else {

        /// ================= TAMBAH =================
        await _firestore
            .collection('customers')
            .add(data);

        Get.back();

        Get.snackbar(
          'Sukses',
          'Pelanggan berhasil ditambahkan',
        );
      }

    } catch (e) {

      Get.snackbar(
        'Error',
        e.toString(),
      );
    }
  }

  /// ================= DISPOSE =================
  @override
  void onClose() {
    namaC.dispose();
    phoneC.dispose();

    super.onClose();
  }
}