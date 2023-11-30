import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_proyecto/blocs/events/events_bloc.dart';
import 'package:personal_proyecto/screens/publicaciones.dart';
import 'package:personal_proyecto/util/utils.dart';

class Inicio extends StatefulWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  var eventsBloc;
  Utils util = Utils();

  @override
  Widget build(BuildContext context) {
    eventsBloc = BlocProvider.of<EventsBloc>(context);

    return Expanded(
      flex: 8,
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: util.boxDecorationDiv(),
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.all(12),
                        child: Image(image: AssetImage('assets/pescado.jpg')),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.9),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Titulos(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class Titulos extends StatefulWidget {
 
  const Titulos({
    super.key,
  });

  @override
  State<Titulos> createState() => _TitulosState();
}

class _TitulosState extends State<Titulos> {
  var eventsBloc;

  @override
  Widget build(BuildContext context) {
  eventsBloc = BlocProvider.of<EventsBloc>(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.blue,
                    width: 1.0,
                  ),
                ),
              ),
              child: Text(
                'BAYOU',
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
                'Con productos frescos, de alta calidad directamente de pescadores locales. No sólo adquieres un producto, apoyas a una familia y a una comunidad.',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                )),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                eventsBloc.add(
                                ChangeStateMenu(
                                  [true, true, false, false, false],
                                  {'route': Publicaciones()},
                                ),
                              );
              },
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.blue,
                primary: Colors.blue, 
              ),
              child: Text(
                'Ver Productos',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
