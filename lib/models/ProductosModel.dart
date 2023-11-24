class ProductosModel {
  final int id;
  final String nombre;
  final int cantidad;
  final double precio; 

  const ProductosModel({
    required this.id,
    required this.nombre,
    required this.cantidad,
    required this.precio, 
  });

  factory ProductosModel.fromJson(Map<String, dynamic> json) {
  return ProductosModel(
    id: json['id'] ?? 0,
    nombre: json['nombre'] ?? "",
    cantidad: json['cantidad'] ?? 0,
    precio: json['precio'] ?? 0.0,
  );
}

}
