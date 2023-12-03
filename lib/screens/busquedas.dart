import 'package:personal_proyecto/blocs/productos/productos_bloc.dart';
import 'package:personal_proyecto/blocs/user/user_bloc.dart';
import 'package:personal_proyecto/models/UsuarioGeneralModel.dart';
import 'package:personal_proyecto/screens/crearProducto.dart';
import 'package:personal_proyecto/screens/eliminarProductos.dart';
import 'package:personal_proyecto/screens/verProductos.dart';
import 'package:personal_proyecto/services/productoService.dart';
import 'package:personal_proyecto/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_proyecto/blocs/events/events_bloc.dart';
import 'package:personal_proyecto/widgets/personalizados.dart';

class Busquedas extends StatefulWidget {
  const Busquedas({super.key});

  @override
  State<Busquedas> createState() => _BusquedasState();
}

class _BusquedasState extends State<Busquedas> {
  Utils util = Utils();
  List<Map> filters = [
    {"id": "nombre", "nombre": "Nombre"},
  ];

  var size;
  var eventsBloc;
  var usuariosBloc;

  final ValueNotifier<String> _valueFiltro = ValueNotifier<String>('nombre');
  final _tbxController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    usuariosBloc.add(InitialProductossEvent());
  }

  @override
  Widget build(BuildContext context) {
    eventsBloc = BlocProvider.of<EventsBloc>(context);
    usuariosBloc = BlocProvider.of<ProductosBloc>(context);
    TextStyle textStyle =
        const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold);

    return Expanded(
        flex: 8,
        child: Container(
          height: MediaQuery.of(context).size.height * 1,
          padding: const EdgeInsets.all(5),
          decoration: util.boxDecorationDiv(),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Container(
                        decoration: util.boxDecoration(),
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                util.tituloBlack(
                                    'BUSQUEDA DE PRODUCTOS', 15.0, 20, Colors.blue, true),
                                _form(context)
                              ],
                            )
                          ],
                        )),
                  ],
                ),
              ),
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: util.boxDecoration(),
                child: BlocBuilder<ProductosBloc, ProductosState>(
                  builder: (context, usuariosState) {
                    return usuariosState.productos != null &&
                            usuariosState.productos!.isNotEmpty
                        ? _buildProductsList(usuariosState.productos!)
                        : formNoData();
                  },
                ),
              ),
            ),
            ],
          ),
        ));
  }

  Widget _form(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            height: MediaQuery.of(context).size.height * 0.16,
            child: GridView(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: 3, crossAxisSpacing: 3),
              children: [
                ListTilePersonalizado(
                  etitle: 'Buscar por: ',
                  esubtitle: _filters(context, filters, _valueFiltro),
                ),
                ListTilePersonalizado(
                  etitle: '',
                  esubtitle: crearTextFormField('', '', _tbxController, false),
                ),
                ListTilePersonalizado(
                  etitle: '',
                  esubtitle: _botonBuscar(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductsList(List<ProductoConUsuarioModel> productos) {
    return Column(
      children: productos
          .map((producto) => _contenedorParticipantes(producto))
          .toList(),
    );
  }
  Widget _contenedorParticipantes(ProductoConUsuarioModel productos) {
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
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      margin: EdgeInsets.only(right: 10),
                      child: Image.asset('assets/falcao.jpg', fit: BoxFit.cover),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Publicado por:',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${productos.creador.nombre} ${productos.creador.apellido}',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  '${productos.nombre}',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Precio: ${productos.precio}',
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    eventsBloc.add(
                      ChangeStateMenu(
                        [
                          true,
                          false,
                          false,
                          false,
                          false,
                          false,
                        ],
                        {
                          'route': VerProductos(
                            productos: productos,
                          ),
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.blue,
                    primary: Colors.blue,
                  ),
                  child: Text('Ver', style: TextStyle(color: Colors.white)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _botonBuscar() {
  return BlocBuilder<ProductosBloc, ProductosState>(
    builder: (context, stateGestion) {
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: stateGestion.chargin
                      ? null
                      : () async {
                          usuariosBloc
                              .add(ChangeDataProductosEvent([], true));

                          Map<String, dynamic> datos = {};

                          if (_tbxController.text.isNotEmpty) {
                            datos.addAll(
                                {_valueFiltro.value: _tbxController.text});
                          }

                          List<ProductoConUsuarioModel> data;

                            data = await ProductoService()
                                .busquedaProductos(_tbxController.text, state.user!.token);
                          

                          if (data.isNotEmpty) {
                            usuariosBloc
                                .add(ChangeDataProductosEvent(data, false));
                          } else {
                            usuariosBloc
                                .add(ChangeDataProductosEvent([], false));
                          }
                        },
                  child: const Text('Buscar'),
                  style: ElevatedButton.styleFrom(
                    shadowColor: Color.fromARGB(118, 33, 149, 243),
                    primary: Color.fromARGB(118, 33, 149, 243),
                  ),
                );
              },
            ),
          ),
          stateGestion.chargin ? util.loading() : const Text('')
        ],
      );
    },
  );
}


  Widget _filters(
      BuildContext context, List data, ValueNotifier<String> controlador) {
    return Container(
      height: 39,
      child: InputDecorator(
        decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
        ),
        child: DropdownButtonHideUnderline(
            child: ValueListenableBuilder<String>(
          valueListenable: controlador,
          builder: (BuildContext context, String value, Widget? child) {
            return DropdownButton<String>(
              value: value,
              onChanged: (String? newValue) {
                controlador.value = newValue!;
              },
              items: List.generate(data.length, (i) {
                return DropdownMenuItem(
                  value: data[i]['id'],
                  child: Text(data[i]['nombre']),
                );
              }),
            );
          },
        )),
      ),
    );
  }

  Widget _botonNuevo(Map menu) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          eventsBloc.add(ChangeStateMenu([
            true,
            false,
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

  Widget _listTitle(Widget titulo, Widget description, Widget? icono) {
    return ListTile(
      leading: icono,
      title: titulo,
      subtitle: description,
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

  Widget _checkkox(ValueNotifier<bool> val) {
    return ValueListenableBuilder<bool>(
        valueListenable: val,
        builder: (BuildContext context, bool check, Widget? child) {
          return Checkbox(
              value: check,
              onChanged: (value) {
                val.value = value!;
              });
        });
  }

  Widget _listTitle2(
      Widget titulo, bool check, Widget description, Widget icono) {
    return ListTile(
      trailing: check ? description : null,
      title: titulo,
      subtitle: check ? null : description,
    );
  }

  Widget crearTextFormField(String title, String subTitle,
      TextEditingController controller, bool pass) {
    return Container(
      height: 40,
      child: TextFormField(
        obscureText: pass,
        controller: controller,
        decoration: util.inputDecoration(title, true),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return subTitle;
          }
          return null;
        },
      ),
    );
  }
}