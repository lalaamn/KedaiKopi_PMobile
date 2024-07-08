import 'package:fancy_bottom_navigation_2/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kedaikopi/pages/home_page.dart';
import 'package:kedaikopi/pages/product_page.dart';
import 'package:kedaikopi/pages/sales_page.dart';
import 'package:kedaikopi/pages/stock_page.dart';
import 'package:kedaikopi/pages/splash_screen.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor:
        Color(0xFF6f4e37), // Set the background color of the navigation bar
    systemNavigationBarIconBrightness:
        Brightness.light, // Set the color of the navigation bar icons
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kedai Kopi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF6f4e37)),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf5f5dc),
      bottomNavigationBar: FancyBottomNavigation(
        tabs: [
          TabData(iconData: Icons.home, title: "Home"),
          TabData(iconData: Icons.local_mall, title: "Product"),
          TabData(iconData: Icons.storage, title: "Stock"),
          TabData(iconData: Icons.attach_money, title: "Sales"),
        ],
        onTabChangedListener: (index) {
          _onTabChanged(index);
          _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);
        },
        activeIconColor: Colors.white,
        circleColor: Color(0xFF6f4e37),
        inactiveIconColor: Color(0xFF6f4e37),
        textColor: Color(0xFF6f4e37),
        initialSelection: _currentIndex,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          _onTabChanged(index);
        },
        children: <Widget>[
          HomePage(
              pageController: _pageController, onTabChanged: _onTabChanged),
          ProductPage(),
          StockPage(),
          SalesPage(),
        ],
      ),
    );
  }
}
