import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_proyecto/blocs/events/events_bloc.dart';
import 'package:personal_proyecto/models/EstudiantesModel.dart';
import 'package:personal_proyecto/screens/page1.dart';
import 'package:personal_proyecto/util/utils.dart';
import 'package:personal_proyecto/widgets/personalizados.dart';

class Busquedas extends StatefulWidget {
  @override
  State<Busquedas> createState() => _BusquedasState();
}

class _BusquedasState extends State<Busquedas> {
  Utils util = Utils();
  TextStyle textStyle =
      const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold);
  var size;
  var eventsBloc;
  var usuariosBloc;
  var user_sesionBloc;
  List<Estudiantes> users = [];
  late Estudiantes hola;
  final _tbxController = TextEditingController();

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          util.tituloBlack(
                            'Busqueda',
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
     ListTilePersonalizado(icono: Icons.search,etitle: '', esubtitle: crearTextFormField('Realizar busqueda', 'Realizar busqueda', _tbxController, false),),
            Text('Busquedas recientes', style: TextStyle(fontWeight: FontWeight.bold),)
        ],
      )
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

  
}
