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

class CrearUsuario extends StatefulWidget {
  final editar;
  final UsuarioGeneralModel? userEdit;
  const CrearUsuario({super.key, this.editar, this.userEdit});

  @override
  State<CrearUsuario> createState() => _CrearUsuarioState();
}

class _CrearUsuarioState extends State<CrearUsuario> {
  Utils util = Utils();

  var eventsBloc;
  var usuariosBloc;

  final _formKey = GlobalKey<FormState>();
   final nombreController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();
  final rolController = TextEditingController();
  final emailController = TextEditingController();
  final celularController = TextEditingController();
  final apellidoController = TextEditingController();
Map<String, dynamic> datos = {};




  final ValueNotifier<bool> _changePassword = ValueNotifier<bool>(true);
  TextStyle textStyle = const TextStyle(
      color: const Color.fromARGB(255, 12, 60, 100),
      fontWeight: FontWeight.bold);

  @override
  void dispose() {
    super.dispose();
    usuariosBloc.add(InitialStateEvent());
  }

 @override
  void initState(){
    super.initState();

    if (widget.editar) {
      _cargarDatos(widget.userEdit!);
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
                                        util.tituloBlack(
                                            '${widget.editar ? 'EDITAR' : 'CREAR'} USUARIO',
                                            15.0,
                                            20,
                                            const Color.fromARGB(
                                                255, 12, 60, 100),
                                            true),
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
                      child: _form(widget.editar)),
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
                                            if (_formKey.currentState!
                                                .validate()) {

                                              Map<String, dynamic> datosUser = {
                                                "nombre":
                                                    nombreController.text,
                                                "apellido":
                                                    apellidoController.text,
                                                "rol": rolController.text,
                                                "email": emailController.text,
                                                "celular": celularController.text,
                                                "clave": passwordController.text
                                              };
                                              Map<String, dynamic> datosUser2 = {
                                                "nombre":
                                                    nombreController.text,
                                                "apellido":
                                                    apellidoController.text,
                                                "rol": rolController.text,
                                                "email": emailController.text,
                                                "celular": celularController.text,
                                              };

                                              if (widget.editar) {
                                                Map data =
                                                    await UsuariosService()
                                                        .editarUsuario(
                                                            datosUser2,
                                                            widget.userEdit!.codigo,
                                                            state.user!.token);

                                                if (data['success']){
                                                  nombreController.clear();
                                                  passwordController.clear();
                                                  apellidoController.clear();
                                                  emailController.clear();
                                                  celularController.clear();
                                                  util.message(
                                                      context,
                                                      'Se editó correctamente',
                                                      Colors.green);
                                                  eventsBloc.add(
                                                      ChangeStateMenu([
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
                                                  util.message(
                                                      context,
                                                      'Error al editar',
                                                      Colors.green);
                                                }
                                              } else if (!widget.editar) {
                                                Map data =
                                                    await UsuariosService()
                                                        .createUser(datosUser);
                                                if (data['success']) {
                                                  nombreController.clear();
                                                  passwordController.clear();
                                                  apellidoController.clear();
                                                  emailController.clear();
                                                  celularController.clear();
                                                  util.message(
                                                      context,
                                                      'Se creó correctamente',
                                                      Colors.green);
                                                } else {
                                                  util.message(
                                                      context,
                                                      'Error al crear el usuario',
                                                      Colors.orange);
                                                }
                                              }
                                            }
                                            
                                          },
                                          
                                          child: Text(widget.editar
                                              ? "Actualizar"
                                              : "Guardar")),
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
          shadowColor: Colors.red,
          primary: Colors.red,
        ),
        child: const Text('Cancelar'),
      ),
    );
  }

  Widget _form(bool editar) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, childAspectRatio: 3.5),
          children: [
            ListTilePersonalizado(
              etitle: 'Ingrese nombre',
              esubtitle: crearTextFormField('Username', 'Ingrese su username.',
                  nombreController, false, false),
            ),ListTilePersonalizado(
              etitle: 'Apellido:',
              esubtitle: crearTextFormField(
                  'Apellido', 'Apellido', apellidoController, false, false),
            ),
            ListTilePersonalizado(
              etitle: 'Rol',
              esubtitle: crearTextFormField('Username', 'Ingrese su username.',  rolController, false, false),
            //  esubtitle: _filters2(context, _selectedItemFilter),
            ),
            ListTilePersonalizado(
              etitle: 'Email',
              esubtitle: crearTextFormField('Email', 'Ingrese su Email.',  emailController, false, false),
            //  esubtitle: _filters2(context, _selectedItemFilter),
            ),
            ListTilePersonalizado(
              etitle: 'Celular',
              esubtitle: crearTextFormField('Username', 'Ingrese su celular.',  celularController, false, false),
            //  esubtitle: _filters2(context, _selectedItemFilter),
            ),
          if(!editar)
            ListTilePersonalizado(
              etitle: 'Contraseña:',
              esubtitle: crearTextFormFieldPassword(
                  'Contraseña',
                  'Ingrese una contraseña.',
                  passwordController,
                  true,
                  _changePassword.value),
            ),
          ],
        ),
      ),
    );
  }
  Widget _filters(
    BuildContext context, List<UsuarioGeneralModel> data, ValueNotifier<UsuarioGeneralModel?> controlador) {
  return Container(
    height: 39,
    child: InputDecorator(
      decoration: const InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0))),
        contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
      ),
      child: DropdownButtonHideUnderline(
        child: ValueListenableBuilder<UsuarioGeneralModel?>(
          valueListenable: controlador,
          builder: (BuildContext context, UsuarioGeneralModel? value, Widget? child) {
            return DropdownButton<UsuarioGeneralModel>(
              value: value,
              onChanged: (UsuarioGeneralModel? newValue) {
                controlador.value = newValue;
              },
              items: data.map((category) {
                return DropdownMenuItem<UsuarioGeneralModel>(
                  value: category,
                  child: Text(category.nombre),
                );
              }).toList(),
            );
          },
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
