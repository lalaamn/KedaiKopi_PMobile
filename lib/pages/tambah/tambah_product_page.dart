// baru update

import 'package:flutter/material.dart';
import 'package:kedaikopi/main.dart';
import 'package:kedaikopi/services/api_service.dart';

class TambahProductPage extends StatefulWidget {
  const TambahProductPage({Key? key}) : super(key: key);

  @override
  State<TambahProductPage> createState() => _TambahProductPageState();
}

class _TambahProductPageState extends State<TambahProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _productPriceController = TextEditingController();
  final _productAttrController = TextEditingController();
  final _productQtyController = TextEditingController();
  final _productWeightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50], // Warna latar belakang halaman
      appBar: AppBar(
        backgroundColor: Colors.brown, // Warna AppBar
        foregroundColor: Colors.white,
        title: Text('Tambah Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextFormField(
                  controller: _productNameController,
                  labelText: 'Nama Produk',
                  icon: Icons.production_quantity_limits,
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _productPriceController,
                  labelText: 'Harga Produk',
                  icon: Icons.monetization_on,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _productWeightController,
                  labelText: 'Berat Produk',
                  icon: Icons.fitness_center,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _productQtyController,
                  labelText: 'Kuantitas Produk',
                  icon: Icons.exposure_plus_1,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _productAttrController,
                  labelText: 'Atribut Produk',
                  icon: Icons.info_outline,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        var response = await ApiService().createProduct(
                          _productNameController.text,
                          num.parse(_productPriceController.text),
                          num.parse(_productQtyController.text),
                          _productAttrController.text,
                          num.parse(_productWeightController.text),
                        );
                        print(
                            'Product created successfully: ${response.statusCode}');
                        Navigator.pop(context);
                        _showDialog(
                          context,
                          'Success',
                          'Product created successfully',
                        );
                      } catch (e) {
                        print('Error creating Product: $e');
                        Navigator.pop(context);
                        _showDialog(
                          context,
                          'Failed',
                          'Product creation failed',
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50), // Full-width button
                    backgroundColor: Colors.brown, // Warna tombol
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text('Kirim'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build text form fields
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Colors.brown), // Ikon di dalam text field
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }

  // Helper method to show dialog
  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyHomePage()));
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
