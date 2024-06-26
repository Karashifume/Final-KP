import 'package:homecareapp/components/login_form.dart';
import 'package:homecareapp/components/sign_up_form.dart';
import 'package:homecareapp/utils/text.dart';
import 'package:flutter/material.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    //build login text field
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                const SizedBox(width: 60),  // Add spacing between text and image
                Image.asset('assets/logorsmh.jpg', height: 106),
                const SizedBox(width: 1),  // Add spacing between text and image
                Image.asset('assets/New Logo RSMH.png', height: 55),   // Adjust the size as needed
              ],
            ),
            Config.spaceSmall,
            if (errorMessage != null) ...[
              Text(
                errorMessage!,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Config.spaceSmall,
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
            isSignIn ? LoginForm(onError: handleError) : SignUpForm(),
            Config.spaceSmall,
            isSignIn
                ? Center(
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        AppText.enText['forgot-password']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                : Container(),
            const Spacer(),
            Config.spaceSmall,
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: const <Widget>[
            //     SocialButton(social: 'google'),
            //     SocialButton(social: 'facebook'),
            //   ],
            // ),
            Config.spaceSmall,
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
            )
          ],
        ),
      ),
    ));
  }
}
