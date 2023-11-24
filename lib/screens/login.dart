import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_proyecto/blocs/Login/login_bloc.dart';
import 'package:personal_proyecto/blocs/estudiantes/estudiantes_bloc.dart';
import 'package:personal_proyecto/models/EstudiantesModel.dart';
import 'package:personal_proyecto/models/loginModel.dart';
import 'package:personal_proyecto/screens/home.dart';
import 'package:personal_proyecto/services/loginService.dart';
import 'package:personal_proyecto/util/utils.dart';

class Login extends StatelessWidget {
  Login({super.key});
  Utils util = Utils();

  final _formKey = GlobalKey<FormState>();
  final correoController = TextEditingController(text: 'user@email.com');
  final passwordController = TextEditingController(text: '12345');

  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final repeatPassController = TextEditingController();

  var size;

  final ValueNotifier<String> _tipoRol = ValueNotifier<String>('G');
  var loginBloc;
  var userBloc;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    loginBloc = BlocProvider.of<LoginBloc>(context);
    userBloc = BlocProvider.of<UserBloc>(context);

    return Scaffold(
      body: SafeArea(child: Center(child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return state.vistaLogin
              ? _crearFormRegistrarse(context)
              : _crearFormLogin(context);
        },
      ))),
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
              spreadRadius: 4.0),
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
                    'SMART GUARD',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: crearTextFormField('Correo', 'Ingrese un correo.',
                      correoController, false, true),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: crearTextFormField(
                      'Contraseña',
                      'Ingrese una contraseña.',
                      passwordController,
                      true,
                      false),
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
                          child: const Text('Registrarse.'))
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
                            final jwtResponse =
                                await LoginService().iniciarSesion(
                              correoController.text,
                              passwordController.text,
                            );

                            final user = await LoginService()
                                .usuarioActual(jwtResponse.token);

                            final newUser = Estudiantes(
                              codigo: user.codigo,
                              nombre: user.nombre,
                              apellido: user.apellido,
                              rol: user.rol,
                              email: user.email,
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
                                context, error.toString(), Colors.orange);
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
              spreadRadius: 4.0),
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
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: size.width * 0.3,
            height: size.height * 0.35,
            child: Form(
              key: _formKey,
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 3),
                children: [
                  crearTextFormField('Nombres', 'Ingrese su nombre.',
                      nombreController, false, false),
                  crearTextFormField('Apellidos', 'Ingrese su apellido.',
                      apellidoController, false, false),
                  crearTextFormField('Correo', 'Ingrese su correo.',
                      emailController, false, true),
                  crearTextFormField('Contraseña', 'Ingrese una contraseña.',
                      passController, true, false),
                  crearTextFormField(
                      'Repetir contraseña',
                      'Repita la contraseña.',
                      repeatPassController,
                      true,
                      false),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Container(
              width: size.width * 0.4,
              height: size.height * 0.05,
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: ElevatedButton(
                  onPressed: () {}, child: const Text('Registrarse')),
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
                  repeatPassController.clear();
                  loginBloc.add(ChangeFormEvent(false));
                },
                child: const Text('¿Ya estas registrado? has clic aqui.')),
          ),
        ],
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
            if (title.contains("Repetir contraseña")) {
              if (passController.text != repeatPassController.text) {
                return 'Contraseñas no coinciden.';
              }
            }
          }
          return null;
        },
      ),
    );
  }
}
