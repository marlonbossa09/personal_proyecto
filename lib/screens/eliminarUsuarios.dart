import 'dart:js_util';

import 'package:personal_proyecto/blocs/usuarios/usuarios_bloc.dart';
import 'package:personal_proyecto/screens/usuarios.dart';
import 'package:personal_proyecto/services/usuariosService.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_proyecto/blocs/events/events_bloc.dart';
import 'package:personal_proyecto/blocs/user/user_bloc.dart';
import 'package:personal_proyecto/util/utils.dart';
import 'package:personal_proyecto/widgets/personalizados.dart';
import 'package:personal_proyecto/models/UsuarioGeneralModel.dart';

class EliminarUsuarios extends StatefulWidget {
  final eliminar;
  final UsuarioGeneralModel? userEdit;
  const EliminarUsuarios({super.key, this.eliminar, this.userEdit});

  @override
  State<EliminarUsuarios> createState() => _EliminarUsuariosState();
}

class _EliminarUsuariosState extends State<EliminarUsuarios> {
  Utils util = Utils();

  List<Map> roles = [
    {"id": "L", "nombre": "Lider"},
  ];

  var eventsBloc;
  var usuariosBloc;

  final _formKey = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();
  final rolController = TextEditingController();
  final emailController = TextEditingController();
  final apellidoController = TextEditingController();

  final ValueNotifier<bool> _changePassword = ValueNotifier<bool>(false);
  TextStyle textStyle = const TextStyle(
      color: const Color.fromARGB(255, 12, 60, 100),
      fontWeight: FontWeight.bold);

  @override
  void dispose() {
    super.dispose();
    usuariosBloc.add(InitialStateEvent());
  }

  @override
  void initState() {
    super.initState();
    if (widget.eliminar) {
      _cargarDatos(widget.userEdit!);
      _changePassword.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    eventsBloc = BlocProvider.of<EventsBloc>(context);
    usuariosBloc = BlocProvider.of<UsuariosBloc>(context);

    return Expanded(
      flex: 8,
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, stateUser) {
          return Container(
              height: MediaQuery.of(context).size.height * 1,
              padding: const EdgeInsets.all(5),
              decoration: util.boxDecorationDiv(),
              child: ListView(
                children: [
                  Column(
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
                                        util.tituloBlack('Eliminar curso', 15.0,
                                            20, Colors.blue, true),
                                        const Icon(
                                          Icons.person_add_alt_rounded,
                                          color: const Color.fromARGB(
                                              255, 12, 60, 100),
                                          size: 30,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: _form(widget.eliminar)),
                  Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _botonNuevo({'route': Usuarios()}),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: BlocBuilder<UserBloc, UserState>(
                                  builder: (context, state) {
                                    return Visibility(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (widget.eliminar) {
                                            Map data = await UsuariosService()
                                                .eliminarUsuario(
                                              widget.userEdit!.codigo,
                                              state.user!.token,
                                            );

                                            if (data['success']) {
                                              nombreController.clear();
                                              passwordController.clear();
                                              rolController.clear();
                                              emailController.clear();
                                              apellidoController.clear();
                                              util.message(
                                                  context,
                                                  'Se eliminó correctamente',
                                                  Colors.green);
                                              eventsBloc.add(ChangeStateMenu([
                                                true,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ], {
                                                'route': Usuarios()
                                              }));
                                            } else {
                                              print(data[
                                                  'error']); // Cambiado de 'success' a 'error'
                                              util.message(
                                                  context,
                                                  'No se eliminó: error',
                                                  Colors.orange);
                                            }
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shadowColor: Colors.red,
                                          primary: Colors.red,
                                        ),
                                        child: Text("Eliminar"),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                        ]),
                  ),
                ],
              ));
        },
      ),
    );
  }

  _cargarDatos(UsuarioGeneralModel user) async {
    nombreController.text = user.nombre;
    apellidoController.text = user.apellido;
    rolController.text = user.rol;
    emailController.text = user.email;
    passwordController.text = '';
  }

  Widget _listTitle(Widget titulo, Widget description, Widget? icono) {
    return ListTile(
      leading: icono,
      title: titulo,
      subtitle: description,
    );
  }

  Widget _botonNuevo(Map menu) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          eventsBloc.add(
              ChangeStateMenu([true, false, false, false, false, false], menu));
        },
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.orange,
          primary: Colors.orange,
        ),
        child: const Text('Cancelar'),
      ),
    );
  }

  Widget _form(bool eliminar) {
    return Form(
      key: _formKey,
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 3.5),
        children: [
          ListTilePersonalizado(
            etitle: 'Nombre username: ',
            esubtitle: crearTextFormField('username', 'Ingrese su username.',
                nombreController, false, false),
          ),
          ListTilePersonalizado(
            etitle: 'idRolController: ',
            esubtitle: crearTextFormField('idRolController',
                'Ingrese el nombre', rolController, false, false),
          ),
          ListTilePersonalizado(
            etitle: 'idEmpresaController',
            esubtitle: crearTextFormField(
                'Apellido', 'Apellido', emailController, false, false),
          ),
          ListTilePersonalizado(
            etitle: 'idSedeController: ',
            esubtitle: crearTextFormField(
                'Email', 'Ingrese un email.', apellidoController, false, false),
          ),
        ],
      ),
    );
  }

  Widget _filters2(
    BuildContext context,
    ValueNotifier<String> controlador,
  ) {
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      height: 50,
      child: InputDecorator(
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controlador.value,
            onChanged: (String? valor) {
              controlador.value = valor!;
              setState(() {});
            },
            items: roles.map<DropdownMenuItem<String>>((item) {
              return DropdownMenuItem<String>(
                value: item['id'],
                child: Text(item['nombre']),
              );
            }).toList(),
          ),
        ),
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
                if (!widget.eliminar && (value == null || value.isEmpty)) {
                  return subTitle;
                } else if (widget.eliminar &&
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
