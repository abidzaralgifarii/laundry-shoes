import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() =>
      _SplashViewState();
}

class _SplashViewState
    extends State<SplashView> {

  @override
  void initState() {
    super.initState();

    /// ================= DELAY 2 DETIK =================
    Timer(
      const Duration(seconds: 2),

      () {

        /// ================= CEK LOGIN =================
        final auth =
            FirebaseAuth.instance;

        /// ================= SUDAH LOGIN =================
        if (auth.currentUser != null) {

          Get.offAllNamed(
            '/dashboard',
          );

        }

        /// ================= BELUM LOGIN =================
        else {

          Get.offAllNamed(
            '/auth',
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFF2196F3),

      body: Center(

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            /// ================= LOGO =================
            Image.asset(
              'assets/images/logo.png',

              width: 260,
            ),

            const SizedBox(height: 5),

            /// ================= TITLE =================
            const Text(
              'EZA SHOES CLEANER',

              style: TextStyle(
                color: Colors.white,

                fontSize: 24,

                fontWeight:
                    FontWeight.bold,

                letterSpacing: 1.5,
              ),
            ),

            const SizedBox(height: 8),

            /// ================= SUBTITLE =================
            Text(
              'Professional Shoes & Bag Care',

              style: TextStyle(
                color:
                    Colors.white.withOpacity(0.8),

                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}