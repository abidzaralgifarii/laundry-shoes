import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_sepatu/app/modules/Dashboard/controllers/dashboard_controller.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Scaffold(
      backgroundColor: Colors.grey[100],

      /// HEADER
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          'Eza Shoes',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchDashboardData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 👋 GREETING
              const Text(
                'Hallo, Eza 👋',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                'Selamat datang kembali',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 20),

              /// CARD DASHBOARD
              Obx(() => Row(
                    children: [
                      Expanded(
                        child: _card(
                          title: 'Total Pesanan',
                          value: controller.totalOrders.value.toString(),
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _card(
                          title: 'Hari Ini',
                          value: 'Rp ${controller.totalIncomeToday.value}',
                          color: Colors.green,
                        ),
                      ),
                    ],
                  )),

              const SizedBox(height: 12),

              Obx(() => Row(
                    children: [
                      Expanded(
                        child: _card(
                          title: 'Bulan Ini',
                          value: 'Rp ${controller.totalIncomeMonth.value}',
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _card(
                          title: 'Selesai',
                          value: controller.selesai.value.toString(),
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  )),

              const SizedBox(height: 20),

              /// STATUS
              const Text(
                'Status Pesanan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Obx(() => Row(
                    children: [
                      Expanded(
                        child: _statusCard(
                          'Diterima',
                          controller.diterima.value,
                          Colors.grey,
                        ),
                      ),
                      Expanded(
                        child: _statusCard(
                          'Diproses',
                          controller.diproses.value,
                          Colors.orange,
                        ),
                      ),
                      Expanded(
                        child: _statusCard(
                          'Selesai',
                          controller.selesai.value,
                          Colors.green,
                        ),
                      ),
                    ],
                  )),

              const SizedBox(height: 20),

              /// MENU CEPAT
              const Text(
                'Menu Cepat',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _menuItem(
                    'Tambah Pesanan',
                    Icons.add,
                    () => Get.toNamed('/pesanan')
                  ),
                  _menuItem(
                    'Data Pelanggan',
                    Icons.people,
                    () => Get.toNamed('data-pelanggan'),
                  ),
                  _menuItem(
                    'Stok Bahan',
                    Icons.inventory,
                    () => Get.toNamed('/stok-bahan'),
                  ),
                  _menuItem(
                    'Laporan',
                    Icons.bar_chart,
                    () => Get.toNamed('/reports'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// CARD
  Widget _card({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// STATUS CARD
  Widget _statusCard(String title, int value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(title),
            const SizedBox(height: 8),
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// MENU ITEM
  Widget _menuItem(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30),
            const SizedBox(height: 8),
            Text(title),
          ],
        ),
      ),
    );
  }
}