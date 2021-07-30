import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'CartModel.dart';

class DiscountCard extends StatelessWidget {
  const DiscountCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text("Cupom de Desconto",
        textAlign: TextAlign.start,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.grey[700]
          ),
        ),
        leading: Icon(Icons.card_giftcard),
        trailing: Icon(Icons.add),
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Digite seu cupom"
              ),
              initialValue: CartModel.of(context).coupon.isEmpty
                  ? "" : CartModel.of(context).coupon,
              onFieldSubmitted: (text) async {
                await Firebase.initializeApp();
                FirebaseFirestore.instance
                  .collection("coupon")
                  .doc(text).get().then(
                        (value) {
                          if (value.exists) {
                            CartModel.of(context)
                                .setCoupon(text, value.data()!["percent"]);
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "Desconto de ${value.data()!["percent"]}% aplicado"
                                  ),
                                backgroundColor: Theme.of(context).primaryColor,
                              )
                            );
                          } else {
                            CartModel.of(context).setCoupon("", 0);
                            Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Cupom não existente"
                                  ),
                                  backgroundColor: Colors.redAccent,
                                )
                            );
                          }
                        });
              },
            ),
          )
        ],
      ),
    );
  }
}
