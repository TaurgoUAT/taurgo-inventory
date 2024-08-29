import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taurgo_inventory/constants/UrlConstants.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
// A provider for the list of properties
final propertiesProvider = StateNotifierProvider<PropertiesNotifier, List<Map<String, dynamic>>>(
      (ref) => PropertiesNotifier(),
);

// A provider for the selected property
final selectedPropertyProvider = StateProvider<Map<String, dynamic>?>((ref) => null);

class PropertiesNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  PropertiesNotifier() : super([]);

  Future<void> fetchProperties() async {
    try {
      final response = await http.get(Uri.parse('$baseURL/property/getProps'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        state = data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        print("Failed to load properties: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching properties: $e");
    }
  }
}
