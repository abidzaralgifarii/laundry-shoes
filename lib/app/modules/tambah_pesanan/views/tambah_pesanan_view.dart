import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tambah_pesanan_controller.dart';

class TambahPesananView extends StatelessWidget {
  const TambahPesananView({super.key});

  @override
  Widget build(BuildContext context) {

    final controller =
        Get.find<TambahPesananController>();

    return Scaffold(

      backgroundColor:
          Colors.grey[100],

      /// ================= APPBAR =================
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,

        backgroundColor:
            const Color(0xFF2196F3),

        title: const Text(
          'Tambah Pesanan',

          style: TextStyle(
            color: Colors.white,

            fontWeight:
                FontWeight.bold,

            fontSize: 20,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,

          children: [

            /// ================= CUSTOMER =================
            Row(
              children: [

                Expanded(
                  child: Obx(
                    () => DropdownButtonFormField<
                        Map<String, dynamic>>(

                      isExpanded: true,

                      value: controller
                          .selectedCustomer
                          .value,

                      hint: const Text(
                        'Pilih Pelanggan',
                      ),

                      items: controller
                          .customerList
                          .map((item) {

                        return DropdownMenuItem(
                          value: item,

                          child: Text(
                            item['name'] ?? '',

                            overflow:
                                TextOverflow
                                    .ellipsis,
                          ),
                        );
                      }).toList(),

                      onChanged: (value) {

                        controller
                            .selectedCustomer
                            .value = value;
                      },

                      decoration:
                          InputDecoration(

                        labelText:
                            'Pelanggan',

                        border:
                            OutlineInputBorder(

                          borderRadius:
                              BorderRadius
                                  .circular(
                            14,
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

                    style:
                        OutlinedButton
                            .styleFrom(

                      foregroundColor:
                          const Color(
                        0xFF2196F3,
                      ),

                      side:
                          const BorderSide(
                        color: Color(
                          0xFF2196F3,
                        ),
                      ),

                      shape:
                          RoundedRectangleBorder(

                        borderRadius:
                            BorderRadius
                                .circular(
                          14,
                        ),
                      ),
                    ),

                    onPressed: () async {

                      final result =
                          await Get.toNamed(
                        '/tambah-cust',
                      );

                      if (result != null) {

                        controller
                            .customerList
                            .add(result);

                        controller
                            .selectedCustomer
                            .value = result;
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
                fontWeight:
                    FontWeight.bold,

                fontSize: 16,
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller:
                  controller.sepatuC,

              decoration:
                  InputDecoration(

                labelText:
                    'Jenis Barang',

                border:
                    OutlineInputBorder(

                  borderRadius:
                      BorderRadius
                          .circular(14),
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// ================= TREATMENT =================
            Row(
              children: [

                Expanded(
                  child: Obx(
                    () => DropdownButtonFormField<
                        Map<String, dynamic>>(

                      isExpanded: true,

                      value: controller
                          .selectedTreatment
                          .value,

                      hint: const Text(
                        'Pilih Treatment',
                      ),

                      items: controller
                          .treatmentList
                          .map((item) {

                        return DropdownMenuItem(
                          value: item,

                          child: Text(
                            '${item['name']} - Rp ${item['price']}',

                            overflow:
                                TextOverflow
                                    .ellipsis,
                          ),
                        );
                      }).toList(),

                      onChanged: (value) {

                        if (value != null) {

                          controller
                              .pilihTreatment(
                            value,
                          );
                        }
                      },

                      decoration:
                          InputDecoration(

                        border:
                            OutlineInputBorder(

                          borderRadius:
                              BorderRadius
                                  .circular(
                            14,
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

                    style:
                        OutlinedButton
                            .styleFrom(

                      foregroundColor:
                          const Color(
                        0xFF2196F3,
                      ),

                      side:
                          const BorderSide(
                        color: Color(
                          0xFF2196F3,
                        ),
                      ),

                      shape:
                          RoundedRectangleBorder(

                        borderRadius:
                            BorderRadius
                                .circular(
                          14,
                        ),
                      ),
                    ),

                    onPressed: () async {

                      final result =
                          await Get.toNamed(
                        '/treatment',
                      );

                      if (result != null) {

                        controller
                            .treatmentList
                            .add(result);

                        controller
                            .selectedTreatment
                            .value = result;
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
              controller:
                  controller.qtyC,

              keyboardType:
                  TextInputType.number,

              onChanged: (_) =>
                  controller.hitungTotal(),

              decoration:
                  InputDecoration(

                labelText: 'Qty',

                border:
                    OutlineInputBorder(

                  borderRadius:
                      BorderRadius
                          .circular(14),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Obx(() => Text(
                  'Total Item: Rp ${controller.total.value}',

                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                )),

            const SizedBox(height: 12),

            OutlinedButton.icon(

              style:
                  OutlinedButton.styleFrom(

                foregroundColor:
                    const Color(
                  0xFF2196F3,
                ),

                side:
                    const BorderSide(
                  color:
                      Color(0xFF2196F3),
                ),

                padding:
                    const EdgeInsets.symmetric(
                  vertical: 14,
                ),

                shape:
                    RoundedRectangleBorder(

                  borderRadius:
                      BorderRadius
                          .circular(
                    14,
                  ),
                ),
              ),

              onPressed:
                  controller.tambahItem,

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
                fontWeight:
                    FontWeight.bold,

                fontSize: 16,
              ),
            ),

            const SizedBox(height: 8),

            Obx(() {

              if (controller
                  .items.isEmpty) {

                return const Text(
                  'Belum ada item pesanan',
                );
              }

              return Column(
                children: controller
                    .items
                    .asMap()
                    .entries
                    .map((entry) {

                  final index =
                      entry.key;

                  final item =
                      entry.value;

                  return Card(

                    elevation: 2,

                    shape:
                        RoundedRectangleBorder(

                      borderRadius:
                          BorderRadius
                              .circular(
                        16,
                      ),
                    ),

                    child: ListTile(

                      title: Text(
                        item[
                            'shoe_type'],

                        overflow:
                            TextOverflow
                                .ellipsis,
                      ),

                      subtitle: Text(
                        '${item['treatment']} x${item['qty']}',

                        overflow:
                            TextOverflow
                                .ellipsis,
                      ),

                      trailing: Row(
                        mainAxisSize:
                            MainAxisSize.min,

                        children: [

                          Flexible(
                            child: Text(
                              'Rp ${item['total']}',

                              overflow:
                                  TextOverflow
                                      .ellipsis,
                            ),
                          ),

                          IconButton(

                            onPressed: () {

                              controller
                                  .hapusItem(
                                index,
                              );
                            },

                            icon: const Icon(
                              Icons.delete,

                              color:
                                  Colors.red,
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
            Obx(() => Text(
                  'Total Semua: Rp ${controller.totalSemua.value}',

                  style:
                      const TextStyle(
                    fontSize: 18,

                    fontWeight:
                        FontWeight.bold,
                  ),
                )),

            const SizedBox(height: 12),

            /// ================= PROMO =================
            Row(
              children: [

                Expanded(
                  child: Obx(
                    () => DropdownButtonFormField<
                        Map<String, dynamic>>(

                      isExpanded: true,

                      value: controller
                          .selectedPromo
                          .value,

                      hint: const Text(
                        'Pilih Promo',
                      ),

                      items: controller
                          .promoList
                          .map((item) {

                        return DropdownMenuItem(
                          value: item,

                          child: Text(
                            item['name'],

                            overflow:
                                TextOverflow
                                    .ellipsis,
                          ),
                        );
                      }).toList(),

                      onChanged: (value) {

                        controller
                            .selectedPromo
                            .value = value;

                        controller
                            .hitungDiskon();
                      },

                      decoration:
                          InputDecoration(

                        border:
                            OutlineInputBorder(

                          borderRadius:
                              BorderRadius
                                  .circular(
                            14,
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

                    style:
                        OutlinedButton
                            .styleFrom(

                      foregroundColor:
                          const Color(
                        0xFF2196F3,
                      ),

                      side:
                          const BorderSide(
                        color: Color(
                          0xFF2196F3,
                        ),
                      ),

                      shape:
                          RoundedRectangleBorder(

                        borderRadius:
                            BorderRadius
                                .circular(
                          14,
                        ),
                      ),
                    ),

                    onPressed: () async {

                      final result =
                          await Get.toNamed(
                        '/tambah-promo',
                      );

                      if (result != null) {

                        controller
                            .promoList
                            .add(result);

                        controller
                            .selectedPromo
                            .value = result;

                        controller
                            .hitungDiskon();
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
            Obx(() => Text(
                  'Diskon: Rp ${controller.discount.value}',

                  style:
                      const TextStyle(
                    color: Colors.red,
                  ),
                )),

            const SizedBox(height: 8),

            /// ================= TOTAL AKHIR =================
            Obx(() => Text(
                  'Total Akhir: Rp ${controller.totalAkhir}',

                  style:
                      const TextStyle(
                    fontSize: 18,

                    fontWeight:
                        FontWeight.bold,
                  ),
                )),

            const SizedBox(height: 20),

            /// ================= SIMPAN =================
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(

                style:
                    ElevatedButton.styleFrom(

                  backgroundColor:
                      const Color(
                    0xFF2196F3,
                  ),

                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 16,
                  ),

                  shape:
                      RoundedRectangleBorder(

                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                  ),
                ),

                onPressed:
                    controller.simpanPesanan,

                child: const Text(
                  'Simpan Pesanan',

                  style: TextStyle(
                    color: Colors.white,

                    fontWeight:
                        FontWeight.bold,

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