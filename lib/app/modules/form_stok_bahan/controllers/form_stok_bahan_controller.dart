import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormStokBahanController extends GetxController {

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  /// ================= CONTROLLER =================
  final namaC = TextEditingController();

  final stockC = TextEditingController();

  final unitC = TextEditingController();

  /// 🔥 BARU
  final hargaC = TextEditingController();

  /// ================= EDIT =================
  var isEdit = false.obs;

  String? bahanId;

  @override
  void onInit() {
    super.onInit();

    final data = Get.arguments;

    if (data != null) {

      isEdit.value = true;

      bahanId = data['id'];

      namaC.text =
          data['name'] ?? '';

      stockC.text =
          (data['stock'] ?? '').toString();

      unitC.text =
          data['unit'] ?? '';
    }
  }

  /// ================= SIMPAN =================
  Future<void> simpanBahan() async {

    if (namaC.text.trim().isEmpty) {

      Get.snackbar(
        'Validasi',
        'Nama bahan wajib diisi',
      );

      return;
    }

    if (stockC.text.trim().isEmpty) {

      Get.snackbar(
        'Validasi',
        'Stok wajib diisi',
      );

      return;
    }

    if (unitC.text.trim().isEmpty) {

      Get.snackbar(
        'Validasi',
        'Satuan wajib diisi',
      );

      return;
    }

    /// 🔥 VALIDASI HARGA
    if (!isEdit.value &&
        hargaC.text.trim().isEmpty) {

      Get.snackbar(
        'Validasi',
        'Harga beli wajib diisi',
      );

      return;
    }

    final stock =
        int.tryParse(
      stockC.text.trim(),
    );

    if (stock == null || stock < 0) {

      Get.snackbar(
        'Validasi',
        'Stok tidak valid',
      );

      return;
    }

    final data = {

      'name':
          namaC.text.trim(),

      'stock':
          stock,

      'unit':
          unitC.text.trim(),
    };

    try {

      /// ================= EDIT =================
      if (isEdit.value) {

        await _firestore
            .collection('materials')
            .doc(bahanId)
            .update(data);

        Get.back();

        Get.snackbar(
          'Sukses',
          'Bahan berhasil diupdate',
        );

      }

      /// ================= TAMBAH =================
      else {

        final harga =
            int.tryParse(
          hargaC.text.trim(),
        );

        if (harga == null ||
            harga <= 0) {

          Get.snackbar(
            'Validasi',
            'Harga tidak valid',
          );

          return;
        }

        /// ================= SIMPAN MATERIAL =================
        final materialDoc =
            await _firestore
                .collection('materials')
                .add(data);

        /// ================= SIMPAN PENGELUARAN =================
        await _firestore
            .collection('material_purchases')
            .add({

          'material_name':
              namaC.text.trim(),

          'qty':
              stock,

          'unit':
              unitC.text.trim(),

          'price':
              harga,

          'created_at':
              Timestamp.now(),

          'material_id':
              materialDoc.id,
        });

        Get.back();

        Get.snackbar(
          'Sukses',
          'Bahan berhasil ditambahkan',
        );
      }

    } catch (e) {

      Get.snackbar(
        'Error',
        e.toString(),
      );
    }
  }

  @override
  void onClose() {

    namaC.dispose();

    stockC.dispose();

    unitC.dispose();

    hargaC.dispose();

    super.onClose();
  }
}