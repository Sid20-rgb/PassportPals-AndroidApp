import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/common/snackbar/my_snackbar.dart';
import '../../domain/entity/user_entity.dart';
import '../viewmodel/auth_view_model.dart';

class SignUp extends ConsumerStatefulWidget {
  const SignUp({super.key});

  @override
  ConsumerState<SignUp> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: '');
  final _emailController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Image.network(
                "https://travellersworldwide.com/wp-content/uploads/2022/06/shutterstock_267670718.jpg.webp",
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              Positioned(
                top: 50,
                left: 0,
                right: 0,
                child: SizedBox(
                  width: 300,
                  height: 150,
                  child: Image.asset('assets/images/logo.png'),
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
              Positioned.fill(
                top: 60,
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
                                    "Get Started",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40.33,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Center(
                                  child: Text(
                                    "Travel Far, Blog Wide",
                                    style: TextStyle(
                                      color: Color(0xffa3a3a3),
                                      fontSize: 14.33,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Opacity(
                                  opacity: 0.28,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      errorStyle: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight
                                              .bold // Change error text color here
                                          ),
                                      prefixIcon: const Icon(Icons.person),
                                      hintText: 'Username',
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
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a username';
                                      }
                                      return null;
                                    },
                                    controller: _usernameController,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Opacity(
                                  opacity: 0.28,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      errorStyle: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight
                                              .bold // Change error text color here
                                          ),
                                      prefixIcon: const Icon(Icons.email),
                                      hintText: 'Email',
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
                                        return 'Please enter an email';
                                      }
                                      // You can add more email validation here if needed
                                      return null;
                                    },
                                    controller: _emailController,
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
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _isPasswordVisible =
                                                !_isPasswordVisible;
                                          });
                                        },
                                        child: Icon(
                                          _isPasswordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      hintText: 'Password',
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      labelStyle: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    obscureText: !_isPasswordVisible,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter a password';
                                      }

                                      // You can add more password validation here if needed
                                      return null;
                                    },
                                    controller: _passwordController,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Opacity(
                                //   opacity: 0.28,
                                //   child: TextFormField(
                                //     decoration: InputDecoration(
                                //       errorStyle: const TextStyle(
                                //           color: Colors.white,
                                //           fontWeight: FontWeight
                                //               .bold // Change error text color here
                                //           ),
                                //       prefixIcon: const Icon(Icons.lock),
                                //       hintText: 'Confirm Password',
                                //       filled: true,
                                //       fillColor: Colors.grey[200],
                                //       border: OutlineInputBorder(
                                //         borderRadius: BorderRadius.circular(16),
                                //       ),
                                //       labelStyle: const TextStyle(
                                //         color: Colors.black,
                                //       ),
                                //     ),
                                //     obscureText: true,
                                //     validator: (value) {
                                //       if (value!.isEmpty) {
                                //         return 'Please confirm your password';
                                //       }
                                //       if (value != _passwordController.text) {
                                //         return 'Passwords do not match';
                                //       }
                                //       // Add password confirmation validation here if needed
                                //       return null;
                                //     },
                                //   ),
                                // ),
                                const SizedBox(height: 25),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      // Perform sign-up logic here
                                      // Navigator.pushNamed(context, '/login');
                                      var user = UserEntity(
                                        username: _usernameController.text,
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      );

                                      ref
                                          .read(authViewModelProvider.notifier)
                                          .registerUser(user);

                                      if (authState.error != null) {
                                        showSnackBar(
                                          message: authState.error.toString(),
                                          context: context,
                                          color: Colors.red,
                                        );
                                      } else {
                                        showSnackBar(
                                          message: 'Registered successfully',
                                          context: context,
                                        );
                                        // Navigator.pushNamed(context, '/login');
                                      }
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setString(
                                          'email', _emailController.text);
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
                                    "Sign Up",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17.92,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 25),

                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color: Color(0xffd9d9d9),
                                        thickness: 1,
                                        endIndent: 8,
                                      ),
                                    ),
                                    Text(
                                      "Already have an account?",
                                      style: TextStyle(
                                        color: Color(0xffa3a3a3),
                                        fontSize: 12,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: Color(0xffd9d9d9),
                                        thickness: 1,
                                        indent: 8,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 25),

                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/login');
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
                                    "LogIn",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17.92,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
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
