import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class OrderTile extends StatelessWidget {
  final String orderId;

  OrderTile(this.orderId);

  Future<DocumentSnapshot> returnUsersOrder() async {
    await Firebase.initializeApp();
    return FirebaseFirestore.instance
        .collection("users_orders")
        .doc(this.orderId)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: StreamBuilder<DocumentSnapshot>(
          stream: returnUsersOrder().asStream(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              int status = snapshot.data!["status"];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Codigo do pedido: ${snapshot.data!.id}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.0,),
                  FutureBuilder(
                    future: _buildProductText(snapshot.data!.data()),
                      builder: (context, snapshot) {
                        return Text(
                          //_buildProductText(snapshot.data!.data()) != "" ?
                            snapshot.data.toString()
                          //: "Falha ao obter os valores"
                        );
                      }
                  ),
                  SizedBox(height: 4.0,),
                  Text(
                    "Status do pedido:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _buildCircle("1", "Preparação", status, 1),
                      Container(
                        height: 1.0,
                        width: 40.0,
                        color: Colors.grey,
                      ),
                      _buildCircle("2", "Transporte", status, 2),
                      Container(
                        height: 1.0,
                        width: 40.0,
                        color: Colors.grey,
                      ),
                      _buildCircle("3", "Entrega", status, 3),
                    ],
                  )
                ],
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCircle(String title, String subtitle, int status, int thisStatus){
    Color backColor;
    Widget child;

    if (status < thisStatus) {
      backColor = Colors.grey;
      child = Text(title, style: TextStyle(color: Colors.white),);
    } else if (status == thisStatus) {
      backColor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(title, style: TextStyle(color: Colors.white),),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      );
    } else {
      backColor = Colors.green;
      child = Icon(Icons.check);
    }

    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subtitle)
      ],
    );
  }

  Future<String> _buildProductText(dynamic snapshot) async {
    String text = "Descrição:\n";
      for (LinkedHashMap p in snapshot["products"]) {
        double price = await _returnProductPrice(p["pid"], p["category"]);
        text += "${p["quantity"]} x ${p["resume"]["title"]} (R\$ ${price.toStringAsFixed(2)})\n";
      }
      text += "Total: R\$ ${snapshot["totalPrice"].toStringAsFixed(2)}";
      return text;
  }

   Future<double> _returnProductPrice(String pid, String category) async {
    DocumentSnapshot snapshot = await _returnProducts(pid: pid, category: category);
    return snapshot.get("price");
  }

  Future<DocumentSnapshot> _returnProducts({String pid = "", String category = ""}) async {
    await Firebase.initializeApp();
    return FirebaseFirestore.instance
        .collection("products")
        .doc(category)
        .collection("itens")
        .doc(pid)
        .get();
  }
}
