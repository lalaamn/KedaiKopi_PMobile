import 'package:flutter/material.dart';
import 'package:kedaikopi/main.dart';
import 'package:kedaikopi/services/api_service.dart';

class TambahSalesPage extends StatefulWidget {
  const TambahSalesPage({Key? key}) : super(key: key);

  @override
  State<TambahSalesPage> createState() => _TambahSalesPageState();
}

class _TambahSalesPageState extends State<TambahSalesPage> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50], // Warna latar belakang halaman
      appBar: AppBar(
        backgroundColor: Colors.brown, // Warna AppBar
        foregroundColor: Colors.white,
        title: Text('Tambah Sales'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextFormField(
                  controller: _salesBuyerController,
                  labelText: 'Nama Pembeli',
                  icon: Icons.person,
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _salesPhoneController,
                  labelText: 'Telepon',
                  keyboardType: TextInputType.number,
                  icon: Icons.phone,
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _salesDateController,
                  labelText: 'Tanggal ',
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
                  dropdownColor: Colors.brown[100], // Warna dropdown
                  value: _selectedStatus,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    prefixIcon: Icon(Icons.assignment,
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
                        var response = await ApiService().createSales(
                          _salesBuyerController.text,
                          _salesPhoneController.text,
                          _salesDateController.text,
                          _salesStatusController.text,
                        );
                        print(
                            'Sales created successfully: ${response.statusCode}');
                        Navigator.pop(context);
                        _showDialog(
                          context,
                          'Sukses',
                          'Sales berhasil dibuat',
                        );
                      } catch (e) {
                        print('Error creating Sales: $e');
                        Navigator.pop(context);
                        _showDialog(
                          context,
                          'Gagal',
                          'Gagal membuat Sales',
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
                  child: Text('Tambah Sales'),
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
    bool readOnly = false,
    void Function()? onTap,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
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
