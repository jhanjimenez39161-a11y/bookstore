import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/libro.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.4:3000';

  Future<List<Libro>> obtenerProductos() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/productos'),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'No fue posible obtener los productos.',
      );
    }

    final List<dynamic> datos =
        jsonDecode(response.body) as List<dynamic>;

    return datos.map((producto) {
      return Libro(
        titulo: producto['titulo'] as String,
        autor: producto['autor'] as String,
        precio: (producto['precio'] as num).toDouble(),
        calificacion: 4.8,
        descripcion: 'Producto disponible en BookStore.',
        imagen: _imagenPorTitulo(
          producto['titulo'] as String,
        ),
        categoria: producto['categoria'] as String,
        etiqueta: 'Disponible',
      );
    }).toList();
  }

  Future<Map<String, dynamic>> consultarEstadoPedido(
    int idPedido,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/api/pedidos/estado/$idPedido',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'No fue posible consultar el estado del pedido.',
      );
    }

    return jsonDecode(response.body)
        as Map<String, dynamic>;
  }

  String _imagenPorTitulo(String titulo) {
    switch (titulo) {
      case 'Clean Code':
        return 'assets/images/clean_code.jpg';

      case 'Hábitos Atómicos':
        return 'assets/images/habitos_atomicos.jpg';

      case 'Cien años de soledad':
        return 'assets/images/cien_años.jpg';

      case 'El Principito':
        return 'assets/images/principito.jpg';

      case 'Padre Rico, Padre Pobre':
        return 'assets/images/padre_rico.jpg';

      case 'Sapiens':
        return 'assets/images/sapiens.jpg';

      case 'Flutter en Acción':
        return 'assets/images/flutter_accion.jpg';

      case 'Aprendiendo Dart':
        return 'assets/images/dart.jpg';

      default:
        return 'assets/images/clean_code.jpg';
    }
  }
}