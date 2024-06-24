import 'dart:convert';
import 'package:homecareapp/components/button.dart';
import 'package:homecareapp/main.dart';
import 'package:homecareapp/models/auth_model.dart';
import 'package:homecareapp/providers/dio_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/config.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool obsecurePass = true;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Config.primaryColor,
            decoration: const InputDecoration(
              hintText: 'Email Address',
              labelText: 'Email',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.email_outlined),
              prefixIconColor: Config.primaryColor,
            ),
          ),
          Config.spaceSmall,
          TextFormField(
            controller: _passController,
            keyboardType: TextInputType.visiblePassword,
            cursorColor: Config.primaryColor,
            obscureText: obsecurePass,
            decoration: InputDecoration(
                hintText: 'Password',
                labelText: 'Password',
                alignLabelWithHint: true,
                prefixIcon: const Icon(Icons.lock_outline),
                prefixIconColor: Config.primaryColor,
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obsecurePass = !obsecurePass;
                      });
                    },
                    icon: obsecurePass
                        ? const Icon(
                            Icons.visibility_off_outlined,
                            color: Colors.black38,
                          )
                        : const Icon(
                            Icons.visibility_outlined,
                            color: Config.primaryColor,
                          ))),
          ),
          Config.spaceSmall,
          Consumer<AuthModel>(
            builder: (context, auth, child) {
              return Button(
                width: double.infinity,
                title: 'Sign In',
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  //login here
                  final token = await DioProvider()
                      .getToken(_emailController.text, _passController.text);
                      debugPrint('getToken berhasil');

                  if (token) {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    final tokenValue = prefs.getString('token') ?? '';

                    if (tokenValue!='') {
                      //get user data
                      final response = await DioProvider().getUser(tokenValue);
                      print(response);
                      if (response != null) {
                        Map<String, dynamic> appointment = {};
                        final user = json.decode(response);

                        //check if any appointment today
                        for (var doctorData in user['doctor']) {
                          if (doctorData['appointments'] != null) {
                            appointment = doctorData;
                          }
                        }

                        auth.loginSuccess(user, appointment);
                        if (user['type'] == 'doctor') {
                          MyApp.navigatorKey.currentState!
                              .pushReplacementNamed('doc_dashboard');
                        } else {
                          MyApp.navigatorKey.currentState!
                              .pushReplacementNamed('main');
                        }
                      } else {
                        print('Invalid account or account not found.');
                        _showErrorDialog('Invalid account or account not found.');
                      }
                    }
                  } else {
                    print('Invalid email or password.');
                    _showErrorDialog('Invalid email or password.');
                  }
                },
                disable: false,
              );
            },
          )
        ],
      ),
    );
  }
}
