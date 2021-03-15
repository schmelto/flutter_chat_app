import 'package:flutter/material.dart';
import 'package:flutter_chat_app/views/signin.dart';

void main() {
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
      home: SignIn(),
    );
  }
}

