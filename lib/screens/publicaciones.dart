import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_proyecto/blocs/events/events_bloc.dart';
import 'package:personal_proyecto/blocs/productos/productos_bloc.dart';
import 'package:personal_proyecto/blocs/user/user_bloc.dart';
import 'package:personal_proyecto/models/ProductosModel.dart';
import 'package:personal_proyecto/models/EstudiantesModel.dart';
import 'package:personal_proyecto/screens/page1.dart';
import 'package:personal_proyecto/services/productoService.dart';
import 'package:personal_proyecto/util/utils.dart';

class Publicaciones extends StatefulWidget {
  @override
  State<Publicaciones> createState() => _PublicacionesState();
}

class _PublicacionesState extends State<Publicaciones> {
  Utils util = Utils();
  TextStyle textStyle =
      const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold);
  var size;
  var eventsBloc;
  var usuariosBloc;
  var user_sesionBloc;
  List<Estudiantes> users = [];
  List<ProductosModel> productos = [];

  late Estudiantes hola;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _cargarDatos() async {
    try {
      user_sesionBloc = BlocProvider.of<UserBloc>(context);
      final state = user_sesionBloc.state;
      final List<ProductosModel> producto =
          await ProductoService().verProductos(state.user!.token);

      setState(() {
        productos = producto;
      });
    } catch (error) {
      print('Error al obtener la lista de foros: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    eventsBloc = BlocProvider.of<EventsBloc>(context);
    return Expanded(
        flex: 8,
        child: Container(
            padding: const EdgeInsets.all(5),
            decoration: util.boxDecorationDiv(),
            height: size.height * 1,
            child: _form()));
  }

  Widget _form() {
  return Container(
    height: MediaQuery.of(context).size.height * 1,
    padding: const EdgeInsets.all(5),
    decoration: util.boxDecorationDiv(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    eventsBloc.add(ChangeStateMenu(
                        [true, true, false, false, false],
                        {'route': Page1()}));
                  },
                  icon: Icon(Icons.arrow_back),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        util.tituloBlack(
                          'Publicaciones',
                          18.0,
                          30,
                          Colors.black,
                          true,
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, index) {
              ProductosModel discusion = productos[index];
              return _contenedorParticipantes(discusion);
            },
          ),
        ),
      ],
    ),
  );
}


  String removeHtmlTags(String htmlString) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '');
  }

  Widget _contenedorParticipantes(ProductosModel productos) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(38, 63, 81, 181),
        border: Border.all(
          color: Color.fromARGB(221, 158, 158, 158),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      margin: EdgeInsets.only(right: 10),
                      child:
                          Image.asset('assets/falcao.jpg', fit: BoxFit.cover),
                    ),
                    const Text(
                      'Radamel Falcao',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  '${productos.nombre}',
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  ' ${productos.descripcion}',
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 10),
                Text(
                  'Precio: ${productos.precio}',
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  'Cantidad disponible: ${productos.cantidad}',
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.blue,
                    primary: Colors.blue,
                  ),
                  child: Text('Ver', style: TextStyle(color: Colors.white)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget formNoData() {
    return Container(
      decoration: util.boxDecoration(),
      child: _listTitle(
          const Text(
            'No se encontraron datos para mostrar.',
            style: TextStyle(color: Colors.blue),
          ),
          Text("Oprima el boton buscar para realizar una consulta."),
          const Icon(Icons.person_outline_outlined, color: Colors.blue)),
    );
  }

  Widget _listTitle(Widget titulo, Widget description, Widget? icono) {
    return ListTile(
      leading: icono,
      title: titulo,
      subtitle: description,
    );
  }
}
