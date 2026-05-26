import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/pesanan_controller.dart';

class PesananView extends StatelessWidget {
  const PesananView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.find<PesananController>();

    return Scaffold(
      backgroundColor: Colors.grey[100],

      /// ================= APPBAR =================
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor:
            const Color(0xFF2196F3),

        title: const Text(
          'Pesanan',

          style: TextStyle(
            color: Colors.white,
            fontWeight:
                FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      /// ================= BUTTON TAMBAH =================
      floatingActionButton:
          FloatingActionButton(
        backgroundColor:
            const Color(0xFF2196F3),

        onPressed: () {
          Get.toNamed(
            '/tambah-pesanan',
          );
        },

        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),

      /// ================= LIST PESANAN =================
      body: StreamBuilder<
          List<Map<String, dynamic>>>(
        stream:
            controller.getPesanan(),

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
                'Belum ada pesanan',
              ),
            );
          }

          return ListView.builder(
            itemCount: data.length,

            itemBuilder:
                (context, index) {

              final pesanan =
                  data[index];

              return Card(
                elevation: 3,

                color: Colors.white,

                margin:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                ),

                child: ListTile(

                  /// ================= NAMA =================
                  title: Text(
                    pesanan[
                            'customer_name'] ??
                        '-',

                    style:
                        const TextStyle(
                      fontWeight:
                          FontWeight.bold,

                      fontSize: 16,
                    ),
                  ),

                  /// ================= DETAIL =================
                  subtitle: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [

                      const SizedBox(
                        height: 8,
                      ),

                      /// ================= TOTAL =================
                      Text(
                        'Total: Rp ${pesanan['final_price'] ?? pesanan['total_price']}',

                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.w500,
                        ),
                      ),

                      const SizedBox(
                        height: 4,
                      ),

                      /// ================= DISKON =================
                      if (pesanan[
                                  'discount'] !=
                              null &&
                          pesanan[
                                  'discount'] >
                              0)

                        Text(
                          'Diskon: Rp ${pesanan['discount']}',

                          style:
                              const TextStyle(
                            color:
                                Colors.red,
                          ),
                        ),

                      const SizedBox(
                        height: 4,
                      ),

                      /// ================= STATUS =================
                      Container(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),

                        decoration:
                            BoxDecoration(
                          color: _warnaStatus(
                                  pesanan[
                                      'status'])
                              .withOpacity(
                                  0.15),

                          borderRadius:
                              BorderRadius
                                  .circular(
                            20,
                          ),
                        ),

                        child: Text(
                          pesanan[
                              'status'],

                          style:
                              TextStyle(
                            fontWeight:
                                FontWeight
                                    .bold,

                            color: _warnaStatus(
                              pesanan[
                                  'status'],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  isThreeLine: true,

                  /// ================= ACTION =================
                  trailing: Row(
                    mainAxisSize:
                        MainAxisSize.min,

                    children: [

                      /// ================= MENU =================
                      PopupMenuButton<
                          String>(
                        icon: const Icon(
                          Icons.more_vert,
                        ),

                        onSelected:
                            (value) async {

                          if (value ==
                              'hapus') {

                            await controller
                                .deletePesanan(
                              pesanan[
                                  'id'],
                            );

                          } else {

                            await controller
                                .updateStatus(
                              pesanan[
                                  'id'],
                              value,
                            );
                          }
                        },

                        itemBuilder:
                            (context) => const [

                          PopupMenuItem(
                            value:
                                'Diproses',

                            child: Text(
                              'Diproses',
                            ),
                          ),

                          PopupMenuItem(
                            value:
                                'Selesai',

                            child: Text(
                              'Selesai',
                            ),
                          ),

                          PopupMenuItem(
                            value:
                                'hapus',

                            child: Text(
                              'Hapus',
                            ),
                          ),
                        ],
                      ),

                      /// ================= PRINT =================
                      IconButton(
                        icon: const Icon(
                          Icons.print,

                          color:
                              Colors.blue,
                        ),

                        onPressed: () {

                          controller
                              .cetakStrukPDF(
                            pesanan,
                          );
                        },
                      ),

                      /// ================= WA =================
                      IconButton(
                        icon: const Icon(
                          Icons.chat,

                          color:
                              Colors.green,
                        ),

                        onPressed: () {

                          controller
                              .kirimWhatsApp(
                            pesanan,
                          );
                        },
                      ),
                    ],
                  ),

                  onTap: () {
                    Get.snackbar(
                      'Info',
                      'Gunakan tombol print / WhatsApp',
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// ================= FORMAT TANGGAL =================
  String _formatTanggal(
      dynamic timestamp) {

    final date =
        timestamp.toDate();

    return DateFormat(
      'dd MMM yyyy',
    ).format(date);
  }

  /// ================= WARNA STATUS =================
  Color _warnaStatus(
      String status) {

    switch (status) {

      case 'Selesai':
        return Colors.green;

      case 'Diproses':
        return Colors.orange;

      default:
        return Colors.grey;
    }
  }
}