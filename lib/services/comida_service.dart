import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/comida.dart';

class ComidaService {
  final String baseUrl = 'http://192.168.0.20:8080/api/comida'; // Cambia según tu entorno

  // 🔍 Obtener la lista de comidas
  Future<List<Comida>> listar() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/listar'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((e) => Comida.fromJson(e)).toList();
      } else {
        throw Exception('Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error al conectarse al backend: $e');
    }
  }


  // 📝 Actualizar comida
  Future<void> actualizar(Comida comida) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/actualizar/${comida.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(comida.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception('Error al actualizar: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('No se pudo actualizar la comida: $e');
    }
  }

  // ❌ Eliminar comida
  Future<void> eliminar(int id) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/eliminar/$id'));
      if (response.statusCode != 200) {
        throw Exception('Error al eliminar: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('No se pudo eliminar la comida: $e');
    }
  }

  Future<void> agregarDesdeJson(Map<String, dynamic> jsonComida) async {
    final response = await http.post(
      Uri.parse('$baseUrl/guardar'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(jsonComida),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al agregar: ${response.statusCode}');
    }
  }

  Future<List<String>> autocompletar(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/autocompletar?q=$query'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<String>();
    } else {
      return [];
    }
  }
}