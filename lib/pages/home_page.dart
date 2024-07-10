// ignore_for_file: unused_field
// baru update
import 'package:flutter/material.dart';
import 'package:kedaikopi/services/api_service.dart';

class HomePage extends StatefulWidget {
  final PageController pageController;
  final Function(int) onTabChanged;

  const HomePage(
      {super.key, required this.pageController, required this.onTabChanged});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Warna latar belakang
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.local_cafe,
                  size: 100, color: Color(0xFF6f4e37)), // Ikon kopi
              const SizedBox(height: 10),
              const Text(
                'Selamat Datang',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6f4e37), // Warna tema
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'di Kedai Kopi Mala Hasanatul Amanah',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF6f4e37), // Warna tema
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
