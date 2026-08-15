import 'package:flutter/material.dart';

import '../models/carrito.dart';
import '../models/libro.dart';
import '../services/api_service.dart';
import '../widgets/book_card.dart';
import 'carrito_screen.dart';
import 'categories_screen.dart';
import 'contact_screen.dart';
import 'orders_screen.dart';

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
  final TextEditingController _buscadorController =
      TextEditingController();

  final ApiService _apiService = ApiService();

  List<Libro> libros = [];
  List<Libro> librosFiltrados = [];

  TipoOrden _ordenActual = TipoOrden.titulo;

  bool _cargando = true;
  bool _apiConectada = false;

  @override
  void initState() {
    super.initState();
    _cargarLibrosDesdeApi();
  }

  Future<void> _cargarLibrosDesdeApi() async {
    try {
      final productos =
          await _apiService.obtenerProductos();

      if (!mounted) {
        return;
      }

      setState(() {
        libros = productos;
        librosFiltrados = List.from(productos);
        _cargando = false;
        _apiConectada = true;
      });

      _ordenarLibros();
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _cargando = false;
        _apiConectada = false;
      });
    }
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
        librosFiltrados.sort(
          (a, b) => a.titulo.compareTo(b.titulo),
        );
        break;

      case TipoOrden.precioAsc:
        librosFiltrados.sort(
          (a, b) => a.precio.compareTo(b.precio),
        );
        break;

      case TipoOrden.precioDesc:
        librosFiltrados.sort(
          (a, b) => b.precio.compareTo(a.precio),
        );
        break;

      case TipoOrden.calificacion:
        librosFiltrados.sort(
          (a, b) => b.calificacion.compareTo(a.calificacion),
        );
        break;
    }

    if (mounted) {
      setState(() {});
    }
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

  Future<void> _abrirCategorias() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CategoriesScreen(),
      ),
    );

    setState(() {});
  }

  Future<void> _abrirPedidos() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const OrdersScreen(),
      ),
    );
  }

  Future<void> _abrirContacto() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ContactScreen(),
      ),
    );
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
          'BookStore',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Mis pedidos',
            icon: const Icon(Icons.receipt_long),
            onPressed: _abrirPedidos,
          ),
          IconButton(
            tooltip: 'Contacto y soporte',
            icon: const Icon(Icons.support_agent),
            onPressed: _abrirContacto,
          ),
          IconButton(
            tooltip: 'Categorías',
            icon: const Icon(Icons.category),
            onPressed: _abrirCategorias,
          ),
          IconButton(
            tooltip: 'Carrito',
            icon: const Icon(Icons.shopping_cart),
            onPressed: _abrirCarrito,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              25,
            ),
            decoration: const BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  '¡Bienvenido!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Libros disponibles: '
                  '${librosFiltrados.length}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Icon(
                      _apiConectada
                          ? Icons.cloud_done
                          : Icons.cloud_off,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _apiConectada
                          ? 'API conectada'
                          : 'API no disponible',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: _buscadorController,
                  onChanged: _buscarLibros,
                  decoration: InputDecoration(
                    hintText:
                        'Buscar por título, autor o categoría...',
                    prefixIcon:
                        const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text(
                  'Catálogo',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(),

                PopupMenuButton<TipoOrden>(
                  tooltip: 'Ordenar',
                  icon: const Icon(Icons.sort),
                  onSelected: (valor) {
                    _ordenActual = valor;
                    _ordenarLibros();
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: TipoOrden.titulo,
                      child: Text('Título (A-Z)'),
                    ),
                    PopupMenuItem(
                      value: TipoOrden.precioAsc,
                      child: Text(
                        'Precio: menor a mayor',
                      ),
                    ),
                    PopupMenuItem(
                      value: TipoOrden.precioDesc,
                      child: Text(
                        'Precio: mayor a menor',
                      ),
                    ),
                    PopupMenuItem(
                      value: TipoOrden.calificacion,
                      child: Text(
                        'Mejor calificación',
                      ),
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
                    '${Carrito.instancia.cantidadProductos}',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 5),

          Expanded(
            child: _cargando
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : librosFiltrados.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 70,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'No se encontraron libros',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding:
                            const EdgeInsets.only(
                          bottom: 15,
                        ),
                        itemCount:
                            librosFiltrados.length,
                        itemBuilder:
                            (context, index) {
                          return BookCard(
                            libro:
                                librosFiltrados[index],
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