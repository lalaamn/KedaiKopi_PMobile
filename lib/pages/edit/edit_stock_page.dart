// baru update

import 'package:flutter/material.dart';
import 'package:kedaikopi/models/stock.dart';
import 'package:kedaikopi/services/api_service.dart';

class EditStockPage extends StatefulWidget {
  final String id;
  const EditStockPage({Key? key, required this.id}) : super(key: key);

  @override
  State<EditStockPage> createState() => _EditStockPageState();
}

class _EditStockPageState extends State<EditStockPage> {
  final ApiService apiService = ApiService();
  Stock? stock;
  bool isLoading = true;

  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _productAttrController = TextEditingController();
  final _productQtyController = TextEditingController();
  final _productWeightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchStock(); // Panggil fungsi untuk mengambil data stock saat pertama kali halaman dimuat
  }

  Future<void> _fetchStock() async {
    try {
      Stock fetchedStock = await apiService.getStock(widget.id);
      print('fetchedStock: $fetchedStock');
      setState(() {
        stock = fetchedStock;
        _productNameController.text = stock!.name;
        _productAttrController.text = stock!.attr;
        _productQtyController.text = stock!.qty.toString();
        _productWeightController.text = stock!.weight.toString();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50], // Warna latar belakang halaman
      appBar: AppBar(
        backgroundColor: Colors.brown, // Warna AppBar
        foregroundColor: Colors.white,
        title: Text('Edit Stock'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextFormField(
                        controller: _productNameController,
                        labelText: 'Product Name',
                        icon: Icons.production_quantity_limits,
                      ),
                      SizedBox(height: 20),
                      _buildTextFormField(
                        controller: _productWeightController,
                        labelText: 'Product Weight',
                        icon: Icons.scale,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 20),
                      _buildTextFormField(
                        controller: _productQtyController,
                        labelText: 'Product Quantity',
                        icon: Icons.numbers,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 20),
                      _buildTextFormField(
                        controller: _productAttrController,
                        labelText: 'Product Attribute',
                        icon: Icons.info,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              var response = await apiService.editStock(
                                  _productNameController.text,
                                  num.parse(_productQtyController.text),
                                  _productAttrController.text,
                                  num.parse(_productWeightController.text),
                                  widget.id);
                              print(
                                  'Stock updated successfully: ${response.statusCode}');
                              Navigator.pop(context);
                              _showDialog(
                                context,
                                'Success',
                                'Stock updated successfully',
                              );
                            } catch (e) {
                              print('Error updating stock: $e');
                              Navigator.pop(context);
                              _showDialog(
                                context,
                                'Failed',
                                'Stock update failed',
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
                        child: Text('Update Stock'),
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
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
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
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
