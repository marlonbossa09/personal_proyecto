import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_proyecto/blocs/events/events_bloc.dart';
import 'package:personal_proyecto/blocs/user/user_bloc.dart';
import 'package:personal_proyecto/models/EstudiantesModel.dart';
import 'package:personal_proyecto/screens/inicio.dart';
import 'package:personal_proyecto/screens/usuarios.dart';
import 'package:personal_proyecto/services/usuariosService.dart';
import 'package:personal_proyecto/util/utils.dart';
import 'package:personal_proyecto/widgets/personalizados.dart';

class PerfilUsuario extends StatefulWidget {
  PerfilUsuario({super.key});

  @override
  State<PerfilUsuario> createState() => _PerfilUsuarioState();
}

class _PerfilUsuarioState extends State<PerfilUsuario> {
  Utils util = Utils();
  var eventsBloc;
  List<bool> states = [true, false, false, false, false, false];
  var empresaBloc;
  Map<String, dynamic> datos = {};

  List<Map> roles = [
    {"id": "1", "nombre": "Administrador"},
    {"id": "2", "nombre": "Empresa"},
    {"id": "3", "nombre": "Sede"}
  ];

  final _formKey = GlobalKey<FormState>();

  final ValueNotifier<String> _selectedItemFilter = ValueNotifier<String>('1');

  final nombreController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();
  final rolController = TextEditingController();
  final emailController = TextEditingController();
  final apellidoController = TextEditingController();

  final ValueNotifier<bool> _valueChkActualizar = ValueNotifier<bool>(false);

  List<Estudiantes> categorias = [];

  @override
  Widget build(BuildContext context) {
    eventsBloc = BlocProvider.of<EventsBloc>(context);
    List<bool> states = [true, false, false, false, false];
    return Expanded(
        flex: 8,
        child: Container(
          height: MediaQuery.of(context).size.height * 1,
          padding: const EdgeInsets.all(5),
          decoration: util.boxDecorationDiv(),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                    decoration: util.boxDecoration(),
                    child: util.tituloBlack(
                        'Perfil De Usuario', 15.0, 20, Colors.blue, true)),
              ),
              util.tituloBlack('Datos', 10.0, 19, Colors.blue, true),
              Container(
                  height: MediaQuery.of(context).size.height * 0.43,
                  child: _form()),
              Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _botonCancelar({'route': Inicio()}),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: BlocBuilder<UserBloc, UserState>(
                              builder: (context, state) {
                                return ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      Map<String, dynamic> datosUser2 = {
                                        "nombre": nombreController.text,
                                        "apellido": apellidoController.text,
                                        "rol": rolController.text,
                                        "email": emailController.text,
                                      };

                                      Map data = await UsuariosService()
                                          .editarUsuario(
                                              datosUser2,
                                              state.user!.codigo,
                                              state.user!.token);

                                      if (data['success']) {
                                        nombreController.clear();
                                        passwordController.clear();
                                        apellidoController.clear();
                                        emailController.clear();
                                        util.message(
                                            context,
                                            'Se editó correctamente',
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
                                        util.message(context, 'Error al editar',
                                            Colors.green);
                                      }
                                    }
                                  },
                                  child: const Text('Guardar'),
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    ]),
              ),
            ],
          ),
        ));
  }

  Widget _botonCancelar(Map menu) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          onPressed: () {
            eventsBloc.add(ChangeStateMenu(
                [true, false, false, false, false, false], menu));
          },
          child: const Text('Cancelar')),
    );
  }

  Widget _form() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        nombreController.text = state.user!.nombre;
        apellidoController.text = state.user!.apellido;
        rolController.text = state.user!.rol;
        emailController.text = state.user!.email;
        
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
                  esubtitle: crearTextFormField('Username',
                      'Ingrese su username.', nombreController, false, false),
                ),
                ListTilePersonalizado(
                  etitle: 'Apellido:',
                  esubtitle: crearTextFormField(
                      'Apellido', 'Apellido', apellidoController, false, false),
                ),
                ListTilePersonalizado(
                  etitle: 'Rol',
                  esubtitle: crearTextFormField('Username',
                      'Ingrese su username.', rolController, false, false),
                ),
                ListTilePersonalizado(
                  etitle: 'Email',
                  esubtitle: crearTextFormField('Email', 'Ingrese su Email.',
                      emailController, false, false),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Row(children: [
                    util.tituloBlack(
                        'Actualizar Contraseña', 8.0, 15, Colors.blue, false),
                    _checkkox(_valueChkActualizar),
                  ]),
                ),
                ValueListenableBuilder<bool>(
                    valueListenable: _valueChkActualizar,
                    builder: (BuildContext context, bool check, Widget? child) {
                      return check
                          ? crearTextFormField(
                              'Contraseña',
                              'Ingrese una contraseña.',
                              passwordController,
                              true,
                              false)
                          : const Text('');
                    }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _checkkox(ValueNotifier<bool> val) {
    return ValueListenableBuilder<bool>(
        valueListenable: val,
        builder: (BuildContext context, bool check, Widget? child) {
          return Checkbox(
              value: check,
              onChanged: (value) {
                passwordController.clear();
                val.value = value!;
              });
        });
  }

  Widget crearTextFormField(String title, String subTitle,
      TextEditingController controller, bool pass, bool validarEmail) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        obscureText: pass,
        controller: controller,
        decoration: util.inputDecoration(title, true),
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
}
