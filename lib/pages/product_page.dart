import 'package:flutter/material.dart';
import 'package:kedaikopi/models/product.dart';
import 'package:kedaikopi/pages/detail/detail_product.dart';
import 'package:kedaikopi/pages/tambah/tambah_product_page.dart';
import 'package:kedaikopi/services/api_service.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late Future<List<Product>> listProduct;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    listProduct = apiService.getProducts();
  }

  void refreshProducts() {
    setState(() {
      listProduct = apiService.getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50], // Warna latar belakang halaman
      appBar: AppBar(
        title: Text('Daftar Produk'),
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
                  MaterialPageRoute(builder: (context) => TambahProductPage()),
                );
              },
              icon: Icon(Icons.add, color: Colors.white), // Ikon tombol
              label: Text('Tambah Produk'),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await apiService.getProducts();
                refreshProducts();
              },
              child: FutureBuilder<List<Product>>(
                future: listProduct,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No products found'));
                  } else {
                    List<Product> products = snapshot.data!;
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          elevation: 5,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16.0),
                            leading: Icon(Icons.coffee,
                                color: Colors.brown), // Ikon produk
                            title: Text(products[index].name,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                '\$${products[index].price.toStringAsFixed(2)}',
                                style: TextStyle(color: Colors.grey[600])),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailProductPage(id: products[index].id),
                                ),
                              ).then((_) async {
                                await apiService.getProducts();
                                refreshProducts();
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
