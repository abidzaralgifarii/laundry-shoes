import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tambah_promo_controller.dart';

class TambahPromoView extends StatelessWidget {
  const TambahPromoView({super.key});

  @override
  Widget build(BuildContext context) {

    final controller =
        Get.find<TambahPromoController>();

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
          'Tambah Promo',

          style: TextStyle(
            color: Colors.white,

            fontWeight:
                FontWeight.bold,

            fontSize: 20,
          ),
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          children: [

            /// ================= NAMA =================
            TextField(
              controller:
                  controller.nameC,

              decoration:
                  InputDecoration(

                labelText:
                    'Nama Promo',

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
                  Icons.local_offer,
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// ================= TIPE =================
            Obx(
              () => DropdownButtonFormField(

                value:
                    controller.type.value,

                decoration:
                    InputDecoration(

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
                    Icons.discount,
                  ),
                ),

                items: const [

                  DropdownMenuItem(
                    value:
                        'percent',

                    child: Text(
                      'Persen (%)',
                    ),
                  ),

                  DropdownMenuItem(
                    value:
                        'nominal',

                    child: Text(
                      'Nominal (Rp)',
                    ),
                  ),
                ],

                onChanged: (v) {

                  controller
                      .type.value = v!;
                },
              ),
            ),

            const SizedBox(height: 16),

            /// ================= VALUE =================
            TextField(
              controller:
                  controller.valueC,

              keyboardType:
                  TextInputType.number,

              decoration:
                  InputDecoration(

                labelText:
                    'Nilai Promo',

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

            const SizedBox(height: 24),

            /// ================= BUTTON =================
            SizedBox(
              width: double.infinity,

              child: Obx(
                () => ElevatedButton(

                  style:
                      ElevatedButton
                          .styleFrom(

                    backgroundColor:
                        const Color(
                      0xFF2196F3,
                    ),

                    padding:
                        const EdgeInsets
                            .symmetric(
                      vertical: 16,
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
                      controller
                              .isLoading
                              .value
                          ? null
                          : controller
                              .simpanPromo,

                  child: controller
                          .isLoading
                          .value

                      ? const CircularProgressIndicator(
                          color:
                              Colors.white,
                        )

                      : const Text(
                          'Simpan Promo',

                          style: TextStyle(
                            color:
                                Colors.white,

                            fontWeight:
                                FontWeight
                                    .bold,

                            fontSize: 16,
                          ),
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