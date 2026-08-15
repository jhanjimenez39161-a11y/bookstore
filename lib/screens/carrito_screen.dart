import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database/database_helper.dart';
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
    symbol: r'$',
    decimalDigits: 0,
  );

  bool _procesandoPedido = false;

  Future<void> _abrirConfirmacionPedido() async {
    if (Carrito.instancia.items.isEmpty) {
      return;
    }

    String metodoPago = 'Contra entrega';

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Confirmar pedido'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selecciona el método de pago:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  DropdownButtonFormField<String>(
                    initialValue: metodoPago,
                    decoration: const InputDecoration(
                      labelText: 'Método de pago',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.payment),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Contra entrega',
                        child: Text('Contra entrega'),
                      ),
                      DropdownMenuItem(
                        value: 'Pago digital',
                        child: Text('Pago digital'),
                      ),
                    ],
                    onChanged: (valor) {
                      if (valor != null) {
                        setDialogState(() {
                          metodoPago = valor;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  Text(
                    metodoPago == 'Contra entrega'
                        ? 'Pagarás cuando recibas tu pedido.'
                        : 'El pago digital se procesará mediante una plataforma de pago.',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    'Total: ${formatoPrecio.format(Carrito.instancia.total)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, false);
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, true);
                  },
                  child: const Text('Confirmar pedido'),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirmar == true) {
      await _guardarPedido(metodoPago);
    }
  }

  Future<void> _guardarPedido(String metodoPago) async {
    if (_procesandoPedido) {
      return;
    }

    setState(() {
      _procesandoPedido = true;
    });

    try {
      final total = Carrito.instancia.total;
      final fecha = DateTime.now().toIso8601String();

      final idPedido =
          await DatabaseHelper.instance.insertarPedido(
        fecha: fecha,
        total: total,
        metodoPago: metodoPago,
        estado: 'En preparación',
      );

      if (!mounted) {
        return;
      }

      Carrito.instancia.vaciar();

      setState(() {
        _procesandoPedido = false;
      });

      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Pedido confirmado'),
            content: Text(
              'Tu pedido fue registrado correctamente.\n\n'
              'Número de pedido: #$idPedido\n'
              'Método de pago: $metodoPago\n'
              'Estado: En preparación',
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );

      if (!mounted) {
        return;
      }

      setState(() {});
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _procesandoPedido = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No fue posible registrar el pedido.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<ItemCarrito> items = Carrito.instancia.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito de compras'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: items.isEmpty
          ? const Center(
              child: Text(
                'Tu carrito está vacío',
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
                                title: Text(
                                  item.libro.titulo,
                                ),
                                subtitle: Text(
                                  formatoPrecio.format(
                                    item.libro.precio,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      Carrito.instancia
                                          .eliminar(item);
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
                                        Carrito.instancia
                                            .disminuir(item);
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.remove_circle,
                                    ),
                                  ),

                                  Text(
                                    '${item.cantidad}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        Carrito.instancia
                                            .aumentar(item);
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.add_circle,
                                    ),
                                  ),
                                ],
                              ),

                              Text(
                                'Subtotal: '
                                '${formatoPrecio.format(item.subtotal)}',
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
                            'Total:',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const Spacer(),

                          Text(
                            formatoPrecio.format(
                              Carrito.instancia.total,
                            ),
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
                          onPressed: _procesandoPedido
                              ? null
                              : _abrirConfirmacionPedido,
                          icon: _procesandoPedido
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.payment),
                          label: Text(
                            _procesandoPedido
                                ? 'Procesando...'
                                : 'Finalizar compra',
                          ),
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