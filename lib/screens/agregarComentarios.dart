import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_proyecto/blocs/events/events_bloc.dart';
import 'package:personal_proyecto/blocs/user/user_bloc.dart';
import 'package:personal_proyecto/models/UsuarioGeneralModel.dart';
import 'package:personal_proyecto/screens/inicio.dart';
import 'package:personal_proyecto/screens/publicaciones.dart';
import 'package:personal_proyecto/services/comentarioService.dart';
import 'package:personal_proyecto/services/productoService.dart';
import 'package:personal_proyecto/util/utils.dart';

class AgregarComentario extends StatefulWidget {
  final editar;
  final ProductoConUsuarioModel? userEdit;
  AgregarComentario({super.key, this.editar, required this.userEdit});

  @override
  State<AgregarComentario> createState() => _AgregarComentarioState();
}

class _AgregarComentarioState extends State<AgregarComentario> {
  Utils util = Utils();
  TextStyle textStyle =
      const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold);
  var size;
  var eventsBloc;
  var usuariosBloc;
  var user_sesionBloc;
  List<UsuarioGeneralModel> users = [];
  final _formKey = GlobalKey<FormState>();
  late UsuarioGeneralModel hola;
  final mensajeController = TextEditingController();
  final contenidoController = TextEditingController();

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
      child: ListView(
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
                            {'route': Inicio()}));
                      },
                      icon: Icon(Icons.arrow_back)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          util.tituloBlack(
                            'Agregar comentarios',
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
                        children: [
                          Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.blue,
                                    width: 4.0,
                                  ),
                                ),
                              ),
                              child: Text('Mensajes'))
                        ],
                      ),
                    ),
                  ),
                  _contenedorParticipantes(),
                ],
              ),
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

  Widget _contenedorParticipantes() {
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
                const Text(
                  '¿Qué desea comentar?',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                crearTextFormMensaje(),
                SizedBox(
                  height: 20,
                ),
                BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Visibility(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                Map<String, dynamic> datosUser = {
                                  "contenido": contenidoController.text,
                                };

                                try {
                                  final Map<String, dynamic> data = widget
                                          .editar
                                      ? await ProductoService().editarProducto(
                                          datosUser,
                                          widget.userEdit!.id.toString(),
                                          state.user!.token)
                                      : await ComentarioService()
                                          .crearComentario(
                                              datosUser,
                                              widget.userEdit!.id,
                                              state.user!.token);

                                  if (data['success']) {
                                    contenidoController.clear();
                                    util.message(
                                      context,
                                      widget.editar
                                          ? 'Se actualizó correctamente'
                                          : 'Se creó correctamente',
                                      Colors.green,
                                    );
                                    eventsBloc.add(ChangeStateMenu([
                                      true,
                                      false,
                                      false,
                                      false,
                                      false,
                                      false
                                    ], {
                                      'route': Publicaciones()
                                    }));
                                  } else {
                                    util.message(
                                      context,
                                      widget.editar
                                          ? 'No se pudo editar la empresa'
                                          : 'No se pudo crear la empresa',
                                      Colors.red,
                                    );
                                  }
                                } catch (e) {
                                  print("Error: $e");
                                  util.message(
                                      context, 'Ocurrió un error', Colors.red);
                                }
                              }
                            },
                            child:
                                Text(widget.editar ? "Actualizar" : "Guardar"),
                          ),
                        )
                      ],
                    );
                  },
                ),
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

  Widget crearTextFormMensaje() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        util.tituloBlack('Escribe aquí:', 10.0, 15, Colors.black, true),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: TextFormField(
            maxLines: 5,
            controller: mensajeController,
            decoration: util.inputDecoration('', false),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'subTitle';
              }
              return null;
            },
          ),
        ),
      ],
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
