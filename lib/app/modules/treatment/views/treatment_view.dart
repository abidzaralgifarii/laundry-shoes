import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/treatment_controller.dart';

class TreatmentView extends StatelessWidget {
  const TreatmentView({super.key});

  @override
  Widget build(BuildContext context) {

    final controller =
        Get.find<TreatmentController>();

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
          'Tambah Treatment',

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
              CrossAxisAlignment.start,

          children: [

            /// ================= NAMA =================
            TextField(
              controller:
                  controller.namaC,

              decoration:
                  InputDecoration(

                labelText:
                    'Nama Treatment',

                filled: true,

                fillColor:
                    Colors.white,

                border:
                    OutlineInputBorder(

                  borderRadius:
                      BorderRadius
                          .circular(14),
                ),

                prefixIcon:
                    const Icon(
                  Icons.cleaning_services,
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// ================= HARGA =================
            TextField(
              controller:
                  controller.hargaC,

              keyboardType:
                  TextInputType.number,

              decoration:
                  InputDecoration(

                labelText:
                    'Harga',

                filled: true,

                fillColor:
                    Colors.white,

                border:
                    OutlineInputBorder(

                  borderRadius:
                      BorderRadius
                          .circular(14),
                ),

                prefixIcon:
                    const Icon(
                  Icons.payments,
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// ================= DURASI =================
            TextField(
              controller:
                  controller.durasiC,

              decoration:
                  InputDecoration(

                labelText:
                    'Durasi (contoh: 3 hari)',

                filled: true,

                fillColor:
                    Colors.white,

                border:
                    OutlineInputBorder(

                  borderRadius:
                      BorderRadius
                          .circular(14),
                ),

                prefixIcon:
                    const Icon(
                  Icons.schedule,
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// ================= TITLE =================
            const Text(
              'Bahan Treatment',

              style: TextStyle(
                fontWeight:
                    FontWeight.bold,

                fontSize: 16,
              ),
            ),

            const SizedBox(height: 12),

            /// ================= DROPDOWN MATERIAL =================
            Obx(
              () => DropdownButtonFormField<
                  Map<String, dynamic>>(

                value: controller
                    .selectedMaterial
                    .value,

                isExpanded: true,

                decoration:
                    InputDecoration(

                  labelText:
                      'Pilih Bahan',

                  filled: true,

                  fillColor:
                      Colors.white,

                  border:
                      OutlineInputBorder(

                    borderRadius:
                        BorderRadius
                            .circular(14),
                  ),
                ),

                items: controller
                    .materialList
                    .map((item) {

                  return DropdownMenuItem(
                    value: item,

                    child: Text(
                      '${item['name']} (${item['unit']})',
                    ),
                  );

                }).toList(),

                onChanged: (value) {

                  controller
                      .selectedMaterial
                      .value = value;
                },
              ),
            ),

            const SizedBox(height: 12),

            /// ================= QTY MATERIAL =================
            TextField(
              controller:
                  controller.qtyMaterialC,

              keyboardType:
                  TextInputType.number,

              decoration:
                  InputDecoration(

                labelText:
                    'Qty Bahan',

                filled: true,

                fillColor:
                    Colors.white,

                border:
                    OutlineInputBorder(

                  borderRadius:
                      BorderRadius
                          .circular(14),
                ),

                prefixIcon:
                    const Icon(
                  Icons.inventory_2,
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// ================= BUTTON TAMBAH =================
            SizedBox(
              width: double.infinity,

              child:
                  OutlinedButton.icon(

                style:
                    OutlinedButton
                        .styleFrom(

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
                        BorderRadius.circular(
                      14,
                    ),
                  ),
                ),

                onPressed:
                    controller.tambahMaterial,

                icon: const Icon(
                  Icons.add,
                ),

                label: const Text(
                  'Tambah Bahan',
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// ================= LIST MATERIAL =================
            Obx(() {

              if (controller
                  .materials.isEmpty) {

                return const Text(
                  'Belum ada bahan',
                );
              }

              return Column(
                children: controller
                    .materials
                    .asMap()
                    .entries
                    .map((entry) {

                  final index =
                      entry.key;

                  final material =
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

                      leading:
                          Container(

                        padding:
                            const EdgeInsets
                                .all(10),

                        decoration:
                            BoxDecoration(

                          color: Colors
                              .blue
                              .withOpacity(
                                  0.1),

                          shape:
                              BoxShape
                                  .circle,
                        ),

                        child:
                            const Icon(
                          Icons.inventory,

                          color:
                              Colors.blue,
                        ),
                      ),

                      title: Text(
                        material[
                            'name'],
                      ),

                      subtitle: Text(
                        '${material['qty']} ${material['unit']}',
                      ),

                      trailing:
                          IconButton(

                        onPressed: () {

                          controller
                              .hapusMaterial(
                            index,
                          );
                        },

                        icon:
                            const Icon(
                          Icons.delete,

                          color:
                              Colors.red,
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
                    controller.simpanTreatment,

                child: const Text(
                  'Simpan Treatment',

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