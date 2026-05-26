import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/data_pelanggan_controller.dart';

class DataPelangganView extends StatelessWidget {
  const DataPelangganView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.find<DataPelangganController>();

    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xFF2196F3),
        title: const Text(
          'Data Pelanggan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2196F3),
        onPressed: () {
          Get.toNamed('/form-pelanggan');
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),

      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: controller.getPelanggan(),
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
              child: Text('Belum ada pelanggan'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final pelanggan = data[index];

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
                      color: Colors.blue.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Color(0xFF2196F3),
                    ),
                  ),

                  title: Text(
                    pelanggan['name'] ?? '-',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      pelanggan['phone'] ?? '-',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                  ),

                  trailing: PopupMenuButton<String>(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    onSelected: (value) {
                      if (value == 'edit') {
                        Get.toNamed(
                          '/form-pelanggan',
                          arguments: pelanggan,
                        );
                      }

                      if (value == 'hapus') {
                        controller.hapusPelanggan(
                          pelanggan['id'],
                        );
                      }

                      if (value == 'riwayat') {
                        Get.toNamed(
                          '/riwayat-pelanggan',
                          arguments: pelanggan,
                        );
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'riwayat',
                        child: Row(
                          children: [
                            Icon(Icons.history),
                            SizedBox(width: 8),
                            Text('Riwayat'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'hapus',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Hapus',
                              style: TextStyle(
                                color: Colors.red,
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