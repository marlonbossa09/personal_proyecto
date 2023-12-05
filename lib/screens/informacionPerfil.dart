import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_proyecto/blocs/events/events_bloc.dart';
import 'package:personal_proyecto/blocs/user/user_bloc.dart';
import 'package:personal_proyecto/models/UsuarioGeneralModel.dart';
import 'package:personal_proyecto/screens/VerProductos.dart';
import 'package:personal_proyecto/screens/inicio.dart';
import 'package:personal_proyecto/screens/perfilUsuario.dart';
import 'package:personal_proyecto/util/utils.dart';

class InformacionPerfil extends StatefulWidget {
  @override
  State<InformacionPerfil> createState() => _InformacionPerfilState();
}

class _InformacionPerfilState extends State<InformacionPerfil> {
  Utils util = Utils();
  TextStyle textStyle =
      const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold);
  var size;
  var eventsBloc;
  var usuariosBloc;
  var user_sesionBloc;
  List<UsuarioGeneralModel> users = [];
  late UsuarioGeneralModel hola;

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
                            [false, false, false, false, false, false, true],
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
                            'Perfil Usuario',
                            18.0,
                            30,
                            Colors.black,
                            true,
                          ),
                        ],
                      ),
                    ],
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
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.only(right: 10),
                          child: Image.asset('assets/falcao.jpg',
                              fit: BoxFit.cover),
                        ),
                        Text(
                          state.user!.nombre + ' ' + state.user!.apellido,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      state.user!.email,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30),
                    Text(
                      state.user!.celular,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30),
                    Text(
                      state.user!.rol == 'V'
                          ? "Vendedor"
                          : (state.user!.rol == 'C' ? 'Comprador' : 'Admin'),
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        eventsBloc.add(ChangeStateMenu([
                          false,
                          false,
                          false,
                          false,
                          false,
                          false,true,
                        ], {
                          'route': PerfilUsuario()
                        }));
                      },
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.blue,
                        primary: Colors.blue,
                      ),
                      child: Text('Editar usuario',
                          style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
}
