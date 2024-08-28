// import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:homecareapp/components/button.dart';
import 'package:homecareapp/main.dart';
import 'package:homecareapp/models/auth_model.dart';
import 'package:homecareapp/providers/dio_provider.dart';
import 'package:provider/provider.dart';

import '../utils/config.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool obsecurePass = true;
  String? errorMessage; // State untuk pesan kesalahan

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            keyboardType: TextInputType.text,
            cursorColor: const Color.fromRGBO(116, 225, 225, 1),
            decoration: const InputDecoration(
              hintText: 'Username',
              labelText: 'Username',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.person_outlined),
              prefixIconColor: Color.fromRGBO(116, 225, 225, 1),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Username must be provided';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: const Color.fromRGBO(116, 225, 225, 1),
            decoration: const InputDecoration(
              hintText: 'Email Address',
              labelText: 'Email',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.email_outlined),
              prefixIconColor: Color.fromRGBO(116, 225, 225, 1),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email must be provided';
              }
              if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passController,
            keyboardType: TextInputType.visiblePassword,
            cursorColor: const Color.fromRGBO(116, 225, 225, 1),
            obscureText: obsecurePass,
            decoration: InputDecoration(
              hintText: 'Password',
              labelText: 'Password',
              alignLabelWithHint: true,
              prefixIcon: const Icon(Icons.lock_outline),
              prefixIconColor: const Color.fromRGBO(116, 225, 225, 1),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obsecurePass = !obsecurePass;
                  });
                },
                icon: Icon(
                  obsecurePass
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: obsecurePass ? Colors.black38 : const Color.fromRGBO(116, 225, 225, 1),
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password must be provided';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters long';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          if (errorMessage != null) // Menampilkan pesan kesalahan jika ada
            Text(
              errorMessage!,
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          Consumer<AuthModel>(
            builder: (context, auth, child) {
              return Button(
                width: double.infinity,
                title: 'Sign Up',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final userRegistration = await DioProvider().registerUser(
                      _nameController.text,
                      _emailController.text,
                      _passController.text,
                    );

                    if (userRegistration is DioError) {
                      if (userRegistration.response?.statusCode == 409) {
                        // Jika email sudah terdaftar, tampilkan pesan kesalahan
                        setState(() {
                          errorMessage = 'Email already registered';
                        });
                      } else {
                        // Handle error lain jika diperlukan
                        setState(() {
                          errorMessage = 'Email Alredy registered';
                        });
                      }
                    } else if (userRegistration) {
                      final token = await DioProvider().getToken(
                        _emailController.text,
                        _passController.text,
                      );

                      if (token) {
                        auth.loginSuccess({}, {}); // Update login status
                        MyApp.navigatorKey.currentState!.pushNamed('/');
                      }
                    }
                  }
                },
                disable: false,
              );
            },
          ),
        ],
      ),
    );
  }
}