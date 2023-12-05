import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_proyecto/blocs/Login/login_bloc.dart';
import 'package:personal_proyecto/blocs/events/events_bloc.dart';
import 'package:personal_proyecto/blocs/productos/productos_bloc.dart';
import 'package:personal_proyecto/blocs/user/user_bloc.dart';
import 'package:personal_proyecto/blocs/usuarios/usuarios_bloc.dart';
import 'package:personal_proyecto/screens/googleLogin.dart';
import 'package:personal_proyecto/screens/home.dart';
import 'package:personal_proyecto/screens/login.dart';


void main() => runApp(const MyApp());


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: ( _ ) => UserBloc()),
        BlocProvider(create: ( _ ) => LoginBloc()),
        BlocProvider(create: ( _ ) => EventsBloc()),
        BlocProvider(create: ( _ ) => ProductosBloc()),
        BlocProvider(create: ( _ ) => UsuariosBloc())
      ],
       child:MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PROYECTO',
        initialRoute: '/',
        routes: {
          '/' : (context) => Login(),
          '/home' : (context) => Home()
        },
      ),
    );
  }
}



