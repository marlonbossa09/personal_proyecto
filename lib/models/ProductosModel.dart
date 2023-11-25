class ProductosModel {
  final int id;
  final String nombre;
  final String descripcion;
  final String cantidad;
  final String precio; 

  const ProductosModel({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.cantidad,
    required this.precio, 
  });

  factory ProductosModel.fromJson(Map<String, dynamic> json) {
  return ProductosModel(
    id: json['id'] ?? 0,
    nombre: json['nombre'] ?? "",
    descripcion: json['descripcion'] ?? "",
    cantidad: json['cantidad'] ?? "",
    precio: json['precio'] ?? "",
  );
}

}
