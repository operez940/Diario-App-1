import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/entry.dart';

class EntryService {
  Future<void> hardDeleteEntry(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/entry/$id/hard'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar definitivamente la entrada');
    }
  }
  final String baseUrl;

  EntryService({required String? baseUrl})
      : baseUrl = baseUrl ?? 'https://x06cxvm2-3000.use2.devtunnels.ms';

  Future<List<Entry>> fetchEntries({bool showInactive = false}) async {
    final url = showInactive ? '$baseUrl/entry?inactive=1' : '$baseUrl/entry';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Entry.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar las entradas');
    }
  }

  Future<void> restoreEntry(int id) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/entry/$id/restore'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Error al restaurar la entrada');
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
