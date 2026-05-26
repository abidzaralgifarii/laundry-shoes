import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_sepatu/app/modules/tambah_cust/controllers/tambah_cust_controller.dart';

class TambahCustomerView extends StatelessWidget {
  const TambahCustomerView({super.key});

  @override
  Widget build(BuildContext context) {

    final controller =
        Get.find<TambahCustomerController>();

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
          'Tambah Customer',

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
                  controller.namaC,

              decoration:
                  InputDecoration(

                labelText:
                    'Nama Customer',

                filled: true,

                fillColor:
                    Colors.white,

                border:
                    OutlineInputBorder(

                  borderRadius:
                      BorderRadius
                          .circular(14),
                ),

                enabledBorder:
                    OutlineInputBorder(

                  borderRadius:
                      BorderRadius
                          .circular(14),

                  borderSide:
                      BorderSide(
                    color:
                        Colors.grey
                            .shade300,
                  ),
                ),

                focusedBorder:
                    OutlineInputBorder(

                  borderRadius:
                      BorderRadius
                          .circular(14),

                  borderSide:
                      const BorderSide(
                    color:
                        Color(0xFF2196F3),

                    width: 2,
                  ),
                ),

                prefixIcon:
                    const Icon(
                  Icons.person,
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// ================= WHATSAPP =================
            TextField(
              controller:
                  controller.waC,

              keyboardType:
                  TextInputType.phone,

              decoration:
                  InputDecoration(

                labelText:
                    'No WhatsApp',

                filled: true,

                fillColor:
                    Colors.white,

                border:
                    OutlineInputBorder(

                  borderRadius:
                      BorderRadius
                          .circular(14),
                ),

                enabledBorder:
                    OutlineInputBorder(

                  borderRadius:
                      BorderRadius
                          .circular(14),

                  borderSide:
                      BorderSide(
                    color:
                        Colors.grey
                            .shade300,
                  ),
                ),

                focusedBorder:
                    OutlineInputBorder(

                  borderRadius:
                      BorderRadius
                          .circular(14),

                  borderSide:
                      const BorderSide(
                    color:
                        Color(0xFF2196F3),

                    width: 2,
                  ),
                ),

                prefixIcon:
                    const Icon(
                  Icons.phone,
                ),
              ),
            ),

            const SizedBox(height: 24),

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
                    controller.simpanCustomer,

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