import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/form_pelanggan_controller.dart';

class FormPelangganView extends StatelessWidget {
  const FormPelangganView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FormPelangganController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.isEdit.value
                ? 'Edit Pelanggan'
                : 'Tambah Pelanggan',
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            /// 🔥 NAMA
            TextField(
              controller: controller.namaC,
              decoration: const InputDecoration(
                labelText: 'Nama Pelanggan',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            /// 🔥 NO HP
            TextField(
              controller: controller.phoneC,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Nomor HP',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            /// 🔥 BUTTON SIMPAN
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: () {
                  controller.simpanPelanggan();
                },

                child: Obx(
                  () => Text(
                    controller.isEdit.value
                        ? 'Update Pelanggan'
                        : 'Simpan Pelanggan',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}