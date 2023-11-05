import 'package:flutter/material.dart';
import 'package:personal_proyecto/screens/grid.dart';
import 'package:personal_proyecto/util/utils.dart';
bool fullScreen = true;
final int desktopBreakPoint = 1024;
  final int mobileBreakPoint = 720;


class Productos extends StatefulWidget {
  const Productos({super.key});

  @override
  State<Productos> createState() => _ProductosState();
}

class _ProductosState extends State<Productos> {
  
  Utils util = Utils();
  
  @override
  Widget build(BuildContext context) {

    fullScreen = (MediaQuery.of(context).size.width >= desktopBreakPoint) ? true : false;

    return Expanded(
        flex: 8,
        child: Container(
          height: MediaQuery.of(context).size.height * 1,
          padding: const EdgeInsets.all(2),
          decoration: util.boxDecorationDiv(),
          child: GridCustom()
        ));
  }
}