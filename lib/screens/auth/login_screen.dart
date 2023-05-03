import 'package:chattingapp/api/apis.dart';
import 'package:chattingapp/helper/dialogs.dart';
import 'package:chattingapp/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  //function for google signin and then getting user details and navigating to next screen

  _handleGoogleBtnClick() {
    //show progress bar
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then(
      (user) async {
        //dismiss progress bar
        Navigator.pop(context);
        if (user != null) {
          if (await APIs.userExists()) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          } else {
            APIs.createUser().then(
              (value) => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              ),
            );
          }
        }
      },
    );
  }

  //code for Google SignIn

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      debugPrint("\n_signinwithgoogle: $e");
      Dialogs.showSnackBar(context, "Something went wrong");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Chat App'),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
            top: mq.height * .15,
            left: _isAnimate ? mq.width * .25 : mq.width * 0.5,
            duration: const Duration(seconds: 1),
            child: Image(
              image: const AssetImage(
                'images/live-chat.png',
              ),
              width: mq.width * .50,
            ),
          ),
          Positioned(
            bottom: mq.height * .15,
            left: mq.width * .05,
            width: mq.width * .9,
            height: mq.height * .07,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 223, 255, 187),
                  shape: const StadiumBorder(),
                  elevation: 1),
              onPressed: () async {
                await _handleGoogleBtnClick();
              },
              icon: Image(
                image: const AssetImage(
                  'images/google.png',
                ),
                height: mq.height * .04,
              ),
              label: RichText(
                text: const TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 17),
                  children: [
                    TextSpan(text: 'Sign in with '),
                    TextSpan(
                      text: 'Google',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
