import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/form_stok_bahan_controller.dart';

class FormStokBahanView extends StatelessWidget {
  const FormStokBahanView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FormStokBahanController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.isEdit.value ? 'Edit Bahan' : 'Tambah Bahan',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller.namaC,
              decoration: const InputDecoration(
                labelText: 'Nama Bahan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.stockC,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Stok',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.unitC,
              decoration: const InputDecoration(
                labelText: 'Satuan (ml / pcs)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.simpanBahan,
                child: Obx(
                  () => Text(
                    controller.isEdit.value ? 'Update Bahan' : 'Simpan Bahan',
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