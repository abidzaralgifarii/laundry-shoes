import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_sepatu/app/modules/Dashboard/controllers/dashboard_controller.dart';
import 'package:laundry_sepatu/app/modules/auth/controllers/auth_controller.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    final authC = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Colors.grey[100],

      /// ================= APPBAR =================
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xFF2196F3),
        automaticallyImplyLeading: false,
        title: const Text(
          'Eza Shoes',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          /// ================= LOGOUT =================
          Padding(
            padding: const EdgeInsets.only(
              right: 12,
            ),
            child: GestureDetector(
              onTap: () {
                _showLogoutConfirmation(authC);
              },
              child: Container(
                padding: const EdgeInsets.all(
                  10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(
                    12,
                  ),
                ),
                child: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
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
              const SizedBox(height: 5),

              /// ================= CARD DASHBOARD =================
              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: _card(
                        title: 'Total Pesanan',
                        value: controller.totalOrders.value.toString(),
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: _card(
                        title: 'Hari Ini',
                        value: 'Rp ${controller.totalIncomeToday.value}',
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: _card(
                        title: 'Bulan Ini',
                        value: 'Rp ${controller.totalIncomeMonth.value}',
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: _card(
                        title: 'Selesai',
                        value: controller.selesai.value.toString(),
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// ================= STATUS =================
              const Text(
                'Status Pesanan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 12),

              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: _statusCard(
                        'Diterima',
                        controller.diterima.value,
                        Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: _statusCard(
                        'Diproses',
                        controller.diproses.value,
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: _statusCard(
                        'Selesai',
                        controller.selesai.value,
                        Colors.green,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// ================= MENU CEPAT =================
              const Text(
                'Menu Cepat',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 12),

              /// ================= GRID MENU =================
              Obx(
                () {
                  return GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      /// ================= TAMBAH PESANAN =================
                      _menuItem(
                        'Tambah Pesanan',
                        Icons.add,
                        () => Get.toNamed(
                          '/pesanan',
                        ),
                      ),

                      /// ================= DATA PELANGGAN =================
                      _menuItem(
                        'Data Pelanggan',
                        Icons.people,
                        () => Get.toNamed(
                          '/data-pelanggan',
                        ),
                      ),

                      /// ================= STOK =================
                      _menuItem(
                        'Stok Bahan',
                        Icons.inventory,
                        () => Get.toNamed(
                          '/stok-bahan',
                        ),
                      ),

                      /// ================= OWNER ONLY =================
                      if (authC.role.value == 'owner')
                        _menuItem(
                          'Laporan',
                          Icons.bar_chart,
                          () => Get.toNamed(
                            '/laporan',
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= KONFIRMASI LOGOUT =================
  void _showLogoutConfirmation(AuthController authC) {
    Get.defaultDialog(
      title: 'Konfirmasi Logout',
      titleStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      middleText: 'Apakah Anda yakin ingin keluar dari aplikasi?',
      radius: 16,
      barrierDismissible: false,
      textCancel: 'Batal',
      textConfirm: 'Logout',
      cancelTextColor: Colors.grey[700],
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF2196F3),
      onConfirm: () async {
        Get.back();

        await authC.logout();
      },
    );
  }

  /// ================= CARD =================
  Widget _card({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(
          20,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(
              0,
              5,
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// ================= STATUS CARD =================
  Widget _statusCard(
    String title,
    int value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          18,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(
              0.1,
            ),
            blurRadius: 8,
            offset: const Offset(
              0,
              4,
            ),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// ================= MENU ITEM =================
  Widget _menuItem(
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            20,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(
                0.1,
              ),
              blurRadius: 10,
              offset: const Offset(
                0,
                5,
              ),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(
                14,
              ),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(
                  0.1,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 28,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}