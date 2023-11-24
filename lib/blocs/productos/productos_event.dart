part of 'productos_bloc.dart';

@immutable
abstract class ProductossEvent {}

class InitialProductossEvent extends ProductossEvent {}


class ChangeDataProductosEvent extends ProductossEvent{
  final List<ProductosModel> productos;
  final bool chargin;
  ChangeDataProductosEvent(this.productos,this.chargin);
}

