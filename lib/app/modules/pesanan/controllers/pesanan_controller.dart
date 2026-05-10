import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart'; // 🔥 wajib untuk warna
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class PesananController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ================= STREAM =================
  Stream<List<Map<String, dynamic>>> getPesanan() {
    return _firestore
        .collection('orders')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  /// ================= UPDATE =================
  Future<void> updateStatus(
  String id,
  String status,
) async {

  try {

    final orderRef =
        _firestore.collection('orders').doc(id);

    final orderSnapshot =
        await orderRef.get();

    final orderData =
        orderSnapshot.data();

    if (orderData == null) return;

    /// ================= UPDATE STATUS =================
    await orderRef.update({
      'status': status,
    });

    /// ================= AUTO CUT STOCK =================
    if (status == 'Diproses' &&
        orderData['stock_cut'] != true) {

      final items =
          orderData['items'] as List<dynamic>;

      /// ================= LOOP ITEM =================
      for (var item in items) {

        final treatmentName =
            item['treatment'];

        final qtyOrder =
            (item['qty'] ?? 1) as int;

        /// ================= AMBIL TREATMENT =================
        final treatmentSnapshot =
            await _firestore
                .collection('treatments')
                .where(
                  'name',
                  isEqualTo: treatmentName,
                )
                .get();

        if (treatmentSnapshot.docs.isEmpty) {
          continue;
        }

        final treatmentData =
            treatmentSnapshot.docs.first.data();

        /// ================= CEK MATERIAL =================
        if (!treatmentData.containsKey('materials')) {
          continue;
        }

        final materials =
            treatmentData['materials'];

        if (materials == null) {
          continue;
        }

        /// ================= LOOP MATERIAL =================
        for (var material in materials) {

          final materialName =
              material['name'];

          final materialQty =
              (material['qty'] ?? 0) as int;

          final totalCut =
              (materialQty * qtyOrder).toInt();

          /// ================= CARI MATERIAL =================
          final materialSnapshot =
              await _firestore
                  .collection('materials')
                  .where(
                    'name',
                    isEqualTo: materialName,
                  )
                  .get();

          if (materialSnapshot.docs.isEmpty) {
            continue;
          }

          final materialDoc =
              materialSnapshot.docs.first;

          final materialData =
              materialDoc.data();

          final currentStock =
              (materialData['stock'] ?? 0) as int;

          /// ================= UPDATE STOCK =================
          await _firestore
              .collection('materials')
              .doc(materialDoc.id)
              .update({

            'stock':
                currentStock - totalCut,
          });
        }
      }

      /// ================= ANTI DOUBLE CUT =================
      await orderRef.update({
        'stock_cut': true,
      });
    }

    Get.snackbar(
      'Sukses',
      'Status berhasil diupdate',
    );

  } catch (e) {

    Get.snackbar(
      'Error',
      e.toString(),
    );
  }
}

  Future<void> deletePesanan(String id) async {
    await _firestore.collection('orders').doc(id).delete();
  }

  /// ================= PDF =================
  Future<void> cetakStrukPDF(Map<String, dynamic> data) async {
    final pdf = pw.Document();

    final tanggal =
        DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now());

    final estimasi = data['estimated_finish'];
    final orderId = data['id'] ?? '';

    if (orderId.isEmpty) {
      Get.snackbar('Error', 'ID pesanan tidak ditemukan');
      return;
    }

    final link =
        'https://laundry-shoes-60205.web.app/#/order/$orderId';

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              /// HEADER
              pw.Center(
                child: pw.Text(
                  'Eza Shoes',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),

              pw.SizedBox(height: 4),
              pw.Center(child: pw.Text('Laundry Sepatu')),
              pw.SizedBox(height: 10),

              pw.Text('Tanggal : $tanggal'),
              pw.Text('Customer : ${data['customer_name']}'),

              if (estimasi != null)
                pw.Text(
                  'Estimasi selesai: ${DateFormat('dd MMM yyyy').format(estimasi.toDate())}',
                ),

              pw.Divider(),

              /// LIST ITEM
              ...List.generate(data['items'].length, (index) {
                final item = data['items'][index];

                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 6),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        '${item['shoe_type']} - ${item['treatment']}',
                      ),
                      pw.Text(
                        'Estimasi: ${item['duration'] ?? '-'}',
                        style: pw.TextStyle(fontSize: 10),
                      ),
                      pw.Row(
                        mainAxisAlignment:
                            pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('x${item['qty']}'),
                          pw.Text('Rp ${item['total']}'),
                        ],
                      ),
                    ],
                  ),
                );
              }),

              pw.Divider(),

              /// 🔥 SUBTOTAL
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Subtotal'),
                  pw.Text('Rp ${data['total_price']}'),
                ],
              ),

              /// 🔥 DISKON
              if (data['discount'] != null && data['discount'] > 0)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Diskon (${data['promo_name'] ?? '-'})',
                      style: pw.TextStyle(color: PdfColors.red),
                    ),
                    pw.Text(
                      '- Rp ${data['discount']}',
                      style: pw.TextStyle(color: PdfColors.red),
                    ),
                  ],
                ),

              pw.Divider(),

              /// 🔥 TOTAL AKHIR
              pw.Row(
                mainAxisAlignment:
                    pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'TOTAL BAYAR',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    'Rp ${data['final_price'] ?? data['total_price']}',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),

              pw.SizedBox(height: 8),
              pw.Text('Status: ${data['status']}'),

              pw.SizedBox(height: 20),

              /// QR
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.BarcodeWidget(
                      barcode: pw.Barcode.qrCode(),
                      data: link,
                      width: 100,
                      height: 100,
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      'Scan untuk cek status pesanan',
                      style: pw.TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              pw.Center(
                child: pw.Text('Terima kasih 🙏'),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  /// ================= WHATSAPP =================
  Future<void> kirimWhatsApp(Map<String, dynamic> data) async {
    String phone = data['phone'] ?? '';

    if (phone.isEmpty) {
      Get.snackbar('Error', 'Nomor WA tidak tersedia');
      return;
    }

    if (phone.startsWith('0')) {
      phone = '62${phone.substring(1)}';
    }

    final estimasi = data['estimated_finish'];
    final orderId = data['id'];

    if (orderId == null || orderId.isEmpty) {
      Get.snackbar('Error', 'ID pesanan tidak ditemukan');
      return;
    }

    final link =
        'https://laundry-shoes-60205.web.app/#/order/$orderId';

    String pesan = 'Halo ${data['customer_name']}\n\n';
    pesan += 'Berikut pesanan Anda:\n\n';

    for (var item in data['items']) {
      pesan += '- ${item['shoe_type']} (${item['treatment']})\n';
      pesan += '  Estimasi: ${item['duration'] ?? '-'}\n';
      pesan += '  x${item['qty']} = Rp ${item['total']}\n\n';
    }

    if (estimasi != null) {
      final tgl =
          DateFormat('dd MMM yyyy').format(estimasi.toDate());
      pesan += 'Estimasi selesai: $tgl\n';
    }

    /// 🔥 PROMO
    pesan += '\nSubtotal: Rp ${data['total_price']}';

    if (data['discount'] != null && data['discount'] > 0) {
      pesan +=
          '\nDiskon (${data['promo_name'] ?? '-'}) : -Rp ${data['discount']}';
    }

    pesan +=
        '\nTotal Bayar: Rp ${data['final_price'] ?? data['total_price']}';

    pesan += '\nStatus: ${data['status']}';

    pesan += '\n\n🔗 Cek status pesanan:\n$link';

    final url = Uri.parse(
      'https://wa.me/$phone?text=${Uri.encodeComponent(pesan)}',
    );

    try {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      Get.snackbar('Error', 'Gagal membuka WhatsApp');
    }
  }
}