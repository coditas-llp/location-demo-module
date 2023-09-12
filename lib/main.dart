import 'package:flutter/material.dart';
import 'package:maps_poc/flutter_map_package.dart';
import 'package:maps_poc/google_maps_package.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FlutterMapPackage(),
    );
  }
}
