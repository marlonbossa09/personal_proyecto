import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:ui_web';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_proyecto/blocs/events/events_bloc.dart';
import 'package:personal_proyecto/util/utils.dart';

class Dashboard extends StatefulWidget {
  String numero;
  Dashboard({Key? key, required this.numero});

  @override
  State<Dashboard> createState() => _DashboardState();
}


class _DashboardState extends State<Dashboard> {
  late Size size;
  late var eventsBloc;
  final TextEditingController tituloController = TextEditingController();
  Utils util = Utils();
  bool showWebView = false;
  void dispose() {
    // TODO: implement dispose
    super.dispose();
      WidgetsBinding.instance!.addPostFrameCallback((_) {
      _loadWebViewContent();
      _buildWebView();
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    eventsBloc = BlocProvider.of<EventsBloc>(context);

    return Expanded(
      flex: 8,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: util.boxDecorationDiv(),
        height: size.height * 1,
        child: _form(),
      ),
    );
  }

  Widget _form() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        showWebView = true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Ver Dashboard',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (showWebView) _buildWebView(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebView() {
    return SizedBox(
      width: size.width,
      height: size.height * 0.8,
      child: HtmlElementView(
        key: UniqueKey(),
        viewType: 'webview_dashboard',
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _loadWebViewContent();
    });
  }

  void _loadWebViewContent() {
    final html.IFrameElement iframe = html.IFrameElement()
      ..width = '100%'
      ..height = '100%'
      ..src = 'https://api.whatsapp.com/send?phone=${widget.numero}&text=we'
      ..style.border = 'none';

    js.context.callMethod('eval', ['''
      () => {
        const iframe = document.createElement('iframe');
        iframe.style.width = '100%';
        iframe.style.height = '100%';
        iframe.src = 'https://api.whatsapp.com/send?phone=${widget.numero}&text=we';
        iframe.style.border = 'none';
        document.body.appendChild(iframe);
        return iframe;
      }
    ''']);

    platformViewRegistry.registerViewFactory(
      'webview_dashboard',
      (int viewId) => iframe,
    );
  }
}

