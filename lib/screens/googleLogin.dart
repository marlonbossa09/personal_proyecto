import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:personal_proyecto/services/googleSignInService.dart';


class GoogleLogin extends StatefulWidget {
  const GoogleLogin({super.key});

  @override
  State<GoogleLogin> createState() => _GoogleLoginState();
}

class _GoogleLoginState extends State<GoogleLogin> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
          actions: [
            IconButton(onPressed: (){},
             icon: Icon(FontAwesomeIcons.doorOpen))
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  MaterialButton(
                    splashColor: Colors.transparent,
                    minWidth: double.infinity,
                    height: 40,
                    color: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    onPressed: (){
                      GoogleSignInService.signInWithGoogle();
                    },
                   child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FontAwesomeIcons.google, color: Colors.white,),
                      Text('Acceder por google', style: TextStyle(color: Colors.white, fontSize: 17),),
                    ],
                   ))
              ],
            ),
          ),
        )
      ),
    );
  }
}