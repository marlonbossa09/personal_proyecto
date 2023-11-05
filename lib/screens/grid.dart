import 'package:flutter/material.dart';
import 'package:personal_proyecto/screens/lideres.dart';

bool fullScreen = true;
final int desktopBreakPoint = 1024;
  final int mobileBreakPoint = 720;
class GridCustom extends StatelessWidget {

  const GridCustom({super.key});

  @override
  Widget build(BuildContext context) {
    fullScreen = (MediaQuery.of(context).size.width >= desktopBreakPoint) ? true : false;
    int crossAxisCount = fullScreen ? 3 : 2;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage("https://i0.wp.com/ensedeciencia.com/wp-content/uploads/2022/01/images-63-1.jpg?w=739&ssl=1"),
          fit: BoxFit.cover,
          opacity: 0.7,
        ),
      ),
      child: GridView.count(
      crossAxisCount: crossAxisCount,
  mainAxisSpacing: 20,
  crossAxisSpacing: 20,
      children: [
      Card(color1: Colors.green, ensayo: ImagenAvatar(imagen: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/1/1f/Dwayne_Johnson_2014_%28cropped%29.jpg')),),
      Card(color1: Colors.blue, ensayo: ImagenAvatar(imagen: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/9/98/Radamel_Falcao_Garc%C3%ADa_%28cropped%29.jpg')),),
      Card(color1: Colors.red, ensayo: ImagenAvatar(imagen: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/b/b4/Lionel-Messi-Argentina-2022-FIFA-World-Cup_%28cropped%29.jpg')),),
      Card(color1: Colors.red, ensayo: ImagenAvatar(imagen: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/1/1d/Shakira_for_VOGUE_in_2021_2.png')),),
      Card(color1: Colors.red, ensayo: ImagenAvatar(imagen: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/0/0c/Diomedesdiaz2.png')),),
      Card(color1: Colors.red, ensayo: ImagenAvatar(imagen: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/1/14/Vicente_Fern%C3%A1ndez_-_Pepsi_Center_-_06.11.11.jpg')),),
      Card(color1: Colors.red, ensayo: ImagenAvatar(imagen: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/1/14/Vicente_Fern%C3%A1ndez_-_Pepsi_Center_-_06.11.11.jpg')),),
      Card(color1: Colors.red, ensayo: ImagenAvatar(imagen: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/1/14/Vicente_Fern%C3%A1ndez_-_Pepsi_Center_-_06.11.11.jpg')),),
      Card(color1: Colors.red, ensayo: ImagenAvatar(imagen: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/1/14/Vicente_Fern%C3%A1ndez_-_Pepsi_Center_-_06.11.11.jpg')),),
      ],
      ),
      
    );
  }
}

class Card extends StatelessWidget {
  final Color color1;
  final double? altura = 100;
  final double? ancho = 100;
  final Widget ensayo;
 Card({
    super.key, required this.color1, required this.ensayo
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: altura,
      width: ancho,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ensayo,
            ),
              Text('Nombre.Producto',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.black87),),
              Text('Precio.Producto',style: TextStyle(color: Colors.black87),),
              TextButton(onPressed: (){
                Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => RegistrarProductos()),
                                      );
              },
               child: Text('Ver'),
               style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                ),
               )
          ],
        ) 
    );
  }
}

class ImagenAvatar extends StatelessWidget {

  final NetworkImage imagen;

  const ImagenAvatar({
    required this.imagen,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircleAvatar(
          radius: 55.0,
          backgroundImage: imagen,
        ),
      );
  }
}
