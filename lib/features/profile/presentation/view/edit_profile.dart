import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodel/profile_view_model.dart';

class EditProfiles extends ConsumerStatefulWidget {
  const EditProfiles({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfilesState();
}

class _EditProfilesState extends ConsumerState<EditProfiles> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileViewModelProvider);

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
                                    "Edit Profile",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40.33,
                                      // fontFamily: "Poppins",
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: 300,
                                  height: 150,
                                  child: Image.asset('assets/images/logo.png'),
                                ),
                                const SizedBox(height: 10),
                                Opacity(
                                  opacity: 0.28,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      errorStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      prefixIcon: const Icon(Icons.person),
                                      hintText:
                                          profileState.profiles[0].username,
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
                                        return 'Please enter new username';
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
                                        fontWeight: FontWeight.bold,
                                      ),
                                      prefixIcon: const Icon(Icons.mail),
                                      hintText: profileState.profiles[0].email,
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
                                        return 'Please enter new email';
                                      }

                                      // You can add more password validation here if needed
                                      return null;
                                    },
                                    controller: _emailController,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const SizedBox(height: 50),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      ref
                                          .read(
                                              profileViewModelProvider.notifier)
                                          .editProfile(_usernameController.text,
                                              _emailController.text, context);

                                      ref
                                          .watch(
                                              profileViewModelProvider.notifier)
                                          .getAllProfile();

                                      _usernameController.clear();
                                      _emailController.clear();
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
                                    "Confirm",
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
