import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/stok_bahan_controller.dart';

class StokBahanView extends StatelessWidget {
  const StokBahanView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StokBahanController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stok Bahan'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/form-stok-bahan');
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: controller.getBahan(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data ?? [];

          if (data.isEmpty) {
            return const Center(child: Text('Belum ada bahan'));
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final bahan = data[index];
              final stock = bahan['stock'] ?? 0;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: stock <= 10 ? Colors.red : Colors.blue,
                    child: const Icon(Icons.inventory, color: Colors.white),
                  ),
                  title: Text(
                    bahan['name'] ?? '-',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Stok: ${bahan['stock']} ${bahan['unit']}',
                    style: TextStyle(
                      color: stock <= 10 ? Colors.red : Colors.black,
                      fontWeight:
                          stock <= 10 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        Get.toNamed(
                          '/form-stok-bahan',
                          arguments: bahan,
                        );
                      }

                      if (value == 'hapus') {
                        controller.hapusBahan(bahan['id']);
                      }
                    },
                    itemBuilder: (context) => const [
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