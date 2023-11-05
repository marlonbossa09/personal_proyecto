import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Utils {

  BoxDecoration boxDecoration(){
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      boxShadow: <BoxShadow>[
        BoxShadow(
            color: Color.fromARGB(19, 0, 0, 0),
            blurRadius: 3.0,
            spreadRadius: 2.0),
      ],
      border: Border.symmetric()
    );
  }

  BoxDecoration boxDecoration2(){
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      boxShadow: <BoxShadow>[
        BoxShadow(
            color: Color.fromARGB(31, 0, 0, 0),
            blurRadius: 4.0,
            spreadRadius: 1.0),
      ],
      border: Border.symmetric()
    );
  }
  
  BoxDecoration boxDecorationDiv(){
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(0)),
      boxShadow: <BoxShadow>[
        BoxShadow(
            color: Color.fromARGB(41, 0, 0, 0),
            blurRadius: 3.0,
            spreadRadius: 2.0),
      ],
    );
  }

  BoxDecoration boxDecorationBlue(){
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(5)),
      border: Border.all(color: Colors.blue,width: 1)
    );
  }

  InputDecoration inputDecoration(String title,bool mostrarTitle){
    return InputDecoration(
          label: mostrarTitle?Text(title):null,
          fillColor: Colors.white,
          filled: true,
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Color.fromARGB(255, 224, 224, 224)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Color.fromARGB(255, 224, 224, 224)),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Color.fromARGB(255, 255, 112, 112)),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Color.fromARGB(255, 255, 112, 112)),
          ),floatingLabelBehavior: FloatingLabelBehavior.never
        );
  }

  Widget tituloBlack(String titulo,double padding,double size,Color color_,bool bold){
    return  Padding(
      padding: EdgeInsets.all(padding),
      child: Text(
        titulo,
        style: TextStyle(
          fontSize: size,
          color: color_,
          fontWeight: bold? FontWeight.bold :FontWeight.normal
        )
      ),
    );
  }

  alertWarning(BuildContext context_, mensaje){
    return ScaffoldMessenger.of(context_).showSnackBar(
      SnackBar(
        dismissDirection: DismissDirection.endToStart,
      duration: const Duration(seconds: 3),
      backgroundColor: Color.fromARGB(148, 255, 4, 0),
      content: Container(
          height: 50,
          alignment: Alignment.center,
          child: Text(mensaje,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18)
          )),
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0, // Inner padding for SnackBar content.
      ),
    ));
  }

  message(BuildContext context_,String mensaje,Color color){
    return ScaffoldMessenger.of(context_).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: ListTile(
          title: Text('¡Informacion!',style: TextStyle(color: color,fontWeight: FontWeight.bold),),
          subtitle: Text(mensaje),
          leading: Icon(Icons.info_outlined,color: color,size: 35,),
          trailing: IconButton(
            icon: Icon(Icons.cancel_outlined,color: color,),
            onPressed: (){
              ScaffoldMessenger.of(context_).hideCurrentSnackBar();
            }),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(0),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context_).size.height - 127,
            right: 20,
            left: MediaQuery.of(context_).size.width *0.7,),
      ));
  }

  Widget loading(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        LoadingAnimationWidget.staggeredDotsWave(
          color: Colors.orange,
          size: 40,
        ),
      ],
    );
  }

}