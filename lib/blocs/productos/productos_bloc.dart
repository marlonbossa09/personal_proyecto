import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:personal_proyecto/models/UsuarioGeneralModel.dart';

part 'productos_event.dart';
part 'productos_state.dart';

class ProductosBloc extends Bloc<ProductossEvent, ProductosState> {
  ProductosBloc() : super(ProductosInitialState()) {
    loadEvents();
  }

  loadEvents(){
    cargarData();
    initialState();
  }
  cargarData(){
    on<ChangeDataProductosEvent>((event, emit) {
      emit(ProductosSetState(event.productos,event.chargin));
    });
  }

  initialState(){
    on<InitialProductossEvent>((event, emit) {
        emit(ProductosInitialState());
    });
  }
}
