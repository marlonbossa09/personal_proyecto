import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_proyecto/blocs/events/events_bloc.dart';
import 'package:personal_proyecto/util/utils.dart';
import 'package:personal_proyecto/widgets/personalizados.dart';

class RegistrarProductos extends StatefulWidget {
  const RegistrarProductos({super.key});

  @override
  State<RegistrarProductos> createState() => _RegistrarProductosState();
}

class _RegistrarProductosState extends State<RegistrarProductos> {

  Utils util = Utils();

  @override
   Widget build(BuildContext context) {

    return Expanded(
        child: Container(
          height: MediaQuery.of(context).size.height * 1,
          padding: const EdgeInsets.all(5),
          decoration: util.boxDecorationDiv(),
          child: Scaffold(
            body: Column(
                children: [
                  Text('data')
                ],
              ),
          )
        ));
  }
 }