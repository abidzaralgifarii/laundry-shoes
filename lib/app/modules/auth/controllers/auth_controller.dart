import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  /// ================= CONTROLLER =================
  final nicknameC =
      TextEditingController();

  final passwordC =
      TextEditingController();

  /// ================= USER =================
  var role = ''.obs;

  var nickname = ''.obs;

  var isLoading = false.obs;

  /// ================= LOGIN =================
  Future<void> login() async {

    if (nicknameC.text.trim().isEmpty ||
        passwordC.text.trim().isEmpty) {

      Get.snackbar(
        'Validasi',
        'Nickname & password wajib diisi',
      );

      return;
    }

    try {

      isLoading.value = true;

      /// ================= CARI USER =================
      final userSnapshot =
          await _firestore
              .collection('users')
              .where(
                'nickname',
                isEqualTo:
                    nicknameC.text.trim(),
              )
              .limit(1)
              .get();

      /// ================= USER TIDAK ADA =================
      if (userSnapshot.docs.isEmpty) {

        Get.snackbar(
          'Error',
          'Nickname tidak ditemukan',
        );

        isLoading.value = false;

        return;
      }

      final userData =
          userSnapshot.docs.first.data();

      final email =
          userData['email'];

      /// ================= LOGIN FIREBASE =================
      await _auth
          .signInWithEmailAndPassword(

        email: email,

        password:
            passwordC.text.trim(),
      );

      /// ================= SIMPAN USER =================
      role.value =
          userData['role'];

      nickname.value =
          userData['nickname'];

      /// ================= CLEAR =================
      nicknameC.clear();

      passwordC.clear();

      /// ================= SUCCESS =================
      Get.offAllNamed('/dashboard');

      Get.snackbar(
        'Sukses',
        'Login berhasil',
      );

    } on FirebaseAuthException catch (e) {

      String message =
          'Login gagal';

      if (e.code == 'wrong-password') {

        message =
            'Password salah';
      }

      if (e.code == 'invalid-credential') {

        message =
            'Password salah';
      }

      Get.snackbar(
        'Error',
        message,
      );

    } catch (e) {

      Get.snackbar(
        'Error',
        e.toString(),
      );

    } finally {

      isLoading.value = false;
    }
  }

  /// ================= LOGOUT =================
  Future<void> logout() async {

    await _auth.signOut();

    Get.offAllNamed('/auth');
  }

  /// ================= CHECK LOGIN =================
  // @override
  // void onInit() {
  //   super.onInit();

  //   final user =
  //       _auth.currentUser;

  //   if (user != null) {

  //     Get.offAllNamed(
  //       '/dashboard',
  //     );
  //   }
  // }

  /// ================= DISPOSE =================
  @override
  void onClose() {

    nicknameC.dispose();

    passwordC.dispose();

    super.onClose();
  }
}