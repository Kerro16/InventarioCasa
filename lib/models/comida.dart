class Comida {
  final int id;
  final String nombre;
  final String categoria;
  final double cantidad;
  final String fechaCaducidad;
  final String ubicacion;
  final double precio;

  Comida({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.cantidad,
    required this.fechaCaducidad,
    required this.ubicacion,
    required this.precio
  });

  // 🔄 Conversión desde JSON
  factory Comida.fromJson(Map<String, dynamic> json) {
    return Comida(
      id: json['id'],
      nombre: json['nombre'],
      categoria: json['categoria'],
      cantidad: json['cantidad'],
      fechaCaducidad: json['fechaCaducidad'],
      ubicacion: json['ubicacion'],
      precio: json['precio'],
    );
  }

  // 🔁 Conversión a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'categoria': categoria,
      'cantidad': cantidad,
      'fechaCaducidad': fechaCaducidad,
      'ubicacion': ubicacion,
      'precio': precio,
    };
  }
}