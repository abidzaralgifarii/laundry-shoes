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

        title: Text(
          'Tambah Stok $nama',
        ),

        content: Column(
          mainAxisSize: MainAxisSize.min,

          children: [

            /// ================= QTY =================
            TextField(
              controller: qtyC,
              keyboardType: TextInputType.number,

              decoration: const InputDecoration(
                labelText: 'Qty Tambah',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            /// ================= HARGA =================
            TextField(
              controller: hargaC,
              keyboardType: TextInputType.number,

              decoration: const InputDecoration(
                labelText: 'Harga Beli',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),

        actions: [

          /// ================= BATAL =================
          TextButton(
            onPressed: () {
              Get.back();
            },

            child: const Text('Batal'),
          ),

          /// ================= SIMPAN =================
          ElevatedButton(
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

                /// ================= UPDATE STOCK =================
                await _firestore
                    .collection('materials')
                    .doc(id)
                    .update({

                  'stock':
                      stockSekarang + qty,
                });

                /// ================= SIMPAN PEMBELIAN =================
                await _firestore
                    .collection('material_purchases')
                    .add({

                  'material_name': nama,
                  'qty': qty,
                  'unit': unit,
                  'price': harga,

                  'created_at':
                      Timestamp.now(),
                });

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

            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}