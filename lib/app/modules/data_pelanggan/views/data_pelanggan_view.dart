import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/data_pelanggan_controller.dart';

class DataPelangganView extends StatelessWidget {
  const DataPelangganView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DataPelangganController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Pelanggan'),
      ),

      /// 🔥 BUTTON TAMBAH
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/form-pelanggan');
        },
        child: const Icon(Icons.add),
      ),

      /// 🔥 LIST DATA
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
            itemCount: data.length,
            itemBuilder: (context, index) {
              final pelanggan = data[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ListTile(

                  /// 🔥 ICON
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),

                  /// 🔥 NAMA
                  title: Text(
                    pelanggan['name'] ?? '-',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  /// 🔥 NO HP
                  subtitle: Text(
                    pelanggan['phone'] ?? '-',
                  ),

                  /// 🔥 ACTION
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {

                      /// EDIT
                      if (value == 'edit') {
                        Get.toNamed(
                          '/form-pelanggan',
                          arguments: pelanggan,
                        );
                      }

                      /// HAPUS
                      if (value == 'hapus') {
                        controller.hapusPelanggan(
                          pelanggan['id'],
                        );
                      }

                      /// RIWAYAT
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
                        child: Text('Riwayat'),
                      ),

                      PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),

                      PopupMenuItem(
                        value: 'hapus',
                        child: Text('Hapus'),
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