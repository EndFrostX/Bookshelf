import 'package:flutter/material.dart';

import 'Pages/Home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: "BookShelf",
      home: Home(),
    );
  }
}
