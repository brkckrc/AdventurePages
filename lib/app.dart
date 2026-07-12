import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'services/save_service.dart';

class AdventurePagesApp extends StatefulWidget {
  const AdventurePagesApp({super.key, this.saveService});

  final SaveService? saveService;

  @override
  State<AdventurePagesApp> createState() => _AdventurePagesAppState();
}

class _AdventurePagesAppState extends State<AdventurePagesApp> {
  late final SaveService _saveService = widget.saveService ?? SaveService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adventure Pages',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2F6B5B),
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: HomeScreen(saveService: _saveService),
    );
  }
}
