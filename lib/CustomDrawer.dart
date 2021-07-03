import 'package:flutter/material.dart';
import 'DrawerTile.dart';
import 'LoginScreen.dart';

class CustomDrawer extends StatelessWidget {
  //const CustomDrawer({Key? key}) : super(key: key);

  final PageController pageController;

  CustomDrawer(this.pageController);

  Widget _buildDrawerBack() => Container(
    decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: <Color>[
              Color.fromARGB(255, 203, 236, 241),
              Colors.white
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
        )
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32.0, top: 16.0),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 170,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                        top: 8.0,
                        left: 0.0,
                        child: Text("Flutter's\nClothing",
                                style: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold),
                        ),
                    ),
                    Positioned(
                        left: 0.0,
                        bottom: 0.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Olá,",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            GestureDetector(
                              child: Text(
                                "Entre ou Cadastre-se >",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => LoginScreen())
                                );
                              },
                            ),
                          ],
                        )
                    )
                  ],
                )
              ),
              Divider(),
              DrawerTile(Icons.home, "Início", this.pageController, 0),
              DrawerTile(Icons.list, "Produtos", this.pageController, 1),
              DrawerTile(Icons.location_on, "Lojas", this.pageController, 2),
              DrawerTile(Icons.playlist_add_check, "Meus pedidos", this.pageController, 3)
            ],
          )
        ],
      ),
    );
  }
}
