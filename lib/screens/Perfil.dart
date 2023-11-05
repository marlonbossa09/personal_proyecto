import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_proyecto/blocs/events/events_bloc.dart';
import 'package:personal_proyecto/models/UserModel.dart';
import 'package:personal_proyecto/screens/page1.dart';
import 'package:personal_proyecto/util/utils.dart';
import 'package:personal_proyecto/widgets/personalizados.dart';

class Perfil extends StatefulWidget {
  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  Utils util = Utils();
  TextStyle textStyle =
      const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold);
  var size;
  var eventsBloc;
  var usuariosBloc;
  var user_sesionBloc;
  List<User> users = [];
  late User hola;
  final mensajeController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final telefonoController = TextEditingController();

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
                            {'route': Page1()}));
                      },
                      icon: Icon(Icons.arrow_back)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        util.tituloBlack(
                          'Perfil',
                          18.0,
                          30,
                          Colors.black,
                          true,
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.blue,
                            primary: Colors.blue,
                          ),
                          child: Text('Editar',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                      ],
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50, 
                  backgroundImage: AssetImage('assets/falcao.jpg'),
                ),
                ListTilePersonalizado(icono: Icons.person,etitle: 'Username', esubtitle: crearTextFormField('', '', usernameController, false),),
                Text(
                  'Radamel Falcao',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ListTilePersonalizado(icono: Icons.email,etitle: 'Email', esubtitle: crearTextFormField('', '', usernameController, false),),
                ListTilePersonalizado(icono: Icons.phone,etitle: 'Telefono', esubtitle: crearTextFormField('', '', usernameController, false),),

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

  Widget crearTextFormField(String title, String subTitle,
      TextEditingController controller, bool pass) {
    return Container(
      height: 40,
      child: TextFormField(
        obscureText: pass,
        controller: controller,
        decoration: util.inputDecoration(title, true),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return subTitle;
          }
          return null;
        },
      ),
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
