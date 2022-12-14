import 'package:app_movil_city/boxes.dart';
import 'package:app_movil_city/models/local_favorite.dart';
import 'package:app_movil_city/models/poi.dart';
import 'package:app_movil_city/pages/googlemap_page.dart';
import 'package:app_movil_city/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritos'),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            onPressed: (){
              setState(() {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
              });
            },
          ),
        ]
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: Center(
          child:_buildListView(),
        ),
      ),
    );
  }

  Widget _buildListView(){
    return ValueListenableBuilder<Box<LocalFavorite>>(
        valueListenable: Boxes.getFavoritesBox().listenable(),
        builder: (context, box, _){
          final favoriteBox = box.values.toList().cast<LocalFavorite>();
          return ListView.builder(
            itemCount: favoriteBox.length,
            itemBuilder: (BuildContext context, int index){
              final favorite = favoriteBox[index];
              return Card(
                child: ListTile(
                  leading: Image(image: AssetImage(favorite.foto??"No Photo")),
                  title: Text(favorite.nombre??"No Title"),
                  subtitle: Text(favorite.puntuacion.toString()??"No Punctuation"),
                  onLongPress: (){
                    setState(() {
                      favorite.delete();
                    });
                  },
                  onTap: (){
                    setState(() {
                      Poi poiFavorito = Poi(favorite.id, favorite.foto, favorite.nombre, '', favorite.puntuacion, favorite.latitud, favorite.longitud);
                      print('=========> Muestra el mapa!!!! ${poiFavorito.nombre} ${poiFavorito.latitud} ${poiFavorito.longitud}');
                      Navigator.push(context, MaterialPageRoute(builder: (context) => GoogleMapPage(poiFavorito.nombre, poiFavorito.latitud, poiFavorito.longitud)));
                    });
                  },
                ),
              );
            },
          );
        }
    );
  }
}
