import 'item_carrito.dart';
import 'libro.dart';

class Carrito {
  Carrito._();

  static final Carrito instancia = Carrito._();

  final List<ItemCarrito> _items = [];

  List<ItemCarrito> get items => List.unmodifiable(_items);

  void agregar(Libro libro) {
    for (final item in _items) {
      if (item.libro.titulo == libro.titulo) {
        item.cantidad++;
        return;
      }
    }

    _items.add(
      ItemCarrito(
        libro: libro,
      ),
    );
  }

  void aumentar(ItemCarrito item) {
    item.cantidad++;
  }

  void disminuir(ItemCarrito item) {
    if (item.cantidad > 1) {
      item.cantidad--;
    } else {
      _items.remove(item);
    }
  }

  void eliminar(ItemCarrito item) {
    _items.remove(item);
  }

  void vaciar() {
    _items.clear();
  }

  double get total {
    double suma = 0;

    for (final item in _items) {
      suma += item.subtotal;
    }

    return suma;
  }

  int get cantidadProductos {
    int total = 0;

    for (final item in _items) {
      total += item.cantidad;
    }

    return total;
  }

  int get cantidadTipos => _items.length;
}