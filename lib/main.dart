import 'package:flutter/material.dart';
import 'role_selection.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App de Transporte',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RoleSelectionScreen(),
    );
  }
}
