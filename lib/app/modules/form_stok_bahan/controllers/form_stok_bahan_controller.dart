import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormStokBahanController extends GetxController {

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  /// ================= CONTROLLER =================
  final namaC =
      TextEditingController();

  final stockC =
      TextEditingController();

  final unitC =
      TextEditingController();

  final hargaC =
      TextEditingController();

  /// ================= STATE =================
  var isEdit = false.obs;

  var isLoading = false.obs;

  String? bahanId;

  @override
  void onInit() {

    super.onInit();

    final data =
        Get.arguments;

    if (data != null) {

      isEdit.value = true;

      bahanId = data['id'];

      namaC.text =
          data['name'] ?? '';

      stockC.text =
          (data['stock'] ?? '')
              .toString();

      unitC.text =
          data['unit'] ?? '';
    }
  }

  /// ================= SIMPAN =================
  Future<void> simpanBahan() async {

    /// ================= ANTIS SPAM =================
    if (isLoading.value) return;

    isLoading.value = true;

    /// ================= VALIDASI =================
    if (namaC.text.trim().isEmpty) {

      Get.snackbar(
        'Validasi',
        'Nama bahan wajib diisi',
      );

      isLoading.value = false;

      return;
    }

    if (stockC.text.trim().isEmpty) {

      Get.snackbar(
        'Validasi',
        'Stok wajib diisi',
      );

      isLoading.value = false;

      return;
    }

    if (unitC.text.trim().isEmpty) {

      Get.snackbar(
        'Validasi',
        'Satuan wajib diisi',
      );

      isLoading.value = false;

      return;
    }

    /// ================= VALIDASI HARGA =================
    if (!isEdit.value &&
        hargaC.text.trim().isEmpty) {

      Get.snackbar(
        'Validasi',
        'Harga beli wajib diisi',
      );

      isLoading.value = false;

      return;
    }

    final stock =
        int.tryParse(
      stockC.text.trim(),
    );

    if (stock == null ||
        stock < 0) {

      Get.snackbar(
        'Validasi',
        'Stok tidak valid',
      );

      isLoading.value = false;

      return;
    }

    final data = {

      'name':
          namaC.text.trim(),

      'stock':
          stock,

      'unit':
          unitC.text.trim(),

      'created_at':
          Timestamp.now(),
    };

    try {

      /// ================= EDIT =================
      if (isEdit.value) {

        await _firestore
            .collection('materials')
            .doc(bahanId)
            .update(data);

        /// ================= PINDAH HALAMAN =================
        Get.offNamed(
          '/stok-bahan',
        );

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

          isLoading.value = false;

          return;
        }

        /// ================= SIMPAN MATERIAL =================
        final materialDoc =
            await _firestore
                .collection(
                    'materials')
                .add(data);

        /// ================= SIMPAN PEMBELIAN =================
        await _firestore
            .collection(
                'material_purchases')
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

        /// ================= PINDAH HALAMAN =================
        Get.offNamed(
          '/stok-bahan',
        );

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

    } finally {

      isLoading.value = false;
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