import 'package:flutter/material.dart';
import 'package:kedaikopi/models/sales.dart';
import 'package:kedaikopi/pages/detail/detail_sales.dart';
import 'package:kedaikopi/pages/tambah/tambah_sales_page.dart';
import 'package:kedaikopi/services/api_service.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  late Future<List<Sales>> listSales;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    listSales = apiService.getSaless();
  }

  void refreshStock() {
    setState(() {
      listSales = apiService.getSaless();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50], // Warna latar belakang halaman
      appBar: AppBar(
        title: Text('Daftar Sales'),
        backgroundColor: Colors.brown, // Warna AppBar
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50), // Full-width button
                backgroundColor: Colors.brown, // Warna tombol
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TambahSalesPage()),
                );
              },
              icon: Icon(Icons.add, color: Colors.white), // Ikon tombol
              label: Text('Tambah Sales'),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await apiService.getSaless();
                refreshStock();
              },
              child: FutureBuilder<List<Sales>>(
                future: apiService.getSaless(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No sales found'));
                  } else {
                    List<Sales> sales = snapshot.data!;
                    return ListView.builder(
                      itemCount: sales.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          elevation: 5,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16.0),
                            leading: Icon(Icons.shopping_cart,
                                color: Colors.brown), // Ikon penjualan
                            title: Text(sales[index].buyer,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(sales[index].status,
                                style: TextStyle(color: Colors.grey[600])),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailSalesPage(id: sales[index].id),
                                ),
                              ).then((_) async {
                                await apiService.getSaless();
                                refreshStock();
                              });
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      
    );
  }
}
