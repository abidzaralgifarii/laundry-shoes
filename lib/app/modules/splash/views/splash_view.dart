import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    redirectToLogin();
  }

  Future<void> redirectToLogin() async {
    // Menampilkan splash selama 2 detik
    await Future.delayed(
      const Duration(seconds: 2),
    );

    // Pengguna wajib login ulang setiap aplikasi dibuka
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    // Masuk ke halaman login
    Get.offAllNamed('/auth');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2196F3),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logos.png',
              width: 260,
            ),
            const SizedBox(height: 5),
            const Text(
              'EZA SHOES CLEANER',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Professional Shoes & Bag Care',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}