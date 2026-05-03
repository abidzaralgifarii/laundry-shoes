import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/treatment_controller.dart';

class TreatmentView extends StatelessWidget {
  const TreatmentView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TreatmentController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Treatment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// NAMA TREATMENT
            TextField(
              controller: controller.namaC,
              decoration: const InputDecoration(
                labelText: 'Nama Treatment',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            /// HARGA
            TextField(
              controller: controller.hargaC,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Harga',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            /// ESTIMASI WAKTU
            TextField(
              controller: controller.durasiC,
              decoration: const InputDecoration(
                labelText: 'Estimasi Waktu (contoh: 2 Hari)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            /// BUTTON SIMPAN
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.simpanTreatment,
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}