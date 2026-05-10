import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TreatmentController extends GetxController {
  final namaC = TextEditingController();
  final hargaC = TextEditingController();
  final durasiC = TextEditingController();

  /// ================= MATERIAL =================
  var materialList = <Map<String, dynamic>>[].obs;

  var selectedMaterial = Rxn<Map<String, dynamic>>();

  final qtyMaterialC = TextEditingController();

  var materials = <Map<String, dynamic>>[].obs;

  /// ================= SIMPAN =================
  Future<void> simpanTreatment() async {
    if (namaC.text.isEmpty ||
        hargaC.text.isEmpty ||
        durasiC.text.isEmpty) {

      Get.snackbar(
        'Validasi',
        'Semua field wajib diisi',
      );

      return;
    }

    try {

      final doc =
          await FirebaseFirestore.instance
              .collection('treatments')
              .add({

        'name': namaC.text,
        'price': int.parse(hargaC.text),
        'duration': durasiC.text,

        'created_at': Timestamp.now(),

        /// 🔥 MATERIAL
        'materials': materials.toList(),
      });

      /// 🔥 KEMBALIKAN DATA
      Get.back(result: {
        'id': doc.id,
        'name': namaC.text,
        'price': int.parse(hargaC.text),
        'duration': durasiC.text,
      });

      Get.snackbar(
        'Sukses',
        'Treatment berhasil ditambahkan',
      );

    } catch (e) {

      Get.snackbar(
        'Error',
        e.toString(),
      );
    }
  }

  /// ================= GET MATERIAL =================
  Future<void> getMaterials() async {

    final snapshot =
        await FirebaseFirestore.instance
            .collection('materials')
            .get();

    materialList.value =
        snapshot.docs.map((doc) {

      final data = doc.data();

      data['id'] = doc.id;

      return data;

    }).toList();
  }

  /// ================= TAMBAH MATERIAL =================
  void tambahMaterial() {

    if (selectedMaterial.value == null) {

      Get.snackbar(
        'Validasi',
        'Pilih bahan dulu',
      );

      return;
    }

    final qty =
        int.tryParse(qtyMaterialC.text.trim());

    if (qty == null || qty <= 0) {

      Get.snackbar(
        'Validasi',
        'Qty bahan tidak valid',
      );

      return;
    }

    materials.add({

      'name': selectedMaterial.value?['name'],
      'qty': qty,
      'unit': selectedMaterial.value?['unit'],
    });

    qtyMaterialC.clear();

    selectedMaterial.value = null;
  }

  /// ================= HAPUS MATERIAL =================
  void hapusMaterial(int index) {
    materials.removeAt(index);
  }

  /// ================= INIT =================
  @override
  void onInit() {
    super.onInit();

    getMaterials();
  }

  /// ================= DISPOSE =================
  @override
  void onClose() {

    namaC.dispose();
    hargaC.dispose();
    durasiC.dispose();
    qtyMaterialC.dispose();

    super.onClose();
  }
}   