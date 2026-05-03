import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tambah_promo_controller.dart';

class TambahPromoView extends StatelessWidget {
  const TambahPromoView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TambahPromoController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Promo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// NAMA
            TextField(
              controller: controller.nameC,
              decoration: const InputDecoration(
                labelText: 'Nama Promo',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            /// TIPE
            Obx(() => DropdownButtonFormField(
                  value: controller.type.value,
                  items: const [
                    DropdownMenuItem(
                      value: 'percent',
                      child: Text('Persen (%)'),
                    ),
                    DropdownMenuItem(
                      value: 'nominal',
                      child: Text('Nominal (Rp)'),
                    ),
                  ],
                  onChanged: (v) {
                    controller.type.value = v!;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                )),

            const SizedBox(height: 16),

            /// VALUE
            TextField(
              controller: controller.valueC,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nilai Promo',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            /// BUTTON
            SizedBox(
              width: double.infinity,
              child: Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.simpanPromo,
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text('Simpan Promo'),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}