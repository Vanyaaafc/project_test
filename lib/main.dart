import 'package:flutter/material.dart';
import 'package:test_comitons_project/core/di/injection_container.dart';
import 'package:test_comitons_project/core/hive/hive_initialize.dart';
import 'package:test_comitons_project/presentation/main_screen/main_screen.dart';

void main() async {
  await initDI();
  await initHive();
  runApp(MaterialApp(
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple.shade400),
        useMaterial3: true,
      )));
}
