import 'libro.dart';

class ItemCarrito {
  final Libro libro;
  int cantidad;

  ItemCarrito({
    required this.libro,
    this.cantidad = 1,
  });

  double get subtotal => libro.precio * cantidad;
}