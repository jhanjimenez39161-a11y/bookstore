import 'package:flutter/material.dart';

import '../models/libro.dart';
import '../models/libros_data.dart';
import '../widgets/book_card.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  List<String> _obtenerCategorias() {
    final categorias = libros
        .map((libro) => libro.categoria)
        .toSet()
        .toList();

    categorias.sort();

    return categorias;
  }

  List<Libro> _obtenerLibrosPorCategoria(String categoria) {
    return libros
        .where((libro) => libro.categoria == categoria)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final categorias = _obtenerCategorias();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categorias.length,
        itemBuilder: (context, index) {
          final categoria = categorias[index];
          final librosCategoria =
              _obtenerLibrosPorCategoria(categoria);

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ExpansionTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.indigo,
                child: Icon(
                  Icons.menu_book,
                  color: Colors.white,
                ),
              ),
              title: Text(
                categoria,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              subtitle: Text(
                '${librosCategoria.length} '
                '${librosCategoria.length == 1 ? 'libro' : 'libros'}',
              ),
              children: librosCategoria.map((libro) {
                return BookCard(
                  libro: libro,
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}