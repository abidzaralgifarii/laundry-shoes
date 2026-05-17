import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/form_stok_bahan_controller.dart';

class FormStokBahanView extends StatelessWidget {
  const FormStokBahanView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.find<FormStokBahanController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(

          controller.isEdit.value
              ? 'Edit Bahan'
              : 'Tambah Bahan',
        )),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            /// ================= NAMA =================
            TextField(
              controller: controller.namaC,

              decoration: const InputDecoration(
                labelText: 'Nama Bahan',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            /// ================= STOCK =================
            TextField(
              controller: controller.stockC,
              keyboardType: TextInputType.number,

              decoration: const InputDecoration(
                labelText: 'Stok',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            /// ================= UNIT =================
            TextField(
              controller: controller.unitC,

              decoration: const InputDecoration(
                labelText: 'Satuan (ml, pcs, dll)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            /// ================= HARGA BELI =================
            Obx(() {

              /// 🔥 HANYA SAAT TAMBAH
              if (controller.isEdit.value) {
                return const SizedBox();
              }

              return Column(
                children: [

                  TextField(
                    controller: controller.hargaC,
                    keyboardType:
                        TextInputType.number,

                    decoration:
                        const InputDecoration(
                      labelText:
                          'Harga Beli Awal',
                      border:
                          OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              );
            }),

            /// ================= BUTTON =================
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed:
                    controller.simpanBahan,

                child: const Text(
                  'Simpan',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}