import 'package:chattingapp/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//global variable for accessing device size screen
late Size mq;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //enter full screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  //setting for portrait mode then initialize firebase
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) => initializeFirebase());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 1,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            fontSize: 19,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}

void initializeFirebase() async {
  await Firebase.initializeApp();
}
