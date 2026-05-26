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
Future<void> cetakStrukPDF(
  Map<String, dynamic> data,
) async {

  final pdf = pw.Document();

  final tanggal =
      DateFormat(
        'dd MMM yyyy, HH:mm',
      ).format(DateTime.now());

  final estimasi =
      data['estimated_finish'];

  final orderId =
      data['id'] ?? '';

  if (orderId.isEmpty) {

    Get.snackbar(
      'Error',
      'ID pesanan tidak ditemukan',
    );

    return;
  }

  final link =
      'https://laundry-shoes-60205.web.app/#/order/$orderId';

  /// =====================================================
  /// 🔥 HALAMAN 1
  /// =====================================================
  pdf.addPage(

    pw.Page(

      pageFormat:
          PdfPageFormat.a6,

      margin:
          const pw.EdgeInsets.all(18),

      build: (context) {

        return pw.Column(

          crossAxisAlignment:
              pw.CrossAxisAlignment.start,

          children: [

            /// ================= HEADER =================
            pw.Center(

              child: pw.Column(

                children: [

                  pw.Text(
                    'EZA SHOES',

                    style: pw.TextStyle(
                      fontSize: 20,

                      fontWeight:
                          pw.FontWeight.bold,
                    ),
                  ),

                  pw.SizedBox(height: 3),

                  pw.Text(
                    'Laundry Sepatu Premium',

                    style: const pw.TextStyle(
                      fontSize: 10,
                    ),
                  ),

                  pw.SizedBox(height: 2),

                  pw.Text(
                    'Fast Clean • Deep Clean • Repaint',

                    style: const pw.TextStyle(
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 12),

            pw.Divider(),

            /// ================= INFO =================
            _buildRowPdf(
              'Tanggal',
              tanggal,
            ),

            _buildRowPdf(
              'Customer',
              '${data['customer_name']}',
            ),

            _buildRowPdf(
              'Status',
              '${data['status']}',
            ),

            if (estimasi != null)

              _buildRowPdf(
                'Estimasi',

                DateFormat(
                  'dd MMM yyyy',
                ).format(
                  estimasi.toDate(),
                ),
              ),

            pw.Divider(),

            pw.SizedBox(height: 8),

            /// ================= TITLE =================
            pw.Container(

              padding:
                  const pw.EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 8,
              ),

              decoration:
                  pw.BoxDecoration(

                color:
                    PdfColors.blue50,

                borderRadius:
                    pw.BorderRadius.circular(
                  4,
                ),
              ),

              child: pw.Text(

                'DETAIL PESANAN',

                style: pw.TextStyle(
                  fontWeight:
                      pw.FontWeight.bold,

                  fontSize: 11,
                ),
              ),
            ),

            pw.SizedBox(height: 10),

            /// ================= LIST ITEM =================
            ...List.generate(
              data['items'].length,

              (index) {

                final item =
                    data['items'][index];

                return pw.Container(

                  margin:
                      const pw.EdgeInsets.only(
                    bottom: 8,
                  ),

                  padding:
                      const pw.EdgeInsets.all(
                    8,
                  ),

                  decoration:
                      pw.BoxDecoration(

                    border: pw.Border.all(
                      color:
                          PdfColors.grey300,
                    ),

                    borderRadius:
                        pw.BorderRadius.circular(
                      5,
                    ),
                  ),

                  child: pw.Column(

                    crossAxisAlignment:
                        pw.CrossAxisAlignment
                            .start,

                    children: [

                      pw.Text(

                        '${item['shoe_type']}',

                        style: pw.TextStyle(
                          fontWeight:
                              pw.FontWeight.bold,

                          fontSize: 11,
                        ),
                      ),

                      pw.SizedBox(height: 3),

                      pw.Text(
                        'Treatment : ${item['treatment']}',
                        style:
                            const pw.TextStyle(
                          fontSize: 9,
                        ),
                      ),

                      pw.Text(
                        'Estimasi : ${item['duration'] ?? '-'}',

                        style:
                            const pw.TextStyle(
                          fontSize: 9,
                        ),
                      ),

                      pw.SizedBox(height: 5),

                      pw.Row(

                        mainAxisAlignment:
                            pw.MainAxisAlignment
                                .spaceBetween,

                        children: [

                          pw.Text(
                            'Qty : ${item['qty']}',
                            style:
                                const pw.TextStyle(
                              fontSize: 9,
                            ),
                          ),

                          pw.Text(
                            'Rp ${item['total']}',

                            style: pw.TextStyle(
                              fontWeight:
                                  pw.FontWeight
                                      .bold,

                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            pw.Divider(),

            /// ================= SUBTOTAL =================
            _buildRowPdf(
              'Subtotal',
              'Rp ${data['total_price']}',
            ),

            /// ================= DISKON =================
            if (data['discount'] != null &&
                data['discount'] > 0)

              pw.Row(

                mainAxisAlignment:
                    pw.MainAxisAlignment
                        .spaceBetween,

                children: [

                  pw.Text(
                    'Diskon',

                    style: const pw.TextStyle(
                      color: PdfColors.red,
                      fontSize: 10,
                    ),
                  ),

                  pw.Text(
                    '- Rp ${data['discount']}',

                    style: const pw.TextStyle(
                      color: PdfColors.red,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),

            pw.SizedBox(height: 8),

            /// ================= TOTAL =================
            pw.Container(

              padding:
                  const pw.EdgeInsets.all(
                10,
              ),

              decoration:
                  pw.BoxDecoration(

                color:
                    PdfColors.blue100,

                borderRadius:
                    pw.BorderRadius.circular(
                  6,
                ),
              ),

              child: pw.Row(

                mainAxisAlignment:
                    pw.MainAxisAlignment
                        .spaceBetween,

                children: [

                  pw.Text(

                    'TOTAL',

                    style: pw.TextStyle(
                      fontWeight:
                          pw.FontWeight.bold,

                      fontSize: 12,
                    ),
                  ),

                  pw.Text(

                    'Rp ${data['final_price'] ?? data['total_price']}',

                    style: pw.TextStyle(
                      fontWeight:
                          pw.FontWeight.bold,

                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );

  /// =====================================================
  /// 🔥 HALAMAN 2 UNTUK QR
  /// =====================================================
  pdf.addPage(

    pw.Page(

      pageFormat:
          PdfPageFormat.a6,

      margin:
          const pw.EdgeInsets.all(18),

      build: (context) {

        return pw.Center(

          child: pw.Column(

            mainAxisAlignment:
                pw.MainAxisAlignment.center,

            children: [

              pw.Text(
                'SCAN QR UNTUK\nCEK STATUS PESANAN',

                textAlign:
                    pw.TextAlign.center,

                style: pw.TextStyle(
                  fontSize: 14,

                  fontWeight:
                      pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 20),

              pw.BarcodeWidget(

                barcode:
                    pw.Barcode.qrCode(),

                data: link,

                width: 150,
                height: 150,
              ),

              pw.SizedBox(height: 20),

              pw.Text(
                'Eza Shoes Cleaner',

                style: pw.TextStyle(
                  fontWeight:
                      pw.FontWeight.bold,

                  fontSize: 12,
                ),
              ),

              pw.SizedBox(height: 5),

              pw.Text(
                'Terima kasih 🙏',

                style:
                    const pw.TextStyle(
                  fontSize: 10,
                ),
              ),
            ],
          ),
        );
      },
    ),
  );

  await Printing.layoutPdf(

    onLayout: (format) async {

      return pdf.save();
    },
  );
}

/// ================= ROW PDF =================
pw.Widget _buildRowPdf(
  String title,
  String value,
) {

  return pw.Padding(

    padding:
        const pw.EdgeInsets.only(
      bottom: 4,
    ),

    child: pw.Row(

      mainAxisAlignment:
          pw.MainAxisAlignment
              .spaceBetween,

      children: [

        pw.Text(
          title,

          style: const pw.TextStyle(
            fontSize: 9,
          ),
        ),

        pw.Text(
          value,

          style: pw.TextStyle(
            fontWeight:
                pw.FontWeight.bold,

            fontSize: 9,
          ),
        ),
      ],
    ),
  );
}
  /// ================= WHATSAPP =================
Future<void> kirimWhatsApp(
  Map<String, dynamic> data,
) async {

  String phone =
      data['phone'] ?? '';

  if (phone.isEmpty) {

    Get.snackbar(
      'Error',
      'Nomor WA tidak tersedia',
    );

    return;
  }

  /// ================= FORMAT NOMOR =================
  if (phone.startsWith('0')) {

    phone =
        '62${phone.substring(1)}';
  }

  final estimasi =
      data['estimated_finish'];

  final orderId =
      data['id'];

  if (orderId == null ||
      orderId.isEmpty) {

    Get.snackbar(
      'Error',
      'ID pesanan tidak ditemukan',
    );

    return;
  }

  final link =
      'https://laundry-shoes-60205.web.app/#/order/$orderId';

  /// ================= PESAN =================
  String pesan = '';

  pesan +=
      '👟 *EZA SHOES CLEANER*\n';

  pesan +=
      '━━━━━━━━━━━━━━━\n\n';

  pesan +=
      'Halo *${data['customer_name']}* 👋\n\n';

  pesan +=
      'Berikut detail pesanan laundry sepatu Anda:\n\n';

  /// ================= ITEM =================
  for (var item in data['items']) {

    pesan +=
        '📦 *${item['shoe_type']}*\n';

    pesan +=
        '• Treatment : ${item['treatment']}\n';

    pesan +=
        '• Qty : ${item['qty']}\n';

    pesan +=
        '• Estimasi : ${item['duration'] ?? '-'}\n';

    pesan +=
        '• Harga : Rp ${item['total']}\n\n';
  }

  /// ================= ESTIMASI =================
  if (estimasi != null) {

    final tgl =
        DateFormat(
          'dd MMM yyyy',
        ).format(
          estimasi.toDate(),
        );

    pesan +=
        '📅 *Estimasi selesai:* $tgl\n\n';
  }

  pesan +=
      '━━━━━━━━━━━━━━━\n';

  /// ================= SUBTOTAL =================
  pesan +=
      '💰 *Subtotal*\n';

  pesan +=
      'Rp ${data['total_price']}\n\n';

  /// ================= DISKON =================
  if (data['discount'] != null &&
      data['discount'] > 0) {

    pesan +=
        '🏷️ *Diskon (${data['promo_name'] ?? '-'})*\n';

    pesan +=
        '- Rp ${data['discount']}\n\n';
  }

  /// ================= TOTAL =================
  pesan +=
      '🧾 *TOTAL BAYAR*\n';

  pesan +=
      'Rp ${data['final_price'] ?? data['total_price']}\n\n';

  /// ================= STATUS =================
  pesan +=
      '📌 Status : *${data['status']}*\n\n';

  /// ================= LINK =================
  pesan +=
      '🔗 Cek status pesanan:\n';

  pesan +=
      '$link\n\n';

  /// ================= FOOTER =================
  pesan +=
      'Terima kasih telah menggunakan jasa kami 🙏\n\n';

  pesan +=
      '*Eza Shoes Cleaner*';

  final url = Uri.parse(

    'https://wa.me/$phone?text=${Uri.encodeComponent(pesan)}',
  );

  try {

    await launchUrl(

      url,

      mode:
          LaunchMode
              .externalApplication,
    );

  } catch (e) {

    Get.snackbar(
      'Error',
      'Gagal membuka WhatsApp',
    );
  }
}
}