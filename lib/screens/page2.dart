import 'package:flutter/material.dart';
import 'package:personal_proyecto/screens/grid.dart';

class Page2Screen extends StatelessWidget {
   
  const Page2Screen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Stack(
      children: [
        GridCustom(),
        Container(
          alignment: Alignment.topCenter,
          color: Color.fromARGB(199, 63, 81, 181),
          height: 30,
          child: Column(
            children: [
              Text('PRINCIPALES PRODUCTOS',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black87),)
            ],
          ),
        )
      ],
    )
    );
  }
}
