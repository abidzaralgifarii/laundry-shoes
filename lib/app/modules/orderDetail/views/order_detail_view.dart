import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailView extends StatelessWidget {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final id = Get.parameters['id'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Pesanan'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(id)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data =
              snapshot.data!.data() as Map<String, dynamic>?;

          if (data == null) {
            return const Center(
              child: Text('Pesanan tidak ditemukan'),
            );
          }

          final items = data['items'] as List<dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('====================='),
                const Text(
                  '   STATUS PESANAN',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('====================='),

                const SizedBox(height: 10),

                Text('Customer : ${data['customer_name']}'),

                const SizedBox(height: 5),

                Text(
                  'Status   : ${data['status']}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _warnaStatus(data['status']),
                  ),
                ),

                const SizedBox(height: 5),

                if (items.isNotEmpty)
                  Text(
                    'Estimasi : ${items.first['duration'] ?? '-'}',
                  ),

                const SizedBox(height: 10),

                const Text('---------------------'),

                const SizedBox(height: 5),

                const Text(
                  'Detail Pesanan:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                ...items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '- ${item['shoe_type']} (${item['treatment']})',
                        ),
                        Text(
                          '  x${item['qty']} = Rp ${item['total']}',
                        ),
                      ],
                    ),
                  );
                }).toList(),

                const SizedBox(height: 5),
                const Text('---------------------'),
                const SizedBox(height: 8),

                /// 🔥 SUBTOTAL
                Text(
                  'Subtotal : Rp ${data['total_price']}',
                ),

                /// 🔥 DISKON
                if (data['discount'] != null &&
                    data['discount'] > 0)
                  Text(
                    'Diskon (${data['promo_name'] ?? '-'}) : -Rp ${data['discount']}',
                    style: const TextStyle(color: Colors.red),
                  ),

                const SizedBox(height: 5),

                /// 🔥 TOTAL AKHIR
                Text(
                  'Total Bayar : Rp ${data['final_price'] ?? data['total_price']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 10),

                const Text('====================='),
              ],
            ),
          );
        },
      ),
    );
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