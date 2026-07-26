class Libro {
  final String titulo;
  final String autor;
  final double precio;
  final double calificacion;
  final String descripcion;

  // NUEVOS CAMPOS
  final String imagen;
  final String categoria;
  final String etiqueta;

  Libro({
    required this.titulo,
    required this.autor,
    required this.precio,
    required this.calificacion,
    required this.descripcion,
    required this.imagen,
    required this.categoria,
    required this.etiqueta,
  });
}