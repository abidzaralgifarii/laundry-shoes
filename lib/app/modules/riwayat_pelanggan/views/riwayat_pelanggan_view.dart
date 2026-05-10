import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/riwayat_pelanggan_controller.dart';

class RiwayatPelangganView extends StatelessWidget {
  const RiwayatPelangganView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.find<RiwayatPelangganController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Riwayat ${controller.namaPelanggan}',
        ),
      ),

      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: controller.getRiwayat(),

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data = snapshot.data ?? [];

          if (data.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada riwayat pesanan',
              ),
            );
          }

          return ListView.builder(
            itemCount: data.length,

            itemBuilder: (context, index) {

              final order = data[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),

                child: ListTile(

                  /// 🔥 TOTAL
                  title: Text(
                    'Rp ${order['final_price'] ?? order['total_price']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  /// 🔥 STATUS
                  subtitle: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Text(
                        'Status: ${order['status']}',
                      ),

                      /// 🔥 PROMO
                      if (order['promo_name'] != null)
                        Text(
                          'Promo: ${order['promo_name']}',
                          style: const TextStyle(
                            color: Colors.green,
                          ),
                        ),
                    ],
                  ),

                  /// 🔥 ICON STATUS
                  trailing: Icon(
                    _iconStatus(order['status']),
                    color: _warnaStatus(order['status']),
                  ),

                  /// 🔥 BUKA DETAIL PESANAN
                  onTap: () {

                    final orderId = order['id'];

                    Get.toNamed(
                      '/order/$orderId',
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

  /// ================= ICON STATUS =================
  IconData _iconStatus(String status) {
    switch (status) {

      case 'Selesai':
        return Icons.check_circle;

      case 'Diproses':
        return Icons.local_laundry_service;

      default:
        return Icons.access_time;
    }
  }

  /// ================= WARNA STATUS =================
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