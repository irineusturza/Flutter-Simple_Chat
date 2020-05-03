import 'package:chat_flutter/views/chat_screen/chat_screen_view.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        iconTheme: IconThemeData(
          color: Colors.blue
        )
      ),
      debugShowCheckedModeBanner: false,
      home: ChatScreenView(),
    );
  }
}
