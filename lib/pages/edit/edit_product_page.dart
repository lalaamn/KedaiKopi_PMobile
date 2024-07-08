import 'package:flutter/material.dart';
import 'package:kedaikopi/models/product.dart';
import 'package:kedaikopi/services/api_service.dart';

class EditProductPage extends StatefulWidget {
  final String id;
  const EditProductPage({Key? key, required this.id}) : super(key: key);

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final ApiService apiService = ApiService();
  Product? product;
  bool isLoading = true;

  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _productPriceController = TextEditingController();
  final _productAttrController = TextEditingController();
  final _productQtyController = TextEditingController();
  final _productWeightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProduct(); // Panggil fungsi untuk mengambil data produk saat pertama kali halaman dimuat
  }

  Future<void> _fetchProduct() async {
    try {
      Product fetchedProduct = await apiService.getProduct(widget.id);
      print('fetchedProduct: $fetchedProduct');
      setState(() {
        product = fetchedProduct;
        _productNameController.text = product!.name;
        _productPriceController.text = product!.price.toString();
        _productAttrController.text = product!.attr;
        _productQtyController.text = product!.qty.toString();
        _productWeightController.text = product!.weight.toString();
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
        title: Text('Edit Product'),
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
                        controller: _productPriceController,
                        labelText: 'Product Price',
                        icon: Icons.attach_money,
                        keyboardType: TextInputType.number,
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
                        icon: Icons.add_box,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 20),
                      _buildTextFormField(
                        controller: _productAttrController,
                        labelText: 'Product Attribute',
                        icon: Icons.label,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              var response = await apiService.editProduct(
                                _productNameController.text,
                                int.parse(_productPriceController.text),
                                int.parse(_productQtyController.text),
                                _productAttrController.text,
                                int.parse(_productWeightController.text),
                                widget.id,
                              );
                              print(
                                  'Product updated successfully: ${response.statusCode}');
                              Navigator.pop(context);
                              _showDialog(
                                context,
                                'Success',
                                'Product updated successfully',
                              );
                            } catch (e) {
                              print('Error updating Product: $e');
                              Navigator.pop(context);
                              _showDialog(
                                context,
                                'Failed',
                                'Product update failed',
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
                        child: Text('Update'),
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
