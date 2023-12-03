import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_proyecto/blocs/Login/login_bloc.dart';
import 'package:personal_proyecto/blocs/user/user_bloc.dart';
import 'package:personal_proyecto/models/UsuarioGeneralModel.dart';
import 'package:personal_proyecto/screens/home.dart';
import 'package:personal_proyecto/services/loginService.dart';
import 'package:personal_proyecto/services/usuariosService.dart';
import 'package:personal_proyecto/util/utils.dart';
import 'package:personal_proyecto/widgets/personalizados.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final correoController = TextEditingController();
  final passwordController = TextEditingController();
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final emailController = TextEditingController();
  final rolController = TextEditingController();
  final celularController = TextEditingController();
  final passController = TextEditingController();
  final ValueNotifier<bool> _changePassword = ValueNotifier<bool>(true);

  late Size size;
  late LoginBloc loginBloc;
  late UserBloc userBloc;
  final Utils util = Utils();
  List<Map> filters = [
    {"id": "V", "nombre": "Vendedor"},
    {"id": "C", "nombre": "Comprador"},
  ];

  final ValueNotifier<String> _valueFiltro = ValueNotifier<String>('V');


  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    loginBloc = BlocProvider.of<LoginBloc>(context);
    userBloc = BlocProvider.of<UserBloc>(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              return state.vistaLogin
                  ? _crearFormRegistrarse(context)
                  : _crearFormLogin(context);
            },
          ),
        ),
      ),
    );
  }

  Widget _crearFormLogin(BuildContext context) {
    return Container(
      width: size.width * 0.3,
      height: size.height * 0.7,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color.fromARGB(29, 0, 0, 0),
            blurRadius: 8.0,
            spreadRadius: 4.0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 40.0),
                  child: Text(
                    'BAYOU',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: crearTextFormField(
                    'Correo',
                    'Ingrese un correo.',
                    correoController,
                    false,
                    true,
                    false
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: crearTextFormField(
                    'Contraseña',
                    'Ingrese una contraseña.',
                    passwordController,
                    true,
                    false,
                    false
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {
                          correoController.clear();
                          passwordController.clear();
                          loginBloc.add(ChangeFormEvent(true));
                        },
                        child: const Text('Registrarse.'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Container(
                    width: size.width * 0.4,
                    height: size.height * 0.05,
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            final jwtResponse = await LoginService()
                                .iniciarSesion(
                              correoController.text,
                              passwordController.text,
                            );

                            final user = await LoginService()
                                .usuarioActual(jwtResponse.token);

                            final newUser = UsuarioGeneralModel(
                              codigo: user.codigo,
                              nombre: user.nombre,
                              apellido: user.apellido,
                              rol: user.rol,
                              email: user.email,
                              celular: user.celular,
                              clave: user.clave,
                              token: user.token,
                            );

                            userBloc.add(ActivateUserEvent(newUser));
                            print('Respuesta del usuario actual: ${user}');

                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => Home()),
                              (Route<dynamic> route) => false,
                            );
                          } catch (error) {
                            print(error);
                            util.message(
                              context,
                              error.toString(),
                              Colors.orange,
                            );
                          }
                        }
                      },
                      child: const Text('Iniciar Sesión'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearFormRegistrarse(BuildContext context) {
    return Container(
      width: size.width * 0.3,
      height: size.height * 0.7,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color.fromARGB(29, 0, 0, 0),
            blurRadius: 8.0,
            spreadRadius: 4.0,
          ),
        ],
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: Text(
              'Registrarse',
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: size.width * 0.3,
            height: size.height * 0.35,
            child: _form(context),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Container(
              width: size.width * 0.4,
              height: size.height * 0.05,
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Map<String, dynamic> datosUser = {
                          "nombre": nombreController.text,
                          "apellido": apellidoController.text,
                          "rol": _valueFiltro.value,
                          "email": emailController.text,
                          "celular": celularController.text,
                          "clave": passwordController.text
                        };
                        Map data = await UsuariosService()
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
                            Colors.green,
                          );
                        } else {
                          util.message(
                            context,
                            'Error al crear el usuario',
                            Colors.orange,
                          );
                        }
                      }
                    },
                    child: const Text('Registrarse'),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: TextButton(
              onPressed: () {
                nombreController.clear();
                apellidoController.clear();
                emailController.clear();
                passController.clear();
                loginBloc.add(ChangeFormEvent(false));
              },
              child: const Text('¿Ya estas registrado? has clic aqui.'),
            ),
          ),
        ],
      ),
    );
  }

 Widget _form(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            crearTextFormField(
              'Username',
              'Ingrese su username.',
              nombreController,
              false,
              false,
              false
            ),
            crearTextFormField(
              'Apellido',
              'Apellido',
              apellidoController,
              false,
              false,
              false
            ),
            ListTilePersonalizado(
                  etitle: 'Rol: ',
                  esubtitle: _filters(context, filters, _valueFiltro),
                ),
            crearTextFormField(
              'Email',
              'Ingrese su Email.',
              emailController,
              false,
              true,
              false
            ),
            crearTextFormField(
              'Ingrese su celular',
              'Ingrese su celular.',
              celularController,
              false,
              false,
              true
            ),
            ListTilePersonalizado(
              etitle: 'Contraseña:',
              esubtitle: _crearTextFormFieldPassword(
                  'Contraseña',
                  'Ingrese una contraseña.',
                  passwordController,
                  true,
                  _changePassword.value),
            ),
          ],
        ),
      ),
    ),
  );
}


  Widget _filters(
      BuildContext context, List data, ValueNotifier<String> controlador) {
    return Container(
      height: 39,
      child: InputDecorator(
        decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
        ),
        child: DropdownButtonHideUnderline(
            child: ValueListenableBuilder<String>(
          valueListenable: controlador,
          builder: (BuildContext context, String value, Widget? child) {
            return DropdownButton<String>(
              value: value,
              onChanged: (String? newValue) {
                controlador.value = newValue!;
              },
              items: List.generate(data.length, (i) {
                return DropdownMenuItem(
                  value: data[i]['id'],
                  child: Text(data[i]['nombre']),
                );
              }),
            );
          },
        )),
      ),
    );
  }

 Widget crearTextFormField(String title, String subTitle, TextEditingController controller, bool pass, bool validarEmail, bool soloNumeros) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: TextFormField(
      obscureText: pass,
      controller: controller,
      keyboardType: soloNumeros ? TextInputType.number : TextInputType.text, // Tipo de teclado numérico
      inputFormatters: soloNumeros ? [FilteringTextInputFormatter.digitsOnly] : null, // Solo permite dígitos
      decoration: util.inputDecoration(title, false),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return subTitle;
        } else if (soloNumeros) {
          // Validar si es un número positivo
          if (double.tryParse(value) == null || double.parse(value) < 0) {
            return 'Ingrese un número positivo.';
          }
        } else {
          // Otra lógica de validación si es necesario
        }
        return null;
      },
    ),
  );
}


  Widget _crearTextFormFieldPassword(String title, String subTitle,
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
              if ((value == null || value.isEmpty)) {
                return subTitle;
              } else if (_changePassword.value &&
                  (value == null || value.isEmpty)) {
                return subTitle;
              }
              return null;
            },
          );
        },
      ),
    );
  }
}
