import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/form_stok_bahan_controller.dart';

class FormStokBahanView extends StatelessWidget {
  const FormStokBahanView({super.key});

  @override
  Widget build(BuildContext context) {

    final controller =
        Get.find<FormStokBahanController>();

    return Scaffold(

      backgroundColor:
          Colors.grey[100],

      /// ================= APPBAR =================
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,

        backgroundColor:
            const Color(0xFF2196F3),

        title: Obx(
          () => Text(

            controller.isEdit.value

                ? 'Edit Bahan'

                : 'Tambah Bahan',

            style: const TextStyle(
              color: Colors.white,

              fontWeight:
                  FontWeight.bold,

              fontSize: 20,
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          children: [

            /// ================= NAMA =================
            TextField(
              controller:
                  controller.namaC,

              decoration:
                  InputDecoration(

                labelText:
                    'Nama Bahan',

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

            const SizedBox(height: 16),

            /// ================= STOCK =================
            TextField(
              controller:
                  controller.stockC,

              keyboardType:
                  TextInputType.number,

              decoration:
                  InputDecoration(

                labelText:
                    'Stok',

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
                  Icons.numbers,
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// ================= UNIT =================
            TextField(
              controller:
                  controller.unitC,

              decoration:
                  InputDecoration(

                labelText:
                    'Satuan (ml, pcs, dll)',

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
                  Icons.straighten,
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// ================= HARGA BELI =================
            Obx(() {

              /// ================= EDIT =================
              if (controller
                  .isEdit.value) {

                return const SizedBox();
              }

              return Column(
                children: [

                  TextField(
                    controller:
                        controller.hargaC,

                    keyboardType:
                        TextInputType
                            .number,

                    decoration:
                        InputDecoration(

                      labelText:
                          'Harga Beli Awal',

                      filled: true,

                      fillColor:
                          Colors.white,

                      border:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius
                                .circular(
                          14,
                        ),
                      ),

                      prefixIcon:
                          const Icon(
                        Icons.payments,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),
                ],
              );
            }),

            /// ================= BUTTON =================
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
                    controller.simpanBahan,

                child: const Text(
                  'Simpan',

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