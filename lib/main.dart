import 'package:flutter/material.dart';
import 'package:flutter_chat_app/views/signup.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff007EF4),
        scaffoldBackgroundColor: Color(0xff1F1F1F),
      ),
      home: SignUp(),
    );
  }
}

