import 'dart:io';
import 'dart:math';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:personal_proyecto/blocs/events/events_bloc.dart';
import 'package:personal_proyecto/models/EstudiantesModel.dart';
import 'package:personal_proyecto/screens/page1.dart';
import 'package:personal_proyecto/util/utils.dart';
import 'package:personal_proyecto/widgets/personalizados.dart';

class AgregarProducto extends StatefulWidget {
  @override
  State<AgregarProducto> createState() => _AgregarProductoState();
}

class _AgregarProductoState extends State<AgregarProducto> {
  Utils util = Utils();
  TextStyle textStyle =
      const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold);
  var size;
  var eventsBloc;
  var usuariosBloc;
  var user_sesionBloc;
  List<Estudiantes> users = [];
  late Estudiantes hola;
  final nombreController = TextEditingController();
  final cantidadController = TextEditingController();
  final precioController = TextEditingController();
  final descripcionController = TextEditingController();

  late File _imageFile;

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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          util.tituloBlack(
                            'Agregar productos',
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
    final String nombre = nombreController.text;
    final int cantidad = int.tryParse(cantidadController.text) ?? 0;
    final double precio = double.tryParse(precioController.text) ?? 0.0;
    final String descripcion = descripcionController.text;
    
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  ListTilePersonalizado(
                      etitle: 'Nombre del producto: ',
                      esubtitle: crearTextFormField(
                          'producto',
                          'Ingrese producto',
                          nombreController,
                          false,
                          false),
                    ),
                    ListTilePersonalizado(
                      etitle: 'Cantidad: ',
                      esubtitle: crearTextFormField(
                          'Cantidad',
                          'Ingrese la cantidad',
                          cantidadController,
                          false,
                          false),
                    ),
                    ListTilePersonalizado(
                      etitle: 'Precio: ',
                      esubtitle: crearTextFormField('Precio',
                          'Ingrese el Precio', precioController, false, false),
                    ),
                const Text(
                  'Agregue una descripción',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                crearTextFormDescripcion(),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () async {
                        final ImagePicker _picker = ImagePicker();
                        final XFile? image = await _picker.pickImage(
                            source: ImageSource.gallery);
                        if (image != null) {
                          setState(() {
                            _imageFile = File(image.path);
                            print('Ruta de la imagen: ${_imageFile.path}');
                          });
                        }
                      },
                      icon: Icon(Icons.sell),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.blue,
                        primary: Colors.blue,
                      ),
                      child: Text('Publicar',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget crearTextFormField(String title, String subTitle,
      TextEditingController controller, bool pass, bool validarEmail) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        obscureText: pass,
        controller: controller,
        decoration: util.inputDecoration(title, false),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return subTitle;
          } else {
            if (validarEmail) {
              return EmailValidator.validate(controller.text)
                  ? null
                  : "Ingrese un correo valido.";
            }
          }
          return null;
        },
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

  Widget crearTextFormDescripcion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        util.tituloBlack('Escribe aquí:', 10.0, 15, Colors.black, true),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: TextFormField(
            maxLines: 5,
            controller: nombreController,
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

  Widget _listTitle(Widget titulo, Widget description, Widget? icono) {
    return ListTile(
      leading: icono,
      title: titulo,
      subtitle: description,
    );
  }
}
