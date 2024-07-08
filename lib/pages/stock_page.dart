import 'package:flutter/material.dart';
import 'package:kedaikopi/models/stock.dart';
import 'package:kedaikopi/pages/detail/detail_stock.dart';
import 'package:kedaikopi/pages/tambah/tambah_stock_page.dart';
import 'package:kedaikopi/services/api_service.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  late Future<List<Stock>> listStock;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    listStock = apiService.getStocks();
  }

  void refreshStock() {
    setState(() {
      listStock = apiService.getStocks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50], // Warna latar belakang halaman
      appBar: AppBar(
        title: Text('Daftar Stok'),
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
                  MaterialPageRoute(builder: (context) => TambahStockPage()),
                );
              },
              icon: Icon(Icons.add, color: Colors.white), // Ikon tombol
              label: Text('Tambah Stok'),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await apiService.getStocks();
                refreshStock();
              },
              child: FutureBuilder<List<Stock>>(
                future: apiService.getStocks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No stocks found'));
                  } else {
                    List<Stock> stocks = snapshot.data!;
                    return ListView.builder(
                      itemCount: stocks.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          elevation: 5,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16.0),
                            leading: Icon(Icons.inventory,
                                color: Colors.brown), // Ikon stok
                            title: Text(stocks[index].name,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                '${stocks[index].qty} ${stocks[index].attr}',
                                style: TextStyle(color: Colors.grey[600])),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailStockPage(id: stocks[index].id),
                                ),
                              ).then((_) async {
                                await apiService.getStocks();
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
