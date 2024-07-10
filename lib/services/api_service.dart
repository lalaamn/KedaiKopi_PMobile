// baru update

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kedaikopi/models/sales.dart';
import 'package:kedaikopi/models/stock.dart';
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'https://api.kartel.dev';

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Product> products =
          body.map((dynamic item) => Product.fromJson(item)).toList();
      return products;
    } else {
      throw "Failed to load  produk";
    }
  }

  Future<List<Stock>> getStocks() async {
    final response = await http.get(Uri.parse('$baseUrl/stocks'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Stock> stocks =
          body.map((dynamic item) => Stock.fromJson(item)).toList();
      return stocks;
    } else {
      throw Exception('Failed to load stocks');
    }
  }

  Future<List<Sales>> getSaless() async {
    final response = await http.get(Uri.parse('$baseUrl/sales'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Sales> sales =
          body.map((dynamic item) => Sales.fromJson(item)).toList();
      return sales;
    } else {
      throw Exception('Failed to load sales');
    }
  }

  Future<Product> getProduct(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$id'));
    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<Stock> getStock(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/stocks/$id'));
    if (response.statusCode == 200) {
      return Stock.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Stock');
    }
  }

  Future<Sales> getSales(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/sales/$id'));
    if (response.statusCode == 200) {
      return Sales.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Sales');
    }
  }

  Future<http.Response> delProduct(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/products/$id'));
    if (response.statusCode == 204) {
      return response;
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<http.Response> delStock(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/stocks/$id'));
    if (response.statusCode == 204) {
      return response;
    } else {
      throw Exception('Failed to load Stock');
    }
  }

  Future<http.Response> delSales(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/sales/$id'));
    if (response.statusCode == 204) {
      return response;
    } else {
      throw Exception('Failed to load Sales');
    }
  }

  Future<http.Response> editProduct(String name, num price, num qty,
      String attr, num weight, String id) async {
    final response = await http.put(
      Uri.parse('$baseUrl/products/$id'),
      body: json.encode({
        'name': name,
        'price': price,
        'qty': qty,
        'attr': attr,
        'weight': weight,
        "issuer": 'Mala'
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create product');
    }

    return response;
  }

  Future<http.Response> editStock(
      String name, num qty, String attr, num weight, String id) async {
    final response = await http.put(
      Uri.parse('$baseUrl/stocks/$id'),
      body: json.encode({
        'name': name,
        'qty': qty,
        'attr': attr,
        'weight': weight,
        "issuer": 'Mala'
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create stock');
    }

    return response;
  }

  Future<http.Response> editSales(
      String buyer, String phone, String date, String status, String id) async {
    final response = await http.put(
      Uri.parse('$baseUrl/sales/$id'),
      body: json.encode({
        'buyer': buyer,
        'phone': phone,
        'date': date,
        'status': status,
        "issuer": 'Mala'
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create stock');
    }

    return response;
  }

  Future<http.Response> createProduct(
      String name, num price, num qty, String attr, num weight) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      body: json.encode({
        'name': name,
        'price': price,
        'qty': qty,
        'attr': attr,
        'weight': weight,
        "issuer": 'Mala'
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create product');
    }

    return response;
  }

  Future<http.Response> createStock(
      String name, num qty, String attr, num weight) async {
    final response = await http.post(
      Uri.parse('$baseUrl/stocks'),
      body: json.encode({
        'name': name,
        'qty': qty,
        'attr': attr,
        'weight': weight,
        "issuer": 'Mala'
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create stock');
    }

    return response;
  }

  Future<http.Response> createSales(
      String buyer, String phone, String date, String status) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sales'),
      body: json.encode({
        'buyer': buyer,
        'phone': phone,
        'date': date,
        'status': status,
        "issuer": 'Mala'
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create stock');
    }

    return response;
  }
}
