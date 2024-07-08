import 'package:flutter/material.dart';
import 'package:kedaikopi/main.dart'; // Pastikan untuk mengimpor file yang benar untuk MyHomePage

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 3), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MyHomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6f4e37),
      body: Center(
        child: Image.asset('assets/images/logokopi.png'),
      ),
    );
  }
}
