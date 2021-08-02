import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/UserModel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'LoginScreen.dart';
import 'OrderTile.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({Key? key}) : super(key: key);

  Future<QuerySnapshot> _getOrders(String uid) async {
    await Firebase.initializeApp();
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("orders")
        .get();
  }

  @override
  Widget build(BuildContext context) {
    if (UserModel.of(context).isLoggedIn()) {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      return FutureBuilder<QuerySnapshot>(
          future: _getOrders(uid),
          builder: (context, snapshot) {
            if(!snapshot.hasData) {
              return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView(
                children: snapshot.data!.docs.map(
                        (doc) => OrderTile(doc.id)).toList(),
              );
            }
          },
      );
    } else {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.view_list,
              size: 80.0,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 16.0,),
            Text(
              "Faça p login para acompanhar seus pedidos!",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0,),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen())
                );
              },
              child: Text("Entrar", style: TextStyle(fontSize: 18.0),),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)
              ),
            )
          ],
        ),
      );
    }
  }
}
