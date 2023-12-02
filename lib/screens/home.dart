import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;

import 'package:personal_proyecto/blocs/events/events_bloc.dart';
import 'package:personal_proyecto/blocs/user/user_bloc.dart';
import 'package:personal_proyecto/screens/busquedas.dart';
import 'package:personal_proyecto/screens/crearProducto.dart';
import 'package:personal_proyecto/screens/informacionPerfil.dart';
import 'package:personal_proyecto/screens/misPublicaciones.dart';
import 'package:personal_proyecto/screens/perfilUsuario.dart';
import 'package:personal_proyecto/screens/productosGeneral.dart';
import 'package:personal_proyecto/screens/publicaciones.dart';
import 'package:personal_proyecto/screens/usuarios.dart';

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
      'roles': 'A,V,C'
    },
    {
      'titulo': 'Productos',
      'icono': const Icon(Icons.search),
      'menu': {'route': Busquedas()},
      'pos': 1,
      'roles': 'A,V,C'
    },{
      'titulo': 'Productos',
      'icono': const Icon(Icons.production_quantity_limits),
      'menu': {'route': MisPublicaciones()},
      'pos': 2,
      'roles': 'V'
    },
    {
      'titulo': 'Crear Producto',
      'icono': const Icon(Icons.notifications),
      'menu': {'route': CrearProducto(editar: false,)},
      'pos': 2,
      'roles': 'A,V'
    },
    {
      'titulo': 'Usuarios',
      'icono': const Icon(Icons.unfold_less_rounded),
      'menu': {'route': Usuarios()},
      'pos': 2,
      'roles': 'V'
    },
    {
      'titulo': 'ProductosGeneral',
      'icono': const Icon(Icons.production_quantity_limits),
      'menu': {'route': ProductosGeneral()},
      'pos': 3,
      'roles': 'A,V'
    },
    {
      'titulo': 'Perfil',
      'icono': const Icon(Icons.person),
      'menu': {
        'route': inofrmacionPerfil(
        )
      },
      'pos': 4,
      'roles': 'A,V,C'
    }
  ];

  Widget _botonNuevo(Map menu) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          eventsBloc.add(ChangeStateMenu([
            false,
            true,
            false,
            false,
            false,
            false,
          ], menu));
        },
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.green,
          primary: Colors.green,
        ),
        child: const Text('Nuevo'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    eventsBloc = BlocProvider.of<EventsBloc>(context);

    size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(29, 0, 0, 0),
        elevation: 2,
        actions: [
          TextButton.icon(
              icon: const Icon(Icons.exit_to_app, color: Colors.blue),
              label: const Text('Cerrar sesión',
                  style: TextStyle(color: Color.fromARGB(171, 0, 0, 0))),
              onPressed: () {
                eventsBloc.add(InitialStateEvent());
                Navigator.pushReplacementNamed(context, '/');
              }),
        ],
        title: BlocBuilder<UserBloc, UserState>(
          builder: (context, user) {
            return Row(
              children: [
                SizedBox(width: 10),
                /*  Text(
                  'CONTAWEB',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                   ),
               ),*/
                Row(
                  children: [
                    SizedBox(width: 40),
                    Text("${user.user!.nombre}",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(width: 40),
                    Text("${user.user!.email}",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(width: 40),
                    Text("${user.user!.apellido}",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            );
          },
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
  return BlocBuilder<EventsBloc, EventsState>(
    builder: (context, state) {
      return BlocBuilder<UserBloc, UserState>(
        builder: (context, user) {
          states = state.state;
          String rol = user.user!.rol;
          List<Map<String, dynamic>> menusVal = [];
          for (Map<String, dynamic> menu in menus) {
            if (menu['roles'].toString().contains(rol)) {
              menusVal.add(menu);
            }
          }
          return Container(
            color: Colors.blueAccent,
            height: 50,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(menusVal.length, (i) {
                  if (menusVal[i]['roles'].contains(user.user!.rol)) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: _crearListitles(
                        menusVal[i]['titulo'],
                        menusVal[i]['icono'].icon, 
                        menusVal[i]['menu'],
                        menusVal[i]['pos'],
                        true,
                        40.0,
                        const Color.fromARGB(255, 5, 51, 88), 
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ),
            ),
          );
        },
      );
    },
  );
}



  Widget _crearListitles(
    String titulo,
    IconData iconData,
    Map menu,
    int j,
    bool bloc,
    double iconSize, 
    Color iconColor, 
  ) {
    return IconButton(
      icon: Icon(
        iconData,
        size: iconSize,
        color: iconColor,
      ),
      onPressed: () {
        if (bloc) {
          for (int i = 0; i < states.length; i++) {
            states[i] = false;
          }
          select[0] = false;
          select[1] = false;
          states[j] = true;
        }
        eventsBloc.add(ChangeStateMenu(states, menu));
      },
    );
  }
}
