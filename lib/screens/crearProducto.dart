import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_proyecto/blocs/events/events_bloc.dart';
import 'package:personal_proyecto/blocs/productos/productos_bloc.dart';
import 'package:personal_proyecto/blocs/user/user_bloc.dart';
import 'package:personal_proyecto/models/ProductosModel.dart';
import 'package:personal_proyecto/screens/publicaciones.dart';
import 'package:personal_proyecto/screens/verProductos.dart';
import 'package:personal_proyecto/services/productoService.dart';
import 'package:personal_proyecto/util/utils.dart';
import 'package:personal_proyecto/widgets/personalizados.dart';

class CrearProducto extends StatefulWidget {
  final editar;
  final ProductosModel? userEdit;
 CrearProducto({super.key, this.editar, this.userEdit});

  @override
  State<CrearProducto> createState() => _CrearProductoState();
}

class _CrearProductoState extends State<CrearProducto> {
  Utils util = Utils();

  List<Map> roles = [
    {"id": "L", "nombre": "Lider"},
  ];

  var eventsBloc;
  var productosBloc;

  final _formKey = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  final mensajeController = TextEditingController();
  final cantidadController = TextEditingController();
  final precioController = TextEditingController();
  final descripcionController = TextEditingController();

  final ValueNotifier<bool> _changePassword = ValueNotifier<bool>(false);
  TextStyle textStyle = const TextStyle(
      color: const Color.fromARGB(255, 12, 60, 100),
      fontWeight: FontWeight.bold);

  @override
  void dispose() {
    super.dispose();
    productosBloc.add(InitialUserEvent());
  }

  @override
  void initState() {
    super.initState();
    if (widget.editar) {
      _cargarDatos(widget.userEdit!);
      _changePassword.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    eventsBloc = BlocProvider.of<EventsBloc>(context);
    productosBloc = BlocProvider.of<ProductosBloc>(context);
    return Expanded(
      flex: 8,
      child: Container(
          height: MediaQuery.of(context).size.height * 1,
          padding: const EdgeInsets.all(5),
          decoration: util.boxDecorationDiv(),
          child: ListView(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                        padding: const EdgeInsets.all(5.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: util.boxDecoration(),
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    util.tituloBlack(
                                      '${widget.editar ? 'EDITAR' : 'CREAR'} PRODUCTO',
                                      15.0,
                                      20,
                                      const Color.fromARGB(255, 12, 60, 100),
                                      true,
                                    ),
                                    const Icon(
                                      Icons.person_add_alt_rounded,
                                      color: const Color.fromARGB(
                                          255, 12, 60, 100),
                                      size: 30,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )),
                  ),
                ],
              ),
              Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: _form(widget.editar)),
              Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _botonNuevo({'route': Publicaciones()}),
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: BlocBuilder<UserBloc, UserState>(
                              builder: (context, state) {
                                return Visibility(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        Map<String, dynamic> datosUser = {
                                          "nombre": nombreController.text,
                                          "descripcion": descripcionController.text,
                                          "cantidad": cantidadController.text,
                                          "precio": precioController.text,
                                        };

                                        try {
                                          final Map<String, dynamic> data =
                                              widget.editar
                                                  ? await ProductoService()
                                                      .editarEmpresa(
                                                          datosUser,
                                                          widget.userEdit!.id
                                                              .toString(),
                                                          state.user!.token)
                                                  : await ProductoService()
                                                      .crearProducto(datosUser,
                                                          state.user!.token);

                                          if (data['success']) {
                                            nombreController.clear();
                                            descripcionController.clear();
                                            cantidadController.clear();
                                            precioController.clear();
                                            util.message(
                                              context,
                                              widget.editar
                                                  ? 'Se actualizó correctamente'
                                                  : 'Se creó correctamente',
                                              Colors.green,
                                            );
                                            eventsBloc.add(ChangeStateMenu([
                                              true,
                                              false,
                                              false,
                                              false,
                                              false,
                                              false
                                            ], {
                                              'route': Publicaciones()
                                            }));
                                          } else {
                                            util.message(
                                              context,
                                              widget.editar
                                                  ? 'No se pudo editar la empresa'
                                                  : 'No se pudo crear la empresa',
                                              Colors.red,
                                            );
                                          }
                                        } catch (e) {
                                          print("Error: $e");
                                          util.message(context,
                                              'Ocurrió un error', Colors.red);
                                        }
                                      }
                                    },
                                    child: Text(widget.editar
                                        ? "Actualizar"
                                        : "Guardar"),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    ]),
              ),
            ],
          )),
    );
  }

  _cargarDatos(ProductosModel producto) async {
    nombreController.text = producto.nombre;
    descripcionController.text = producto.descripcion;
    cantidadController.text = producto.cantidad.toString();
    precioController.text = producto.precio.toString();
  }

  Widget _listTitle(Widget titulo, Widget description, Widget? icono) {
    return ListTile(
      leading: icono,
      title: titulo,
      subtitle: description,
    );
  }

  Widget _botonNuevo(Map menu) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          eventsBloc.add(
              ChangeStateMenu([false, true, false, false, false, false], menu));
        },
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.red,
          primary: Colors.red,
        ),
        child: const Text('Cancelar'),
      ),
    );
  }

  Widget _form(bool editar) {
    return Form(
      key: _formKey,
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 3.5),
        children: [
          ListTilePersonalizado(
            etitle: 'Nombre del producto: ',
            esubtitle: crearTextFormField(
                'producto', 'Ingrese producto', nombreController, false, false),
          ),
          ListTilePersonalizado(
            etitle: 'Cantidad: ',
            esubtitle: crearTextFormField('Cantidad', 'Ingrese la cantidad',
                cantidadController, false, false),
          ),
          ListTilePersonalizado(
            etitle: 'Precio: ',
            esubtitle: crearTextFormField(
                'Precio', 'Ingrese el Precio', precioController, false, false),
          ),
          const Text(
            'Agregue una descripción',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          crearTextFormDescripcion(),
        ],
      ),
    );
  }

  Widget crearTextFormDescripcion() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          util.tituloBlack('Escribe aquí:', 10.0, 15, Colors.black, true),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextFormField(
              maxLines: 5,
              controller: descripcionController,
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
      ),
    );
  }

  Widget _filters2(
    BuildContext context,
    ValueNotifier<String> controlador,
  ) {
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      height: 50,
      child: InputDecorator(
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controlador.value,
            onChanged: (String? valor) {
              controlador.value = valor!;
              setState(() {});
            },
            items: roles.map<DropdownMenuItem<String>>((item) {
              return DropdownMenuItem<String>(
                value: item['id'],
                child: Text(item['nombre']),
              );
            }).toList(),
          ),
        ),
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

  Widget crearTextFormFieldPassword(String title, String subTitle,
      TextEditingController controller, bool pass, bool readonly) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ValueListenableBuilder<bool>(
          valueListenable: _changePassword,
          builder: (BuildContext context, bool value, Widget? child) {
            return TextFormField(
              readOnly: !value,
              obscureText: pass,
              controller: controller,
              decoration: util.inputDecoration(title, false),
              validator: (value) {
                if (!widget.editar && (value == null || value.isEmpty)) {
                  return subTitle;
                } else if (widget.editar &&
                    _changePassword.value &&
                    (value == null || value.isEmpty)) {
                  return subTitle;
                }
                return null;
              },
            );
          }),
    );
  }
}
