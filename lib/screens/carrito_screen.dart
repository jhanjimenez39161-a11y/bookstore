import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/carrito.dart';
import '../models/item_carrito.dart';

class CarritoScreen extends StatefulWidget {
  const CarritoScreen({super.key});

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  final NumberFormat formatoPrecio = NumberFormat.currency(
    locale: 'es_CO',
    symbol: '\$',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    final List<ItemCarrito> items = Carrito.instancia.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Carrito de compras"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: items.isEmpty
          ? const Center(
              child: Text(
                "Tu carrito está vacío",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(
                                  Icons.menu_book,
                                  color: Colors.indigo,
                                ),
                                title: Text(item.libro.titulo),
                                subtitle: Text(
                                  formatoPrecio.format(item.libro.precio),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      Carrito.instancia.eliminar(item);
                                    });
                                  },
                                ),
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        Carrito.instancia.disminuir(item);
                                      });
                                    },
                                    icon: const Icon(Icons.remove_circle),
                                  ),

                                  Text(
                                    "${item.cantidad}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        Carrito.instancia.aumentar(item);
                                      });
                                    },
                                    icon: const Icon(Icons.add_circle),
                                  ),
                                ],
                              ),

                              Text(
                                "Subtotal: ${formatoPrecio.format(item.subtotal)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 8,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Total:",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            formatoPrecio.format(Carrito.instancia.total),
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              Carrito.instancia.vaciar();
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Compra realizada correctamente."),
                              ),
                            );
                          },
                          icon: const Icon(Icons.payment),
                          label: const Text("Finalizar compra"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}