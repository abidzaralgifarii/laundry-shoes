import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/stok_bahan_controller.dart';

class StokBahanView extends StatelessWidget {
  const StokBahanView({super.key});

  @override
  Widget build(BuildContext context) {

    final controller =
        Get.find<StokBahanController>();

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
          'Stok Bahan',

          style: TextStyle(
            color: Colors.white,

            fontWeight:
                FontWeight.bold,

            fontSize: 20,
          ),
        ),
      ),

      /// ================= FAB =================
      floatingActionButton:
          FloatingActionButton(

        backgroundColor:
            const Color(0xFF2196F3),

        onPressed: () {

          Get.toNamed(
            '/form-stok-bahan',
          );
        },

        child: const Icon(
          Icons.add,

          color: Colors.white,
        ),
      ),

      /// ================= BODY =================
      body: StreamBuilder<
          List<Map<String, dynamic>>>(

        stream:
            controller.getBahan(),

        builder: (context, snapshot) {

          /// ================= LOADING =================
          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          final data =
              snapshot.data ?? [];

          /// ================= EMPTY =================
          if (data.isEmpty) {

            return const Center(
              child: Text(
                'Belum ada bahan',
              ),
            );
          }

          return ListView.builder(

            padding:
                const EdgeInsets.all(12),

            itemCount: data.length,

            itemBuilder:
                (context, index) {

              final bahan =
                  data[index];

              final stock =
                  bahan['stock'] ?? 0;

              return Card(

                elevation: 2,

                margin:
                    const EdgeInsets.only(
                  bottom: 12,
                ),

                shape:
                    RoundedRectangleBorder(

                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),
                ),

                child: ListTile(

                  contentPadding:
                      const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),

                  /// ================= ICON =================
                  leading: Container(

                    padding:
                        const EdgeInsets.all(
                      12,
                    ),

                    decoration:
                        BoxDecoration(

                      color: stock <= 10

                          ? Colors.red
                              .withOpacity(0.15)

                          : Colors.blue
                              .withOpacity(0.15),

                      shape:
                          BoxShape.circle,
                    ),

                    child: Icon(

                      Icons.inventory_2,

                      color: stock <= 10
                          ? Colors.red
                          : Colors.blue,
                    ),
                  ),

                  /// ================= TITLE =================
                  title: Text(
                    bahan['name'] ?? '-',

                    style:
                        const TextStyle(
                      fontWeight:
                          FontWeight.bold,

                      fontSize: 16,
                    ),
                  ),

                  /// ================= SUBTITLE =================
                  subtitle: Padding(
                    padding:
                        const EdgeInsets.only(
                      top: 6,
                    ),

                    child: Text(
                      'Stok: ${bahan['stock']} ${bahan['unit']}',

                      style: TextStyle(

                        color: stock <= 10
                            ? Colors.red
                            : Colors.black87,

                        fontWeight: stock <= 10

                            ? FontWeight.bold

                            : FontWeight.normal,
                      ),
                    ),
                  ),

                  /// ================= MENU =================
                  trailing:
                      PopupMenuButton<String>(

                    shape:
                        RoundedRectangleBorder(

                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                    ),

                    onSelected: (value) {

                      /// ================= TAMBAH STOK =================
                      if (value ==
                          'tambah') {

                        controller
                            .tambahStok(

                          id:
                              bahan['id'],

                          nama:
                              bahan['name'],

                          stockSekarang:
                              bahan['stock'],

                          unit:
                              bahan['unit'],
                        );
                      }

                      /// ================= EDIT =================
                      if (value ==
                          'edit') {

                        Get.toNamed(
                          '/form-stok-bahan',

                          arguments:
                              bahan,
                        );
                      }

                      /// ================= DELETE =================
                      if (value ==
                          'hapus') {

                        controller
                            .hapusBahan(
                          bahan['id'],
                        );
                      }
                    },

                    itemBuilder:
                        (context) => [

                      /// ================= TAMBAH =================
                      const PopupMenuItem(
                        value:
                            'tambah',

                        child: Row(
                          children: [

                            Icon(
                              Icons.add,
                            ),

                            SizedBox(
                              width: 8,
                            ),

                            Text(
                              'Tambah Stok',
                            ),
                          ],
                        ),
                      ),

                      /// ================= EDIT =================
                      const PopupMenuItem(
                        value:
                            'edit',

                        child: Row(
                          children: [

                            Icon(
                              Icons.edit,
                            ),

                            SizedBox(
                              width: 8,
                            ),

                            Text(
                              'Edit',
                            ),
                          ],
                        ),
                      ),

                      /// ================= DELETE =================
                      const PopupMenuItem(
                        value:
                            'hapus',

                        child: Row(
                          children: [

                            Icon(
                              Icons.delete,

                              color:
                                  Colors.red,
                            ),

                            SizedBox(
                              width: 8,
                            ),

                            Text(
                              'Hapus',

                              style:
                                  TextStyle(
                                color:
                                    Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}