import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_proyecto/blocs/events/events_bloc.dart';
import 'package:personal_proyecto/blocs/productos/productos_bloc.dart';
import 'package:personal_proyecto/blocs/user/user_bloc.dart';
import 'package:personal_proyecto/models/UsuarioGeneralModel.dart';
import 'package:personal_proyecto/screens/verProductos.dart';
import 'package:personal_proyecto/services/comentarioService.dart';
import 'package:personal_proyecto/services/productoService.dart';
import 'package:personal_proyecto/util/utils.dart';
import 'package:personal_proyecto/widgets/personalizados.dart';

class CrearComentarios extends StatefulWidget {
  final editar;
  final ProductoConUsuarioModel? userEdit;
  CrearComentarios({super.key, this.editar, this.userEdit});

  @override
  State<CrearComentarios> createState() => _CrearComentariosState();
}

class _CrearComentariosState extends State<CrearComentarios> {
  Utils util = Utils();

  List<Map> roles = [
    {"id": "L", "nombre": "Lider"},
  ];

  var eventsBloc;
  var productosBloc;

  final _formKey = GlobalKey<FormState>();
  final contenidoController = TextEditingController();

  final ValueNotifier<bool> _changePassword = ValueNotifier<bool>(false);
  TextStyle textStyle = const TextStyle(
      color: const Color.fromARGB(255, 12, 60, 100),
      fontWeight: FontWeight.bold);

  @override
  void dispose() {
    super.dispose();
    productosBloc.add(InitialProductossEvent());
  }

  @override
  void initState() {
    super.initState();
    if (widget.editar) {
      _cargarDatos(widget.userEdit!);
      _changePassword.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    eventsBloc = BlocProvider.of<EventsBloc>(context);
    productosBloc = BlocProvider.of<ProductosBloc>(context);
    return Expanded(
      flex: 8,
      child: Container(
        height: MediaQuery.of(context).size.height * 1,
        padding: const EdgeInsets.all(5),
        decoration: util.boxDecorationDiv(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                padding: const EdgeInsets.all(5.0),
                width: MediaQuery.of(context).size.width,
                decoration: util.boxDecoration(),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            util.tituloBlack(
                              '${widget.editar ? 'EDITAR' : 'CREAR'} COMENTARIOS',
                              15.0,
                              20,
                              const Color.fromARGB(255, 12, 60, 100),
                              true,
                            ),
                            const Icon(
                              Icons.person_add_alt_rounded,
                              color: const Color.fromARGB(255, 12, 60, 100),
                              size: 30,
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: _form(widget.editar),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _botonNuevo({'route': VerProductos(productos: widget.userEdit!,)}),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        return Visibility(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                Map<String, dynamic> datosUser = {
                                  "contenido": contenidoController.text,
                                };

                                try {
                                  final Map<String, dynamic> data =
                                  widget.editar
                                      ? await ProductoService()
                                      .editarProducto(
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
                                      'route': VerProductos(productos: widget.userEdit!,)
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
                                  util.message(context,
                                      'Ocurrió un error', Colors.red);
                                }
                              }
                            },
                            child: Text(widget.editar ? "Actualizar" : "Guardar"),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _cargarDatos(ProductoConUsuarioModel producto) {
    contenidoController.text = producto.nombre;
  }

  Widget _botonNuevo(Map menu) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          eventsBloc.add(
              ChangeStateMenu([false, true, false, false, false, false], menu));
        },
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.red,
          primary: Colors.red,
        ),
        child: const Text('Cancelar'),
      ),
    );
  }

  Widget _form(bool editar) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              'Agregue un comentario',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            crearTextFormMensaje(),
          ],
        ),
      ),
    );
  }

  Widget crearTextFormMensaje() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        maxLines: 5,
        controller: contenidoController,
        decoration: util.inputDecoration('', false),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'subTitle';
          }
          return null;
        },
      ),
    );
  }


  Widget crearTextFormField(String title, String subTitle,
      TextEditingController controller, bool pass, bool validarEmail) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        obscureText: pass,
        controller: controller,
        decoration: util.inputDecoration(title, false),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return subTitle;
          } else {
            if (validarEmail) {
              return EmailValidator.validate(controller.text)
                  ? null
                  : "Ingrese un correo valido.";
            }
          }
          return null;
        },
      ),
    );
  }

  Widget crearTextFormFieldPassword(String title, String subTitle,
      TextEditingController controller, bool pass, bool readonly) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ValueListenableBuilder<bool>(
          valueListenable: _changePassword,
          builder: (BuildContext context, bool value, Widget? child) {
            return TextFormField(
              readOnly: !value,
              obscureText: pass,
              controller: controller,
              decoration: util.inputDecoration(title, false),
              validator: (value) {
                if (!widget.editar && (value == null || value.isEmpty)) {
                  return subTitle;
                } else if (widget.editar &&
                    _changePassword.value &&
                    (value == null || value.isEmpty)) {
                  return subTitle;
                }
                return null;
              },
            );
          }),
    );
  }
}
