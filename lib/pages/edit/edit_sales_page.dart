import 'package:flutter/material.dart';
import 'package:kedaikopi/models/sales.dart';
import 'package:kedaikopi/services/api_service.dart';

class EditSalesPage extends StatefulWidget {
  final String id;
  const EditSalesPage({super.key, required this.id});

  @override
  State<EditSalesPage> createState() => _EditSalesPageState();
}

class _EditSalesPageState extends State<EditSalesPage> {
  final ApiService apiService = ApiService();
  Sales? sales;
  bool isLoading = true;

  final _formKey = GlobalKey<FormState>();
  final _salesBuyerController = TextEditingController();
  final _salesPhoneController = TextEditingController();
  final _salesDateController = TextEditingController();
  final _salesStatusController = TextEditingController();
  String? _selectedStatus; // Variabel untuk menyimpan nilai yang dipilih
  final List<String> _statuses = [
    'Order',
    'Pending',
    'Proses',
    'Selesai',
    'Batal'
  ];

  @override
  void initState() {
    super.initState();
    _fetchSales(); // Panggil fungsi untuk mengambil data sales saat pertama kali halaman dimuat
  }

  Future<void> _fetchSales() async {
    try {
      Sales fetchedSales = await apiService.getSales(widget.id);
      print('fetchedSales: $fetchedSales');
      setState(() {
        sales = fetchedSales;
        _salesBuyerController.text = sales!.buyer;
        _salesPhoneController.text = sales!.phone;
        _salesDateController.text = sales!.date;
        _selectedStatus = sales!.status; // Menetapkan status yang dipilih
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
        title: Text('Edit Sales'),
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
                        controller: _salesBuyerController,
                        labelText: 'Buyer Name',
                        icon: Icons.person,
                      ),
                      SizedBox(height: 20),
                      _buildTextFormField(
                        controller: _salesPhoneController,
                        labelText: 'Phone',
                        icon: Icons.phone,
                      ),
                      SizedBox(height: 20),
                      _buildTextFormField(
                        controller: _salesDateController,
                        labelText: 'Sales Date',
                        icon: Icons.calendar_today,
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );

                          if (pickedDate != null) {
                            setState(() {
                              _salesDateController.text =
                                  "${pickedDate.toLocal()}".split(' ')[0];
                            });
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        dropdownColor: Colors.brown[50], // Warna dropdown
                        value: _selectedStatus,
                        decoration: InputDecoration(
                          labelText: 'Status',
                          prefixIcon: Icon(Icons.filter_list,
                              color: Colors.brown), // Ikon dropdown
                          border: OutlineInputBorder(),
                        ),
                        items: _statuses.map((status) {
                          return DropdownMenuItem<String>(
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedStatus = newValue;
                            _salesStatusController.text = newValue!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a Status';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              var response = await ApiService().editSales(
                                  _salesBuyerController.text,
                                  _salesPhoneController.text,
                                  _salesDateController.text,
                                  _salesStatusController.text,
                                  widget.id);
                              print(
                                  'Sales updated successfully: ${response.statusCode}');
                              Navigator.pop(context);
                              _showDialog(
                                context,
                                'Success',
                                'Sales updated successfully',
                              );
                            } catch (e) {
                              print('Error updating Sales: $e');
                              Navigator.pop(context);
                              _showDialog(
                                context,
                                'Failed',
                                'Sales update failed',
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
                        child: Text('Update Sales'),
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
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
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
