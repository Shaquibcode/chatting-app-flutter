import 'package:chattingapp/api/apis.dart';
import 'package:chattingapp/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../main.dart';
import 'auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      //exit full screen
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
      );
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          statusBarColor: Colors.white,
        ),
      );
      if (APIs.auth.currentUser != null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Chat App'),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Positioned(
            top: mq.height * .15,
            left: mq.width * .25,
            child: Image(
              image: const AssetImage(
                'images/live-chat.png',
              ),
              width: mq.width * .50,
            ),
          ),
          Positioned(
              bottom: mq.height * .15,
              width: mq.width * .9,
              left: mq.width * .07,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'MADE By Shaquib Nawaz ',
                    style: TextStyle(fontSize: 25),
                  ),
                  Icon(
                    CupertinoIcons.heart_solid,
                    color: Colors.red,
                    size: 30,
                  )
                ],
              )),
        ],
      ),
    );
  }
}
