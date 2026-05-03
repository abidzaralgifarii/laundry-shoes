import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tambah_pesanan_controller.dart';

class TambahPesananView extends StatelessWidget {
  const TambahPesananView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TambahPesananController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pesanan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            /// ================= CUSTOMER =================
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => DropdownButtonFormField<Map<String, dynamic>>(
                      isExpanded: true,
                      value: controller.selectedCustomer.value,
                      hint: const Text('Pilih Pelanggan'),
                      items: controller.customerList.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(
                            item['name'] ?? '',
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        controller.selectedCustomer.value = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Pelanggan',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () async {
                      final result = await Get.toNamed('/tambah-cust');
                      if (result != null) {
                        controller.customerList.add(result);
                        controller.selectedCustomer.value = result;
                      }
                    },
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// ================= INPUT ITEM =================
            const Text(
              'Input Item Pesanan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: controller.sepatuC,
              decoration: const InputDecoration(
                labelText: 'Jenis Barang',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            /// ================= TREATMENT =================
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => DropdownButtonFormField<Map<String, dynamic>>(
                      isExpanded: true,
                      value: controller.selectedTreatment.value,
                      hint: const Text('Pilih Treatment'),
                      items: controller.treatmentList.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(
                            '${item['name']} - Rp ${item['price']}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          controller.pilihTreatment(value);
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () async {
                      final result = await Get.toNamed('/treatment');
                      if (result != null) {
                        controller.treatmentList.add(result);
                        controller.selectedTreatment.value = result;
                      }
                    },
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            TextField(
              controller: controller.qtyC,
              keyboardType: TextInputType.number,
              onChanged: (_) => controller.hitungTotal(),
              decoration: const InputDecoration(
                labelText: 'Qty',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            Obx(() => Text(
                  'Total Item: Rp ${controller.total.value}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: controller.tambahItem,
              icon: const Icon(Icons.add),
              label: const Text('Tambah Item'),
            ),

            const SizedBox(height: 20),

            /// ================= LIST ITEM =================
            const Text(
              'Daftar Item',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 8),

            Obx(() {
              if (controller.items.isEmpty) {
                return const Text('Belum ada item pesanan');
              }

              return Column(
                children: controller.items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;

                  return Card(
                    child: ListTile(
                      title: Text(
                        item['shoe_type'],
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '${item['treatment']} x${item['qty']}',
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              'Rp ${item['total']}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              controller.hapusItem(index);
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            }),

            const SizedBox(height: 16),

            /// ================= TOTAL =================
            Obx(() => Text(
                  'Total Semua: Rp ${controller.totalSemua.value}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )),

            const SizedBox(height: 12),

            /// ================= PROMO =================
            Row(
              children: [
                Expanded(
                  child: Obx(() => DropdownButtonFormField<Map<String, dynamic>>(
                        isExpanded: true,
                        value: controller.selectedPromo.value,
                        hint: const Text('Pilih Promo'),
                        items: controller.promoList.map((item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(
                              item['name'],
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          controller.selectedPromo.value = value;
                          controller.hitungDiskon();
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      )),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () async {
                      final result = await Get.toNamed('/tambah-promo');

                      if (result != null) {
                        controller.promoList.add(result);
                        controller.selectedPromo.value = result;
                        controller.hitungDiskon();
                      }
                    },
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// 🔥 DISKON
            Obx(() => Text(
                  'Diskon: Rp ${controller.discount.value}',
                  style: const TextStyle(color: Colors.red),
                )),

            const SizedBox(height: 8),

            /// 🔥 TOTAL AKHIR
            Obx(() => Text(
                  'Total Akhir: Rp ${controller.totalAkhir}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )),

            const SizedBox(height: 20),

            /// ================= SIMPAN =================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.simpanPesanan,
                child: const Text('Simpan Pesanan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}