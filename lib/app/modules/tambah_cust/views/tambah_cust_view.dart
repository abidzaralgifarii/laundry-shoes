import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_sepatu/app/modules/tambah_cust/controllers/tambah_cust_controller.dart';


class TambahCustomerView extends StatelessWidget {
  const TambahCustomerView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TambahCustomerController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// NAMA
            TextField(
              controller: controller.namaC,
              decoration: const InputDecoration(
                labelText: 'Nama Customer',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            /// WHATSAPP
            TextField(
              controller: controller.waC,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'No WhatsApp',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            /// BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.simpanCustomer,
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}