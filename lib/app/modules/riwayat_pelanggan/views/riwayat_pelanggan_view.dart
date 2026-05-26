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
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xFF2196F3),
        title: Text(
          'Riwayat ${controller.namaPelanggan}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
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
              child: Text('Belum ada riwayat pesanan'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final order = data[index];

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _warnaStatus(order['status'])
                          .withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _iconStatus(order['status']),
                      color: _warnaStatus(order['status']),
                    ),
                  ),
                  title: Text(
                    'Rp ${order['final_price'] ?? order['total_price']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status: ${order['status']}',
                          style: TextStyle(
                            color: _warnaStatus(order['status']),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (order['promo_name'] != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Promo: ${order['promo_name']}',
                              style: const TextStyle(
                                color: Colors.green,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                  onTap: () {
                    final orderId = order['id'];
                    Get.toNamed('/order/$orderId');
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

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