import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_proyecto/blocs/events/events_bloc.dart';
import 'package:personal_proyecto/blocs/user/user_bloc.dart';
import 'package:personal_proyecto/models/EstudiantesModel.dart';
import 'package:personal_proyecto/screens/crearComentarios.dart';
import 'package:personal_proyecto/screens/publicaciones.dart';
import 'package:personal_proyecto/services/productoService.dart';
import 'package:personal_proyecto/util/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class VerProductos extends StatefulWidget {
  ProductoConUsuarioModel productos;
  VerProductos({super.key, required this.productos});
  @override
  State<VerProductos> createState() => _VerProductosState();
}

class _VerProductosState extends State<VerProductos> {
  Utils util = Utils();
  TextStyle textStyle =
      const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold);
  var size;
  var eventsBloc;
  var usuariosBloc;
  var user_sesionBloc;
  List<Estudiantes> users = [];
  List<ProductoConUsuarioModel> productos = [];

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

      final ProductoConUsuarioModel producto = await ProductoService()
          .verProductoId(widget.productos.id, state.user!.token);

      setState(() {
        productos = [producto];
      });
    } catch (error) {
      print('Error al obtener el producto: $error');
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
                          {'route': Publicaciones()}));
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
                            'INFORMACIÓN DEL PRODUCTO',
                            12.0,
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
                ProductoConUsuarioModel discusion = productos[index];
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

  Widget _contenedorParticipantes(ProductoConUsuarioModel productos) {
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
                    Text(
                      '${productos.creador.nombre} ${productos.creador.apellido}',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  '${productos.nombre}',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  ' ${productos.descripcion}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  'Precio: ${productos.precio}',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'Cantidad disponible: ${productos.cantidad}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 30),
                BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirmación'),
                                  content: Text('Se enviará al chat privado'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        final url =
                                            'https://api.whatsapp.com/send?phone=57${productos.creador.celular}&text=we';
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else {
                                          throw 'No se pudo lanzar el enlace $url';
                                        }
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Aceptar'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.blue,
                            primary: Colors.blue,
                          ),
                          child: Text('Contactar',
                              style: TextStyle(color: Colors.white)),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            eventsBloc.add(ChangeStateMenu([
                              true,
                              false,
                              false,
                              false,
                              false,
                              false,
                            ], {
                              'route': CrearComentarios(
                                editar: false,
                                userEdit: productos,
                              )
                            }));
                          },
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.blue,
                            primary: Colors.blue,
                          ),
                          child: Text('Comentar',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 20),
                _contenedorComentarios(productos.comentarios),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _contenedorComentarios(List<Comentario> comentarios) {
    if (comentarios.isEmpty) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: formNoData(),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Comentarios',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: comentarios.map((comentario) {
              return _contenedorComentario(comentario);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _contenedorComentario(Comentario comentario) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${comentario.autor.nombre}', // Asegúrate de tener la propiedad autor en tu modelo Comentario
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            '${comentario.contenido}',
            style: TextStyle(fontSize: 14),
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
            'No se encontraron comentarios para mostrar.',
            style: TextStyle(color: Colors.blue),
          ),
          Text("Oprima el boton comentar para realizar un comentario."),
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
