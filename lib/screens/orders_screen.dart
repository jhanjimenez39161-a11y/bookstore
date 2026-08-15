import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database/database_helper.dart';
import '../services/api_service.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final NumberFormat formatoPrecio = NumberFormat.currency(
    locale: 'es_CO',
    symbol: r'$',
    decimalDigits: 0,
  );

  final ApiService _apiService = ApiService();

  List<Map<String, dynamic>> _pedidos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarPedidos();
  }

  Future<void> _cargarPedidos() async {
    final pedidos = await DatabaseHelper.instance.obtenerPedidos();

    final pedidosActualizados =
        <Map<String, dynamic>>[];

    for (final pedido in pedidos) {
      final pedidoActualizado =
          Map<String, dynamic>.from(pedido);

      final int id = pedido['id'] as int;

      try {
        final datosApi =
            await _apiService.consultarEstadoPedido(id);

        final estadoApi = datosApi['estado'];

        if (estadoApi is String && estadoApi.isNotEmpty) {
          pedidoActualizado['estado'] = estadoApi;
        }
      } catch (e) {
        // Si la API no está disponible,
        // se conserva el estado almacenado en SQLite.
      }

      pedidosActualizados.add(pedidoActualizado);
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _pedidos = pedidosActualizados;
      _cargando = false;
    });
  }

  Color _colorEstado(String estado) {
    switch (estado) {
      case 'En preparación':
        return Colors.orange;

      case 'En camino':
        return Colors.blue;

      case 'Entregado':
        return Colors.green;

      default:
        return Colors.grey;
    }
  }

  IconData _iconoEstado(String estado) {
    switch (estado) {
      case 'En preparación':
        return Icons.inventory_2;

      case 'En camino':
        return Icons.local_shipping;

      case 'Entregado':
        return Icons.check_circle;

      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis pedidos'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: _cargando
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _pedidos.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long,
                        size: 70,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 15),
                      Text(
                        'No tienes pedidos registrados',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _cargarPedidos,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _pedidos.length,
                    itemBuilder: (context, index) {
                      final pedido = _pedidos[index];

                      final int id =
                          pedido['id'] as int;

                      final double total =
                          (pedido['total'] as num)
                              .toDouble();

                      final String metodoPago =
                          pedido['metodoPago'] as String;

                      final String estado =
                          pedido['estado'] as String;

                      final DateTime fecha =
                          DateTime.parse(
                        pedido['fecha'] as String,
                      );

                      return Card(
                        margin: const EdgeInsets.only(
                          bottom: 16,
                        ),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.receipt_long,
                                    color: Colors.indigo,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Pedido #$id',
                                    style:
                                        const TextStyle(
                                      fontSize: 20,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 15),

                              Text(
                                'Fecha: '
                                '${DateFormat('dd/MM/yyyy HH:mm').format(fecha)}',
                              ),

                              const SizedBox(height: 6),

                              Text(
                                'Método de pago: '
                                '$metodoPago',
                              ),

                              const SizedBox(height: 6),

                              Text(
                                'Total: '
                                '${formatoPrecio.format(total)}',
                                style:
                                    const TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 18),

                              Container(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration:
                                    BoxDecoration(
                                  color: _colorEstado(
                                    estado,
                                  ).withValues(
                                    alpha: 0.12,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(
                                    12,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      _iconoEstado(
                                        estado,
                                      ),
                                      color:
                                          _colorEstado(
                                        estado,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      estado,
                                      style: TextStyle(
                                        color:
                                            _colorEstado(
                                          estado,
                                        ),
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 18),

                              Row(
                                children: [
                                  _EstadoPaso(
                                    titulo:
                                        'Preparación',
                                    activo: estado ==
                                        'En preparación',
                                    completado: estado !=
                                        'En preparación',
                                  ),

                                  Expanded(
                                    child: Container(
                                      height: 2,
                                      color: estado ==
                                              'En preparación'
                                          ? Colors
                                              .grey
                                              .shade300
                                          : Colors.indigo,
                                    ),
                                  ),

                                  _EstadoPaso(
                                    titulo: 'En camino',
                                    activo: estado ==
                                        'En camino',
                                    completado: estado ==
                                        'Entregado',
                                  ),

                                  Expanded(
                                    child: Container(
                                      height: 2,
                                      color: estado ==
                                              'Entregado'
                                          ? Colors.indigo
                                          : Colors
                                              .grey
                                              .shade300,
                                    ),
                                  ),

                                  _EstadoPaso(
                                    titulo: 'Entregado',
                                    activo: estado ==
                                        'Entregado',
                                    completado: estado ==
                                        'Entregado',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

class _EstadoPaso extends StatelessWidget {
  final String titulo;
  final bool activo;
  final bool completado;

  const _EstadoPaso({
    required this.titulo,
    required this.activo,
    required this.completado,
  });

  @override
  Widget build(BuildContext context) {
    final bool destacado = activo || completado;

    return SizedBox(
      width: 70,
      child: Column(
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: destacado
                ? Colors.indigo
                : Colors.grey.shade300,
            child: Icon(
              completado
                  ? Icons.check
                  : Icons.circle,
              size: 14,
              color: destacado
                  ? Colors.white
                  : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            titulo,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: activo
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}