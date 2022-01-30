import 'package:flutter/material.dart';
import 'package:tp6_carte_aux_tresors/view/page_principale.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Carte au trésor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PagePrincipale(),
    );
  }
}
