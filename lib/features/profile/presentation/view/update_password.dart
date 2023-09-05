import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/password_entity.dart';
import '../viewmodel/password_viewmodel.dart';

class UpdatePassword extends ConsumerStatefulWidget {
  const UpdatePassword({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends ConsumerState<UpdatePassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController changePasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: Image.network(
                  "https://travellersworldwide.com/wp-content/uploads/2022/06/shutterstock_267670718.jpg.webp",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Transform.rotate(
                  angle: -0.59,
                  child: Container(
                    width: 185,
                    height: 158,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(79),
                    ),
                    child: const FlutterLogo(size: 158),
                  ),
                ),
              ),

              // Blurred Container

              Positioned(
                top: 60,
                left: 0,
                right: 0,
                bottom: 0,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Opacity(
                      opacity: 0.78,
                      child: Container(
                        height: size.height,
                        decoration: const BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment.bottomLeft,
                            radius: 0.5,
                            colors: [
                              Color(0xFF5AB5D1),
                              Color(0xFF272727),
                            ],
                            stops: [0.0, 0.0],
                          ),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40),
                            topLeft: Radius.circular(40),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 40,
                        ),
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Center(
                                  child: Text(
                                    "Update Password",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40.33,
                                      // fontFamily: "Poppins",
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: 200,
                                  height: 100,
                                  child: Image.asset('assets/images/logo.png'),
                                ),
                                const SizedBox(height: 10),
                                Opacity(
                                  opacity: 0.28,
                                  child: TextFormField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      errorStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      prefixIcon: const Icon(Icons.lock),
                                      hintText: 'Current Password',
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      labelStyle: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter current password';
                                      }
                                      return null;
                                    },
                                    controller: currentPasswordController,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Opacity(
                                  opacity: 0.28,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      errorStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      prefixIcon: const Icon(Icons.lock),
                                      hintText: 'New Password',
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      labelStyle: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    obscureText: true,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter new password';
                                      }

                                      // You can add more password validation here if needed
                                      return null;
                                    },
                                    controller: newPasswordController,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Opacity(
                                  opacity: 0.28,
                                  child: TextFormField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      errorStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      prefixIcon: const Icon(Icons.lock),
                                      hintText: 'New Password Again',
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      labelStyle: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter new password again';
                                      }
                                      return null;
                                    },
                                    controller: changePasswordController,
                                  ),
                                ),
                                const SizedBox(height: 25),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      ref
                                          .read(passwordViewModelProvider
                                              .notifier)
                                          .changePassword(
                                            PasswordEntity(
                                              oldPassword:
                                                  currentPasswordController
                                                      .text,
                                              newPassword:
                                                  newPasswordController.text,
                                              confirmPassword:
                                                  changePasswordController.text,
                                            ),
                                            context,
                                          );

                                      currentPasswordController.clear();
                                      newPasswordController.clear();
                                      changePasswordController.clear();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff5ab5d1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 50,
                                      vertical: 11,
                                    ),
                                  ),
                                  child: const Text(
                                    "Update",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17.92,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const SizedBox(height: 15),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
