import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/entry.dart';

class EntryService {
  final String baseUrl;

  EntryService({required this.baseUrl});

  Future<List<Entry>> fetchEntries() async {
    final response = await http.get(Uri.parse('$baseUrl/entry'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Entry.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar las entradas');
    }
  }

  Future<Entry> fetchEntry(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/entry/$id'));
    if (response.statusCode == 200) {
      return Entry.fromJson(json.decode(response.body));
    } else {
      throw Exception('Entrada no encontrada');
    }
  }

  Future<Entry> createEntry(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/entry'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Entry.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al crear la entrada');
    }
  }

  Future<Entry> updateEntry(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/entry/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    if (response.statusCode == 200) {
      return Entry.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar la entrada');
    }
  }

  Future<void> deleteEntry(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/entry/$id'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar la entrada');
    }
  }
}
