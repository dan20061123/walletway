import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'database/database_helper.dart';
import 'package:walleyway/screens/main_screen.dart';

void main() {
  // Initialize FFI for desktop or testing environments
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi; // Set the FFI database factory
  final dbHelper = DatabaseHelper();
  dbHelper.debugCategories();
  runApp(const WalletWay());
}

class WalletWay extends StatelessWidget {
  const WalletWay({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WalletWay',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}
