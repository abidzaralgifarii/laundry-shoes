import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StokBahanController extends GetxController {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  /// ================= GET BAHAN =================
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

  /// ================= HAPUS =================
  Future<void> hapusBahan(String id) async {
    try {
      await _firestore
          .collection('materials')
          .doc(id)
          .delete();

      Get.snackbar(
        'Sukses',
        'Bahan berhasil dihapus',
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
      );
    }
  }

  /// ================= TAMBAH STOK =================
  Future<void> tambahStok({
    required String id,
    required String nama,
    required int stockSekarang,
    required String unit,
  }) async {
    final qtyC = TextEditingController();
    final hargaC = TextEditingController();

    await Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tambah Stok',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              nama,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// ================= QTY =================
            TextField(
              controller: qtyC,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Qty Tambah',
                suffixText: unit,
                prefixIcon: const Icon(Icons.add_box),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 14),

            /// ================= HARGA =================
            TextField(
              controller: hargaC,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Harga Beli',
                prefixIcon: const Icon(Icons.payments),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),

        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),

        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('Batal'),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () async {
                    final qty =
                        int.tryParse(qtyC.text.trim());

                    final harga =
                        int.tryParse(hargaC.text.trim());

                    if (qty == null || qty <= 0) {
                      Get.snackbar(
                        'Validasi',
                        'Qty tidak valid',
                      );
                      return;
                    }

                    if (harga == null || harga <= 0) {
                      Get.snackbar(
                        'Validasi',
                        'Harga tidak valid',
                      );
                      return;
                    }

                    try {
                      await _firestore
                          .collection('materials')
                          .doc(id)
                          .update({
                        'stock': stockSekarang + qty,
                      });

                      await _firestore
                          .collection('material_purchases')
                          .add({
                        'material_name': nama,
                        'qty': qty,
                        'unit': unit,
                        'price': harga,
                        'created_at': Timestamp.now(),
                      });

                      qtyC.dispose();
                      hargaC.dispose();

                      Get.back();

                      Get.snackbar(
                        'Sukses',
                        'Stok berhasil ditambahkan',
                      );
                    } catch (e) {
                      Get.snackbar(
                        'Error',
                        e.toString(),
                      );
                    }
                  },
                  child: const Text(
                    'Simpan',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}