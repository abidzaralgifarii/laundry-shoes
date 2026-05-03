import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/pesanan_controller.dart';

class PesananView extends StatelessWidget {
  const PesananView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PesananController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesanan'),
      ),

      /// 🔥 BUTTON TAMBAH PESANAN
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/tambah-pesanan');
        },
        child: const Icon(Icons.add),
      ),

      /// 🔥 LIST PESANAN
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: controller.getPesanan(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data ?? [];

          if (data.isEmpty) {
            return const Center(
              child: Text('Belum ada pesanan'),
            );
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final pesanan = data[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ListTile(
                  title: Text(
                    pesanan['customer_name'] ?? '-',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),

                      Text(
                        'Total: Rp ${pesanan['final_price'] ?? pesanan['total_price']}',
                      ),

                      const SizedBox(height: 2),

                      /// 🔥 DISKON (OPTIONAL)
                      if (pesanan['discount'] != null &&
                          pesanan['discount'] > 0)
                        Text(
                          'Diskon: Rp ${pesanan['discount']}',
                          style: const TextStyle(color: Colors.red),
                        ),

                      /// 🔥 STATUS
                      Text(
                        'Status: ${pesanan['status']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _warnaStatus(pesanan['status']),
                        ),
                      ),
                    ],
                  ),

                  isThreeLine: true,

                  /// 🔥 ACTION BUTTONS
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// 🔥 UPDATE STATUS & HAPUS
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (value) async {
                          if (value == 'hapus') {
                            await controller.deletePesanan(
                              pesanan['id'],
                            );
                          } else {
                            await controller.updateStatus(
                              pesanan['id'],
                              value,
                            );
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: 'Diproses',
                            child: Text('Diproses'),
                          ),
                          PopupMenuItem(
                            value: 'Selesai',
                            child: Text('Selesai'),
                          ),
                          PopupMenuItem(
                            value: 'hapus',
                            child: Text('Hapus'),
                          ),
                        ],
                      ),

                      /// 🔥 PRINT PDF
                      IconButton(
                        icon: const Icon(Icons.print),
                        onPressed: () {
                          controller.cetakStrukPDF(pesanan);
                        },
                      ),

                      /// 🔥 WHATSAPP
                      IconButton(
                        icon: const Icon(
                          Icons.chat,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          controller.kirimWhatsApp(pesanan);
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

  /// 🔥 FORMAT TANGGAL
  String _formatTanggal(dynamic timestamp) {
    final date = timestamp.toDate();
    return DateFormat('dd MMM yyyy').format(date);
  }

  /// 🔥 WARNA STATUS
  Color _warnaStatus(String status) {
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
