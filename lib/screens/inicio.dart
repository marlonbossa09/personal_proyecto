import 'package:flutter/material.dart';
import 'package:personal_proyecto/screens/page1.dart';
import 'package:personal_proyecto/util/utils.dart';


class Inicio extends StatefulWidget {
  Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  DateTime fechaCronograma = DateTime.now();
  Utils util = Utils();
  var size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Expanded(
        flex: 8, 
        child: Container(
          height: size.height * 1, 
          child: Page1()
        ));
  }
}
