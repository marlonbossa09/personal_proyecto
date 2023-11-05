import 'package:flutter/material.dart';

class ListTilePersonalizado extends StatelessWidget {
 
 final String etitle;
 final Widget esubtitle;
 final IconData? icono;

  const ListTilePersonalizado({super.key, required this.etitle, required this.esubtitle, this.icono});

  @override
  Widget build(BuildContext context) {
    return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 1),
                  title: Text(etitle),
                  subtitle: Row(
        children: [
          Icon(icono), // Agrega el icono de búsqueda aquí
          SizedBox(width: 10), // Añade un espacio entre el icono y el campo de texto
          Expanded(child: esubtitle), // Utiliza un campo de texto expandido
        ],
      ),
                );
   }
}

class Texto extends StatelessWidget {
  final String etitle;
  final TextEditingController controlador;

  Texto({Key? key, required this.etitle, required this.controlador})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

     return ListTile(
                  title: Text(etitle,
                    style: TextStyle(
                        color: Color.fromARGB(171, 0, 0, 0),
                        fontWeight: FontWeight.bold)),
                );

  }
}




