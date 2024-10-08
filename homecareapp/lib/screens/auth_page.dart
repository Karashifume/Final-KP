import 'package:flutter/material.dart';
import 'package:homecareapp/components/login_form.dart';
import 'package:homecareapp/components/register_form.dart';
import 'package:homecareapp/utils/text.dart';
import '../utils/config.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isSignIn = true;
  String? errorMessage;

  void handleError(String message) {
    setState(() {
      errorMessage = message;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Image.asset('assets/logorsmh.jpg', height: 40),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Image.asset('assets/New Logo RSMH.png', height: 35),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        child: Image.asset('assets/logo-umdp-1-300x248-2.png', height: 70),
                      ),
                    ],
                  ),
                ),
              ),
              if (errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              Text(
                isSignIn
                    ? AppText.enText['signIn_text']!
                    : AppText.enText['register_text']!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Config.spaceSmall,
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromARGB(255, 0, 0, 0)),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(20),
                child: isSignIn ? LoginForm(onError: handleError) : SignUpForm(),
              ),
              // Config.spaceSmall,
              // if (isSignIn)
              //   Center(
              //     child: TextButton(
              //       onPressed: () {},
              //       child: Text(
              //         AppText.enText['forgot-password']!,
              //         style: const TextStyle(
              //           fontSize: 16,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.black,
              //         ),
              //       ),
              //     ),
              //   ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    isSignIn
                        ? AppText.enText['signUp_text']!
                        : AppText.enText['registered_text']!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isSignIn = !isSignIn;
                      });
                    },
                    child: Text(
                      isSignIn ? 'Sign Up' : 'Sign In',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
