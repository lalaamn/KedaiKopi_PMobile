// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:kedaikopi/models/product.dart';
import 'package:kedaikopi/models/sales.dart';
import 'package:kedaikopi/models/stock.dart';
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
  Future<List<Product>>? _fetchProductsFuture;
  int _totalProducts = 0;

  Future<List<Stock>>? _fetchStocksFuture;
  int _totalStocks = 0;

  Future<List<Sales>>? _fetchSalesFuture;
  int _totalSales = 0;

  @override
  void initState() {
    super.initState();
    _fetchProductsFuture = _fetchProducts();
    _fetchStocksFuture = _fetchStocks();
    _fetchSalesFuture = _fetchSales();
  }

  Future<List<Product>> _fetchProducts() async {
    List<Product> products = await apiService.getProducts();
    setState(() {
      _totalProducts = products.length;
    });
    return products;
  }

  Future<List<Stock>> _fetchStocks() async {
    List<Stock> stocks = await apiService.getStocks();
    setState(() {
      _totalStocks = stocks.length;
    });
    return stocks;
  }

  Future<List<Sales>> _fetchSales() async {
    List<Sales> sales = await apiService.getSaless();
    setState(() {
      _totalSales = sales.length;
    });
    return sales;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5), // Warna latar belakang
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.local_cafe,
                  size: 100, color: Color(0xFF6f4e37)), // Ikon kopi
              SizedBox(height: 10),
              Text(
                'Selamat Datang',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6f4e37), // Warna tema
                ),
              ),
              SizedBox(height: 10),
              Text(
                'di Kedai Kopi Mala Hasanatul Amanah',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF6f4e37), // Warna tema
                ),
              ),
              SizedBox(height: 40),
              FutureBuilder<List<Product>>(
                future: _fetchProductsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Menampilkan loading spinner
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildButton('$_totalProducts', 'Produk', 1),
                          SizedBox(width: 10),
                          _buildButton('$_totalStocks', 'Stok', 2),
                          SizedBox(width: 10),
                          _buildButton('$_totalSales', 'Sales', 3),
                        ],
                      ),
                    );
                  } else {
                    return Text('No data available');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String number, String label, int page) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          widget.pageController.jumpToPage(page);
          widget.onTabChanged(
              page); // Tambahkan baris ini untuk mengubah ikon aktif
        },
        style: ElevatedButton.styleFrom(
          minimumSize: Size(150, 100),
          backgroundColor: Color(0xFF6f4e37), // Warna tombol
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              number,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
