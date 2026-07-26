import 'package:flutter/material.dart';

import '../models/carrito.dart';
import '../models/libros_data.dart';
import '../models/libro.dart';
import '../widgets/book_card.dart';
import 'carrito_screen.dart';

enum TipoOrden {
  titulo,
  precioAsc,
  precioDesc,
  calificacion,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _buscadorController = TextEditingController();

  List<Libro> librosFiltrados = [];
  TipoOrden _ordenActual = TipoOrden.titulo;

  @override
  void initState() {
    super.initState();
    librosFiltrados = List.from(libros);
    _ordenarLibros();
  }

  void _buscarLibros(String texto) {
    if (texto.trim().isEmpty) {
      librosFiltrados = List.from(libros);
    } else {
      final busqueda = texto.toLowerCase();

      librosFiltrados = libros.where((libro) {
        return libro.titulo.toLowerCase().contains(busqueda) ||
            libro.autor.toLowerCase().contains(busqueda) ||
            libro.categoria.toLowerCase().contains(busqueda);
      }).toList();
    }

    _ordenarLibros();
  }

  void _ordenarLibros() {
    switch (_ordenActual) {
      case TipoOrden.titulo:
        librosFiltrados.sort((a, b) => a.titulo.compareTo(b.titulo));
        break;

      case TipoOrden.precioAsc:
        librosFiltrados.sort((a, b) => a.precio.compareTo(b.precio));
        break;

      case TipoOrden.precioDesc:
        librosFiltrados.sort((a, b) => b.precio.compareTo(a.precio));
        break;

      case TipoOrden.calificacion:
        librosFiltrados.sort(
            (a, b) => b.calificacion.compareTo(a.calificacion));
        break;
    }

    setState(() {});
  }

  Future<void> _abrirCarrito() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CarritoScreen(),
      ),
    );

    setState(() {});
  }

  @override
  void dispose() {
    _buscadorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "BookStore",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: _abrirCarrito,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 25),
            decoration: const BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "¡Bienvenido!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Libros disponibles: ${librosFiltrados.length}",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _buscadorController,
                  onChanged: _buscarLibros,
                  decoration: InputDecoration(
                    hintText: "Buscar por título, autor o categoría...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text(
                  "Catálogo",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                PopupMenuButton<TipoOrden>(
                  tooltip: "Ordenar",
                  icon: const Icon(Icons.sort),
                  onSelected: (valor) {
                    _ordenActual = valor;
                    _ordenarLibros();
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: TipoOrden.titulo,
                      child: Text("Título (A-Z)"),
                    ),
                    PopupMenuItem(
                      value: TipoOrden.precioAsc,
                      child: Text("Precio: menor a mayor"),
                    ),
                    PopupMenuItem(
                      value: TipoOrden.precioDesc,
                      child: Text("Precio: mayor a menor"),
                    ),
                    PopupMenuItem(
                      value: TipoOrden.calificacion,
                      child: Text("Mejor calificación"),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Chip(
                  avatar: const Icon(
                    Icons.shopping_cart,
                    size: 18,
                  ),
                  label: Text(
                    "${Carrito.instancia.cantidadProductos}",
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: librosFiltrados.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 70,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 12),
                        Text(
                          "No se encontraron libros",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 15),
                    itemCount: librosFiltrados.length,
                    itemBuilder: (context, index) {
                      return BookCard(
                        libro: librosFiltrados[index],
                        onRegresar: () {
                          setState(() {});
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}