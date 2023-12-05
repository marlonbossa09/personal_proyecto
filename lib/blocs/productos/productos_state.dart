part of 'productos_bloc.dart';

@immutable
abstract class ProductosState {
  final bool exitsProductos;
  final List<ProductoConUsuarioModel>? productos;
  final bool chargin;

  const ProductosState({
    this.exitsProductos = false,
    this.productos,
    this.chargin = false
  });
}

class ProductosInitialState extends ProductosState {
  ProductosInitialState():super(exitsProductos: false, productos: null,chargin: false);
}

class ProductosSetState extends ProductosState {
  final List<ProductoConUsuarioModel> productos;
  final bool chargin;
  const ProductosSetState(this.productos,this.chargin) : super(exitsProductos: true, productos: productos,chargin: chargin);
  
}