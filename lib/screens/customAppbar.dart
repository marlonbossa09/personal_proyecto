

import 'package:flutter/material.dart';

AppBar buildAppBar() {
  return AppBar(
    title: Text("Proyecto",
    style: TextStyle(color: Colors.white),),
    centerTitle: true,
    backgroundColor: Colors.indigo,
    actions: [
      IconButton(onPressed: (){}, icon: Icon(Icons.search))
    ],
  );
}