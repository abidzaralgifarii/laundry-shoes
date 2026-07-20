import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TambahPesananController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final sepatuC = TextEditingController();
  final qtyC = TextEditingController();

  var total = 0.obs;
  var totalSemua = 0.obs;

  /// ================= CUSTOMER =================
  var customerList = <Map<String, dynamic>>[].obs;
  var selectedCustomer = Rxn<Map<String, dynamic>>();

  /// ================= TREATMENT =================
  var treatmentList = <Map<String, dynamic>>[].obs;
  var selectedTreatment = Rxn<Map<String, dynamic>>();

  /// ================= PROMO =================
  var promoList = <Map<String, dynamic>>[].obs;
  var selectedPromo = Rxn<Map<String, dynamic>>();
  var discount = 0.obs;

  /// ================= ITEM =================
  var items = <Map<String, dynamic>>[].obs;

  /// ================= GET DATA =================
  Future<void> getTreatments() async {
    final snapshot = await _firestore.collection('treatments').get();

    treatmentList.value = snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  Future<void> getCustomers() async {
    final snapshot = await _firestore.collection('customers').get();

    customerList.value = snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  Future<void> getPromos() async {
    final snapshot = await _firestore.collection('promos').get();

    promoList.value = snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  /// ================= LOGIC =================
  void pilihTreatment(Map<String, dynamic> data) {
    selectedTreatment.value = data;
    hitungTotal();
  }

  void hitungTotal() {
    final qty = int.tryParse(qtyC.text.trim()) ?? 0;
    final harga = (selectedTreatment.value?['price'] ?? 0) as int;

    total.value = qty * harga;
  }

  void tambahItem() {
    if (sepatuC.text.trim().isEmpty) {
      Get.snackbar('Validasi', 'Jenis sepatu wajib diisi');
      return;
    }

    if (selectedTreatment.value == null) {
      Get.snackbar('Validasi', 'Pilih treatment dulu');
      return;
    }

    final qty = int.tryParse(qtyC.text.trim());
    if (qty == null || qty <= 0) {
      Get.snackbar('Validasi', 'Qty harus lebih dari 0');
      return;
    }

    final harga = (selectedTreatment.value?['price'] ?? 0) as int;
    final totalItem = qty * harga;

    items.add({
      'shoe_type': sepatuC.text.trim(),
      'treatment': selectedTreatment.value?['name'],
      'price': harga,
      'duration': selectedTreatment.value?['duration'],
      'qty': qty,
      'total': totalItem,
    });

    hitungTotalSemua();

    sepatuC.clear();
    qtyC.clear();
    selectedTreatment.value = null;
    total.value = 0;
  }

  void hapusItem(int index) {
    items.removeAt(index);
    hitungTotalSemua();
  }

  void hitungTotalSemua() {
    int sum = 0;

    for (var item in items) {
      sum += item['total'] as int;
    }

    totalSemua.value = sum;

    hitungDiskon();
  }

  /// ================= EDIT TREATMENT =================
  void editTreatment(Map<String, dynamic> treatment) {
    final nameC = TextEditingController(
      text: treatment['name']?.toString() ?? '',
    );

    final priceC = TextEditingController(
      text: treatment['price']?.toString() ?? '0',
    );

    final durationC = TextEditingController(
      text: treatment['duration']?.toString() ?? '',
    );

    Get.defaultDialog(
      title: 'Edit Treatment',
      content: Column(
        children: [
          TextField(
            controller: nameC,
            decoration: const InputDecoration(
              labelText: 'Nama Treatment',
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: priceC,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Harga',
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: durationC,
            decoration: const InputDecoration(
              labelText: 'Durasi',
            ),
          ),
        ],
      ),
      textCancel: 'Batal',
      textConfirm: 'Simpan',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        final id = treatment['id'];

        if (id == null) {
          Get.snackbar('Error', 'ID treatment tidak ditemukan');
          return;
        }

        if (nameC.text.trim().isEmpty) {
          Get.snackbar('Validasi', 'Nama treatment wajib diisi');
          return;
        }

        await _firestore.collection('treatments').doc(id).update({
          'name': nameC.text.trim(),
          'price': int.tryParse(priceC.text.trim()) ?? 0,
          'duration': durationC.text.trim(),
        });

        Get.back();

        await getTreatments();

        final updatedTreatment = {
          ...treatment,
          'name': nameC.text.trim(),
          'price': int.tryParse(priceC.text.trim()) ?? 0,
          'duration': durationC.text.trim(),
        };

        if (selectedTreatment.value?['id'] == id) {
          selectedTreatment.value = updatedTreatment;
          hitungTotal();
        }

        Get.snackbar(
          'Sukses',
          'Treatment berhasil diperbarui',
        );
      },
    );
  }

  /// ================= HAPUS TREATMENT =================
  void confirmDeleteTreatment(Map<String, dynamic> treatment) {
    Get.defaultDialog(
      title: 'Hapus Treatment',
      middleText: 'Apakah Anda yakin ingin menghapus treatment ini?',
      textCancel: 'Batal',
      textConfirm: 'Hapus',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        final id = treatment['id'];

        if (id == null) {
          Get.snackbar('Error', 'ID treatment tidak ditemukan');
          return;
        }

        await _firestore.collection('treatments').doc(id).delete();

        if (selectedTreatment.value?['id'] == id) {
          selectedTreatment.value = null;
          total.value = 0;
        }

        await getTreatments();

        Get.back();

        Get.snackbar(
          'Sukses',
          'Treatment berhasil dihapus',
        );
      },
    );
  }

  /// ================= PROMO =================
  void hitungDiskon() {
    final totalAwal = totalSemua.value;

    if (selectedPromo.value == null) {
      discount.value = 0;
      return;
    }

    final promo = selectedPromo.value!;
    final type = promo['type'];
    final value = promo['value'];

    if (type == 'percent') {
      discount.value = (totalAwal * value / 100).toInt();
    } else {
      discount.value = value;
    }
  }

  int get totalAkhir => totalSemua.value - discount.value;

  /// ================= ESTIMASI =================
  DateTime hitungEstimasiSelesai(List items) {
    int maxDays = 0;

    for (var item in items) {
      final durasi = (item['duration'] ?? '').toString().toLowerCase();

      final angka =
          int.tryParse(durasi.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

      if (angka > maxDays) {
        maxDays = angka;
      }
    }

    return DateTime.now().add(Duration(days: maxDays));
  }

  /// ================= SIMPAN =================
  Future<void> simpanPesanan() async {
    if (selectedCustomer.value == null) {
      Get.snackbar('Validasi', 'Pilih pelanggan dulu');
      return;
    }

    if (items.isEmpty) {
      Get.snackbar('Validasi', 'Tambahkan minimal 1 item pesanan');
      return;
    }

    try {
      final estimasi = hitungEstimasiSelesai(items);

      await _firestore.collection('orders').add({
        'customer_name': selectedCustomer.value?['name'],
        'phone': selectedCustomer.value?['phone'],
        'items': items.toList(),
        'total_price': totalSemua.value,
        'discount': discount.value,
        'final_price': totalAkhir,
        'promo_name': selectedPromo.value?['name'],
        'status': 'Diterima',
        'stock_cut': false,
        'created_at': Timestamp.now(),
        'estimated_finish': Timestamp.fromDate(estimasi),
      });

      Get.back();
      Get.snackbar('Sukses', 'Pesanan berhasil ditambahkan');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  /// ================= INIT =================
  @override
  void onInit() {
    super.onInit();
    getTreatments();
    getCustomers();
    getPromos();
  }

  @override
  void onClose() {
    sepatuC.dispose();
    qtyC.dispose();
    super.onClose();
  }
}