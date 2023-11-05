import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;

import 'package:personal_proyecto/blocs/events/events_bloc.dart';
import 'package:personal_proyecto/blocs/user/user_bloc.dart';
import 'package:personal_proyecto/screens/Notificaciones.dart';
import 'package:personal_proyecto/screens/Perfil.dart';
import 'package:personal_proyecto/screens/agregarComentarios.dart';
import 'package:personal_proyecto/screens/agregarProducto.dart';
import 'package:personal_proyecto/screens/busquedas.dart';
import 'package:personal_proyecto/screens/comentarios.dart';
import 'package:personal_proyecto/screens/grid.dart';
import 'package:personal_proyecto/screens/lideres.dart';
import 'package:personal_proyecto/screens/page1.dart';
import 'package:personal_proyecto/screens/page2.dart';
import 'package:personal_proyecto/screens/publicaciones.dart';
import 'package:personal_proyecto/screens/verProductos.dart';



class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var size;

  var eventsBloc;

  List<bool> states = [];

final _controladorPrueba = TextEditingController();
  List<bool> select = [false, false];

  List<Map<String, dynamic>> menus = [
    {
      'titulo': 'Inicio',
      'icono': const Icon(Icons.home),
      'menu': {'route': Publicaciones()},
      'pos': 0,
      'roles': 'A,V,L'
    },
    {
      'titulo': 'Productos',
      'icono': const Icon(Icons.search),
      'menu': {'route': Busquedas()},
      'pos': 1,
      'roles': 'G,A,V,L'
    },
    {
      'titulo': 'Crear Producto',
      'icono': const Icon(Icons.notifications),
      'menu': {'route': Comentarios()},
      'pos': 2,
      'roles': 'A,V,L'
    },
    {
      'titulo': 'Perfil',
      'icono': const Icon(Icons.person),
      'menu': {'route': AgregarProducto()},
      'pos': 2,
      'roles': 'A,V,L'
    }
  ];

  @override
  Widget build(BuildContext context) {
    eventsBloc = BlocProvider.of<EventsBloc>(context);

    size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        automaticallyImplyLeading: false,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('BAYOU',
                style: TextStyle(
                    color: Color.fromARGB(171, 0, 0, 0),
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: Column(
      children: [
        BlocBuilder<EventsBloc, EventsState>(
          builder: (context, state) {
            var route;
            state.menu.forEach((key, value) {
              if (key.toString().contains('route')) {
                route = value;
              }
            });
            return route;
          },
        ),
       Expanded(
  flex: 1,
  child: Container(
    color: Colors.blueAccent,
    height: 50, 
    child: _barraMenu(context),
  ),
),

      ],
    ),
    );
  }

Widget _barraMenu(BuildContext context) {
  List<bool> states = List.filled(menus.length, false);
  return Container(
    color: Colors.blueAccent,
    height: 50, 
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(menus.length, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0), 
            child: InkWell(
              onTap: () {
                _onMenuTapped(menus[index]['menu']);
              },
              child: Icon(
                menus[index]['icono'].icon,
                size: 35,
                color: states[index]
                    ? const Color.fromRGBO(4, 142, 255, 1)
                    : const Color.fromARGB(255, 5, 51, 88),
              ),
            ),
          );
        }),
      ),
    ),
  );
}







void _onMenuTapped(Map menu) {
  for (int i = 0; i < states.length; i++) {
    states[i] = false;
  }

  eventsBloc.add(ChangeStateMenu(states, menu));
}

}
