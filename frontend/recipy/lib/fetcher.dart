import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Fetcher {
  static Future<dynamic> get(String baseUrl, String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  static Future<dynamic> post(String baseUrl, String endpoint, dynamic data) async {
    final url = Uri.parse('$baseUrl$endpoint');

    final encodedData = jsonEncode(data);
    debugPrint(encodedData);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: encodedData,
    );
    
    return response;
  }

  static Future<dynamic> put(String baseUrl, String endpoint, dynamic data) async {
    final url = Uri.parse('$baseUrl$endpoint');

    final encodedData = jsonEncode(data);
    debugPrint(encodedData);

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: encodedData,
    );
    
    return response;
  }
}
