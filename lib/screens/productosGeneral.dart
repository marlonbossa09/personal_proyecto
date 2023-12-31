import 'package:personal_proyecto/blocs/productos/productos_bloc.dart';
import 'package:personal_proyecto/blocs/user/user_bloc.dart';
import 'package:personal_proyecto/models/UsuarioGeneralModel.dart';
import 'package:personal_proyecto/screens/crearProducto.dart';
import 'package:personal_proyecto/screens/eliminarProductos.dart';
import 'package:personal_proyecto/services/productoService.dart';
import 'package:personal_proyecto/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_proyecto/blocs/events/events_bloc.dart';
import 'package:personal_proyecto/widgets/personalizados.dart';

class ProductosGeneral extends StatefulWidget {
  const ProductosGeneral({super.key});

  @override
  State<ProductosGeneral> createState() => _ProductosGeneralState();
}

class _ProductosGeneralState extends State<ProductosGeneral> {
  Utils util = Utils();
  List<Map> filters = [
    {"id": "userName", "nombre": "Username"},
    {"id": "idRol", "nombre": "IDRol"},
    {"id": "idEmpresa", "nombre": "IDEmpresa"},
    {"id": "idSede", "nombre": "idSede"},
  ];

  var size;
  var eventsBloc;
  var usuariosBloc;

  final ValueNotifier<String> _valueFiltro = ValueNotifier<String>('userName');
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
                                    'PRODUCTOS', 15.0, 20, Colors.blue, true),
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
                          ? BlocBuilder<UserBloc, UserState>(
                              builder: (context, user) {
                                return PaginatedDataTable(
                                    header: Row(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(right: 5),
                                          child: Icon(Icons.widgets,
                                              color: Color.fromARGB(
                                                  255, 0, 140, 255)),
                                        ),
                                        util.tituloBlack(
                                            'TABLA DE RESULTADOS',
                                            0,
                                            19,
                                            const Color.fromARGB(
                                                255, 12, 60, 100),
                                            true)
                                      ],
                                    ),
                                    columns: [
                                      DataColumn(
                                          label:
                                              Text('Nombre', style: textStyle)),
                                      DataColumn(
                                          label: Text('Descripcion',
                                              style: textStyle)),
                                      DataColumn(
                                          label: Text('Cantidad',
                                              style: textStyle)),
                                      DataColumn(
                                          label:
                                              Text('Precio', style: textStyle)),
                                      DataColumn(
                                          label: Text('Creador',
                                              style: textStyle)),
                                      DataColumn(
                                          label: Text('', style: textStyle)),
                                      DataColumn(
                                          label: Text('Acciones',
                                              style: textStyle)),
                                    ],
                                    source: _DataSource(
                                        usuariosState.productos!, context),
                                    rowsPerPage: 5,
                                    arrowHeadColor:
                                        const Color.fromARGB(255, 12, 60, 100));
                              },
                            )
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

                          if (state.user!.rol == 'V') {
                            data = await ProductoService()
                                .verProductosUsuario(state.user!.token);
                          } else {
                            data = await ProductoService()
                                .verProductos(state.user!.token);
                          }

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
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              return _botonNuevo({'route': CrearProducto(editar: false)});
            },
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

class _DataSource extends DataTableSource {
  _ProductosGeneralState ciudadanos = _ProductosGeneralState();

  BuildContext context;
  final List _data;
  var userBloc;
  var eventsBloc;
  _DataSource(this._data, this.context);

  DataRow? getRow(int index) {
    //userBloc = BlocProvider.of<CiudadanosBloc>(context);
    eventsBloc = BlocProvider.of<EventsBloc>(context);
    if (index >= _data.length) {
      return null;
    }

    ProductoConUsuarioModel dato = _data[index];
    return DataRow.byIndex(
      index: index,
      color: MaterialStateColor.resolveWith((states) {
        if (index % 2 == 0) {
          return Color.fromARGB(255, 241, 248, 253);
        }
        return Colors.white;
      }),
      cells: [
        DataCell(Text(dato.nombre)),
        DataCell(Text(dato.descripcion)),
        DataCell(Text(dato.cantidad)),
        DataCell(Text(dato.precio)),
        DataCell(Text(dato.creador.nombre + ' ' + dato.creador.apellido)),
        DataCell(
          ElevatedButton(
            onPressed: () {
              eventsBloc.add(ChangeStateMenu([
                true,
                false,
                false,
                false,
                false,
                false,
              ], {
                'route': CrearProducto(editar: true, userEdit: dato)
              }));
            },
            child: const Text('Editar'),
          ),
        ),
        DataCell(ElevatedButton(
          onPressed: () {
            eventsBloc.add(ChangeStateMenu([
              true,
              false,
              false,
              false,
              false,
              false,
            ], {
              'route': EliminarProductos(
                eliminar: true,
                userEdit: dato,
              )
            }));
          },
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.red,
            primary: Colors.red,
          ),
          child: const Text('Eliminar'),
        )),
      ],
    );
  }

  @override
  int get rowCount => _data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
