import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {

    final controller =
        Get.find<AuthController>();

    return Scaffold(

      backgroundColor:
          const Color(0xFF2196F3),

      body: Center(

        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(24),

          child: Container(

            padding:
                const EdgeInsets.all(24),

            decoration: BoxDecoration(

              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(24),

              boxShadow: [

                BoxShadow(
                  color:
                      Colors.black.withOpacity(0.1),

                  blurRadius: 15,

                  offset:
                      const Offset(0, 5),
                ),
              ],
            ),

            child: Column(
              mainAxisSize:
                  MainAxisSize.min,

              children: [

                /// ================= ICON =================
                const Icon(
                  Icons.cleaning_services,

                  size: 80,

                  color: Color(0xFF2196F3),
                ),

                const SizedBox(height: 20),

                /// ================= TITLE =================
                const Text(
                  'EZA SHOES CLEANER',

                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 24,

                    fontWeight:
                        FontWeight.bold,

                    color: Color(0xFF2196F3),

                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 8),

                /// ================= SUBTITLE =================
                Text(
                  'Professional Shoes Care',

                  style: TextStyle(
                    color: Colors.grey[600],

                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 32),

                /// ================= NICKNAME =================
                TextField(

                  controller:
                      controller.nicknameC,

                  decoration:
                      InputDecoration(

                    labelText:
                        'Nickname',

                    filled: true,

                    fillColor:
                        Colors.grey[100],

                    border:
                        OutlineInputBorder(

                      borderRadius:
                          BorderRadius.circular(14),

                      borderSide:
                          BorderSide.none,
                    ),

                    prefixIcon:
                        const Icon(
                      Icons.person,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// ================= PASSWORD =================
                TextField(

                  controller:
                      controller.passwordC,

                  obscureText: true,

                  decoration:
                      InputDecoration(

                    labelText:
                        'Password',

                    filled: true,

                    fillColor:
                        Colors.grey[100],

                    border:
                        OutlineInputBorder(

                      borderRadius:
                          BorderRadius.circular(14),

                      borderSide:
                          BorderSide.none,
                    ),

                    prefixIcon:
                        const Icon(
                      Icons.lock,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// ================= BUTTON =================
                SizedBox(

                  width: double.infinity,

                  height: 55,

                  child: Obx(() {

                    return ElevatedButton(

                      style:
                          ElevatedButton.styleFrom(

                        backgroundColor:
                            const Color(0xFF2196F3),

                        shape:
                            RoundedRectangleBorder(

                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                      ),

                      onPressed:
                          controller.isLoading.value

                              ? null

                              : controller.login,

                      child:

                          controller.isLoading.value

                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )

                              : const Text(
                                  'LOGIN',

                                  style: TextStyle(
                                    fontSize: 16,

                                    color: Colors.white,

                                    fontWeight:
                                        FontWeight.bold,

                                    letterSpacing: 1,
                                  ),
                                ),
                    );
                  }),
                ),

                const SizedBox(height: 20),

                /// ================= FOOTER =================
                Text(
                  'Developed by Abidzar Algifari',

                  style: TextStyle(
                    color: Colors.grey[500],

                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}