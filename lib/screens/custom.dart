import 'package:flutter/material.dart';

buildDrawer(BuildContext context) {

  buildListTile(int index, IconData icon, String name){
    return Container(
      child: ListTile(
        title: ElevatedButton(
          onPressed: (){}, 
          child: 
        Row(
          children: [Icon(icon),
          SizedBox(width: 20.0,),
          Text(name),
          ],
        )),
      ),
    );
  }


  return Container(
    width: 265,

    child: Drawer(
      elevation: 15.0,
      child: Container(
        color: Colors.blueAccent,
        child: Scrollbar(child: 
        SingleChildScrollView(child: Column(
          children: [Center(
            child: Container(
              height: 130,
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Center(
                child: CircleAvatar(
                  radius: 35.0,
                  backgroundImage: NetworkImage("https://fotografias.antena3.com/clipping/cmsimages01/2017/03/17/7EF92031-EE35-44F7-8DC2-D3EF8CE477E2/97.jpg?crop=1264,711,x0,y0&width=1600&height=900&optimize=high&format=webply"),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.all(10.0),
          child: Text("Marlon Bossa", style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),),),
          buildListTile(0, Icons.search, "Busqueda"),
          ],
        ),)),
      ),
    ),
  );
}