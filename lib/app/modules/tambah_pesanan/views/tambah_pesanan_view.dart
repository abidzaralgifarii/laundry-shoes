import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tambah_pesanan_controller.dart';

class TambahPesananView extends StatelessWidget {
  const TambahPesananView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TambahPesananController>();

    return Scaffold(
      backgroundColor: Colors.grey[100],

      /// ================= APPBAR =================
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xFF2196F3),
        title: const Text(
          'Tambah Pesanan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
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
                      hint: const Text(
                        'Pilih Pelanggan',
                      ),
                      items: controller.customerList.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(
                            '${item['name'] ?? '-'} - ${item['phone'] ?? '-'}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        controller.selectedCustomer.value = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Pelanggan',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            14,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            14,
                          ),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            14,
                          ),
                          borderSide: const BorderSide(
                            color: Color(0xFF2196F3),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                SizedBox(
                  height: 56,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(
                        0xFF2196F3,
                      ),
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                        color: Color(
                          0xFF2196F3,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          14,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      final result = await Get.toNamed(
                        '/tambah-cust',
                      );

                      if (result != null) {
                        controller.customerList.add(result);

                        controller.selectedCustomer.value = result;
                      }
                    },
                    child: const Icon(
                      Icons.add,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// ================= INPUT ITEM =================
            const Text(
              'Input Item Pesanan',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: controller.sepatuC,
              decoration: InputDecoration(
                labelText: 'Nama Barang',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    14,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    14,
                  ),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    14,
                  ),
                  borderSide: const BorderSide(
                    color: Color(0xFF2196F3),
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// ================= TREATMENT =================
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        Get.bottomSheet(
                          Container(
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.75,
                            ),
                            padding: const EdgeInsets.fromLTRB(
                              16,
                              10,
                              16,
                              16,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(
                                  24,
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                /// ================= HANDLE =================
                                Container(
                                  width: 45,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(
                                      20,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                /// ================= TITLE =================
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(
                                        10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFF2196F3,
                                        ).withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(
                                          12,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.cleaning_services,
                                        color: Color(
                                          0xFF2196F3,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Pilih Treatment',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            'Pilih layanan untuk item pesanan',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                /// ================= LIST TREATMENT =================
                                Expanded(
                                  child: Obx(() {
                                    if (controller.treatmentList.isEmpty) {
                                      return Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.cleaning_services_outlined,
                                              size: 48,
                                              color: Colors.grey[400],
                                            ),
                                            const SizedBox(height: 8),
                                            const Text(
                                              'Belum ada data treatment',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }

                                    return ListView.separated(
                                      itemCount:
                                          controller.treatmentList.length,
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(height: 8);
                                      },
                                      itemBuilder: (context, index) {
                                        final item =
                                            controller.treatmentList[index];

                                        final isSelected =
                                            controller.selectedTreatment
                                                    .value?['id'] ==
                                                item['id'];

                                        return Material(
                                          color: isSelected
                                              ? const Color(
                                                  0xFF2196F3,
                                                ).withOpacity(0.08)
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            onTap: () {
                                              controller.pilihTreatment(item);
                                              Get.back();
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  16,
                                                ),
                                                border: Border.all(
                                                  color: isSelected
                                                      ? const Color(
                                                          0xFF2196F3,
                                                        )
                                                      : Colors.grey.shade300,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 42,
                                                    height: 42,
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                        0xFF2196F3,
                                                      ).withOpacity(0.12),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        12,
                                                      ),
                                                    ),
                                                    child: const Icon(
                                                      Icons
                                                          .local_laundry_service,
                                                      color: Color(
                                                        0xFF2196F3,
                                                      ),
                                                    ),
                                                  ),

                                                  const SizedBox(width: 12),

                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          item['name'] ?? '-',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(
                                                          '${item['duration'] ?? '-'}',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey[600],
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  const SizedBox(width: 8),

                                                  Text(
                                                    'Rp ${item['price'] ?? 0}',
                                                    style: const TextStyle(
                                                      color: Color(
                                                        0xFF2196F3,
                                                      ),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13,
                                                    ),
                                                  ),

                                                  const SizedBox(width: 4),

                                                  PopupMenuButton<String>(
                                                    icon: const Icon(
                                                      Icons.more_vert,
                                                      color: Colors.grey,
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        14,
                                                      ),
                                                    ),
                                                    onSelected: (value) {
                                                      if (value == 'edit') {
                                                        controller
                                                            .editTreatment(
                                                          item,
                                                        );
                                                      } else if (value ==
                                                          'hapus') {
                                                        controller
                                                            .confirmDeleteTreatment(
                                                          item,
                                                        );
                                                      }
                                                    },
                                                    itemBuilder: (context) =>
                                                        const [
                                                      PopupMenuItem(
                                                        value: 'edit',
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .edit_outlined,
                                                              size: 18,
                                                              color: Color(
                                                                0xFF2196F3,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text('Edit'),
                                                          ],
                                                        ),
                                                      ),
                                                      PopupMenuItem(
                                                        value: 'hapus',
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .delete_outline,
                                                              size: 18,
                                                              color: Colors.red,
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              'Hapus',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                          isScrollControlled: true,
                        );
                      },
                      child: Container(
                        height: 56,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey.shade400,
                          ),
                          borderRadius: BorderRadius.circular(
                            14,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.cleaning_services_outlined,
                              color: Color(
                                0xFF2196F3,
                              ),
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                controller.selectedTreatment.value == null
                                    ? 'Pilih Treatment'
                                    : '${controller.selectedTreatment.value?['name']} - Rp ${controller.selectedTreatment.value?['price']}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  color:
                                      controller.selectedTreatment.value == null
                                          ? Colors.grey[700]
                                          : Colors.black,
                                  fontWeight:
                                      controller.selectedTreatment.value == null
                                          ? FontWeight.normal
                                          : FontWeight.w600,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                SizedBox(
                  height: 56,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(
                        0xFF2196F3,
                      ),
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                        color: Color(
                          0xFF2196F3,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          14,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      final result = await Get.toNamed(
                        '/treatment',
                      );

                      if (result != null) {
                        await controller.getTreatments();

                        controller.selectedTreatment.value = result;

                        controller.hitungTotal();
                      }
                    },
                    child: const Icon(
                      Icons.add,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            TextField(
              controller: controller.qtyC,
              keyboardType: TextInputType.number,
              onChanged: (_) => controller.hitungTotal(),
              decoration: InputDecoration(
                labelText: 'Qty',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    14,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    14,
                  ),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    14,
                  ),
                  borderSide: const BorderSide(
                    color: Color(0xFF2196F3),
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Obx(
              () => Text(
                'Total Item: Rp ${controller.total.value}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(
                  0xFF2196F3,
                ),
                backgroundColor: Colors.white,
                side: const BorderSide(
                  color: Color(
                    0xFF2196F3,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    14,
                  ),
                ),
              ),
              onPressed: controller.tambahItem,
              icon: const Icon(
                Icons.add,
              ),
              label: const Text(
                'Tambah Item',
              ),
            ),

            const SizedBox(height: 20),

            /// ================= LIST ITEM =================
            const Text(
              'Daftar Item',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 8),

            Obx(() {
              if (controller.items.isEmpty) {
                return const Text(
                  'Belum ada item pesanan',
                );
              }

              return Column(
                children: controller.items.asMap().entries.map((entry) {
                  final index = entry.key;

                  final item = entry.value;

                  return Card(
                    elevation: 2,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        16,
                      ),
                    ),
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
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(
                                  0xFF2196F3,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              controller.hapusItem(
                                index,
                              );
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
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
            Obx(
              () => Text(
                'Total Semua: Rp ${controller.totalSemua.value}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// ================= PROMO =================
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => DropdownButtonFormField<Map<String, dynamic>>(
                      isExpanded: true,
                      value: controller.selectedPromo.value,
                      hint: const Text(
                        'Pilih Promo',
                      ),
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
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            14,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            14,
                          ),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            14,
                          ),
                          borderSide: const BorderSide(
                            color: Color(0xFF2196F3),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                SizedBox(
                  height: 56,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(
                        0xFF2196F3,
                      ),
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                        color: Color(
                          0xFF2196F3,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          14,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      final result = await Get.toNamed(
                        '/tambah-promo',
                      );

                      if (result != null) {
                        controller.promoList.add(result);

                        controller.selectedPromo.value = result;

                        controller.hitungDiskon();
                      }
                    },
                    child: const Icon(
                      Icons.add,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// ================= DISKON =================
            Obx(
              () => Text(
                'Diskon: Rp ${controller.discount.value}',
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),

            const SizedBox(height: 8),

            /// ================= TOTAL AKHIR =================
            Obx(
              () => Text(
                'Total Akhir: Rp ${controller.totalAkhir}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// ================= SIMPAN =================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                    0xFF2196F3,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      14,
                    ),
                  ),
                ),
                onPressed: controller.simpanPesanan,
                child: const Text(
                  'Simpan Pesanan',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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