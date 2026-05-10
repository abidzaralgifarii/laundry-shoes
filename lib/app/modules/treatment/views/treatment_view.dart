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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ================= NAMA =================
            TextField(
              controller: controller.namaC,

              decoration: const InputDecoration(
                labelText: 'Nama Treatment',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            /// ================= HARGA =================
            TextField(
              controller: controller.hargaC,
              keyboardType: TextInputType.number,

              decoration: const InputDecoration(
                labelText: 'Harga',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            /// ================= DURASI =================
            TextField(
              controller: controller.durasiC,

              decoration: const InputDecoration(
                labelText: 'Durasi (contoh: 3 hari)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            /// ================= TITLE =================
            const Text(
              'Bahan Treatment',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 12),

            /// ================= DROPDOWN MATERIAL =================
            Obx(
              () => DropdownButtonFormField<Map<String, dynamic>>(
                value: controller.selectedMaterial.value,
                isExpanded: true,

                decoration: const InputDecoration(
                  labelText: 'Pilih Bahan',
                  border: OutlineInputBorder(),
                ),

                items: controller.materialList.map((item) {

                  return DropdownMenuItem(
                    value: item,

                    child: Text(
                      '${item['name']} (${item['unit']})',
                    ),
                  );

                }).toList(),

                onChanged: (value) {
                  controller.selectedMaterial.value = value;
                },
              ),
            ),

            const SizedBox(height: 12),

            /// ================= QTY MATERIAL =================
            TextField(
              controller: controller.qtyMaterialC,
              keyboardType: TextInputType.number,

              decoration: const InputDecoration(
                labelText: 'Qty Bahan',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            /// ================= BUTTON TAMBAH =================
            SizedBox(
              width: double.infinity,

              child: OutlinedButton.icon(
                onPressed: controller.tambahMaterial,

                icon: const Icon(Icons.add),

                label: const Text('Tambah Bahan'),
              ),
            ),

            const SizedBox(height: 16),

            /// ================= LIST MATERIAL =================
            Obx(() {

              if (controller.materials.isEmpty) {
                return const Text(
                  'Belum ada bahan',
                );
              }

              return Column(
                children:
                    controller.materials.asMap().entries.map((entry) {

                  final index = entry.key;
                  final material = entry.value;

                  return Card(
                    child: ListTile(

                      leading: const Icon(
                        Icons.inventory,
                      ),

                      title: Text(
                        material['name'],
                      ),

                      subtitle: Text(
                        '${material['qty']} ${material['unit']}',
                      ),

                      trailing: IconButton(
                        onPressed: () {
                          controller.hapusMaterial(index);
                        },

                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  );

                }).toList(),
              );
            }),

            const SizedBox(height: 24),

            /// ================= BUTTON SIMPAN =================
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: controller.simpanTreatment,

                child: const Text(
                  'Simpan Treatment',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}