import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/laporan_controller.dart';

class LaporanView extends StatelessWidget {
  const LaporanView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.find<LaporanController>();

    final formatRp =
        NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Laporan Keuangan',
        ),
      ),

      body: RefreshIndicator(
        onRefresh: controller.refreshData,

        child: Obx(() {

          return ListView(
            padding: const EdgeInsets.all(16),

            children: [

              /// ================= FILTER BULAN =================
              DropdownButton<DateTime>(

                value:
                    controller.selectedMonth.value,

                isExpanded: true,

                items: List.generate(12, (index) {

                  final date = DateTime(
                    DateTime.now().year,
                    index + 1,
                  );

                  return DropdownMenuItem(

                    value: date,

                    child: Text(
                      DateFormat(
                        'MMMM yyyy',
                      ).format(date),
                    ),
                  );
                }),

                onChanged: (value) {

                  if (value != null) {

                    controller.changeMonth(
                      value,
                    );
                  }
                },
              ),

              const SizedBox(height: 20),

              /// ================= SUMMARY =================
              const Text(
                'Ringkasan Keuangan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              /// ================= PENDAPATAN =================
              _cardKeuangan(
                title: 'Pendapatan',
                value: formatRp.format(
                  controller.pendapatan.value,
                ),
                color: Colors.green,
                icon: Icons.attach_money,
              ),

              const SizedBox(height: 12),

              /// ================= PENGELUARAN =================
              _cardKeuangan(
                title: 'Pengeluaran',
                value: formatRp.format(
                  controller.pengeluaran.value,
                ),
                color: Colors.red,
                icon: Icons.money_off,
              ),

              const SizedBox(height: 12),

              /// ================= LABA =================
              _cardKeuangan(
                title: 'Laba',
                value: formatRp.format(
                  controller.laba.value,
                ),
                color: Colors.blue,
                icon: Icons.account_balance_wallet,
              ),

              const SizedBox(height: 12),

              /// ================= TOTAL PESANAN =================
              _cardKeuangan(
                title: 'Pesanan Selesai',
                value: controller
                    .totalPesanan.value
                    .toString(),
                color: Colors.orange,
                icon: Icons.receipt_long,
              ),

              const SizedBox(height: 24),

              /// ================= TRANSAKSI =================
              const Text(
                'Transaksi Selesai',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              if (controller.orders.isEmpty)
                const Text(
                  'Belum ada transaksi',
                ),

              ...controller.orders.map((order) {

                final total =
                    order['final_price']
                    ??
                    order['total_price']
                    ??
                    0;

                return Card(
                  child: ListTile(

                    leading: const CircleAvatar(
                      child: Icon(Icons.receipt),
                    ),

                    title: Text(
                      order['customer_name']
                      ?? '-',
                    ),

                    subtitle: Text(
                      DateFormat(
                        'dd MMM yyyy',
                      ).format(
                        (order['created_at']
                                as Timestamp)
                            .toDate(),
                      ),
                    ),

                    trailing: Text(
                      formatRp.format(total),

                      style: const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 24),

              /// ================= PENGELUARAN =================
              const Text(
                'Pengeluaran Bahan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              if (controller.purchases.isEmpty)
                const Text(
                  'Belum ada pengeluaran',
                ),

              ...controller.purchases.map((item) {

                return Card(
                  child: ListTile(

                    leading: const CircleAvatar(
                      backgroundColor:
                          Colors.red,

                      child: Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                    ),

                    title: Text(
                      item['material_name']
                      ?? '-',
                    ),

                    subtitle: Text(
                      '${item['qty']} ${item['unit']}',
                    ),

                    trailing: Text(
                      formatRp.format(
                        item['price'] ?? 0,
                      ),

                      style: const TextStyle(
                        fontWeight:
                            FontWeight.bold,

                        color: Colors.red,
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        }),
      ),
    );
  }

  /// ================= CARD =================
  Widget _cardKeuangan({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: color,
        borderRadius:
            BorderRadius.circular(16),
      ),

      child: Row(
        children: [

          CircleAvatar(
            backgroundColor:
                Colors.white,

            child: Icon(
              icon,
              color: color,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}