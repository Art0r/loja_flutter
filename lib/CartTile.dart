import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/CartProduct.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loja_virtual/Product.dart';

class CartTile extends StatelessWidget {

  final CartProduct cartProduct;

  CartTile(this.cartProduct);

  Future<DocumentSnapshot> getProducts(category, pid) async {
      await Firebase.initializeApp();

      return await FirebaseFirestore.instance
          .collection("products")
          .doc(category)
          .collection("itens")
          .doc(pid)
          .get();
  }

  @override
  Widget build(BuildContext context) {

    Widget _buildContent(){
      return Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            width: 120.0,
            child: Image.network(
                cartProduct.product.images[0],
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    cartProduct.product.title,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17.0
                    ),
                  ),
                  Text(
                    "Tamanho: ${cartProduct.size}",
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Text(
                    "Preço: ${cartProduct.product.price.toStringAsFixed(2)} reais",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                          onPressed: cartProduct.quantity > 1 ? () {

                          } : null,
                        color: Theme.of(context).primaryColor,
                          icon: Icon(Icons.remove),
                      ),
                      Text(cartProduct.quantity.toString()),
                      IconButton(
                        onPressed: () {

                        },
                        color: Theme.of(context).primaryColor,
                        icon: Icon(Icons.add),
                      ),
                      ElevatedButton(
                          onPressed: () {},
                          child: Text("Remover"),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.grey[500]
                              )
                          ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: cartProduct.product.title == ""?
        FutureBuilder<DocumentSnapshot>(
            future: getProducts(cartProduct.category, cartProduct.pid),
          builder: (context, snapshot) {
              if (snapshot.hasData) {
                DocumentSnapshot<Object?>? documentSnapshot = snapshot.data;
                cartProduct.product = Product.fromDocument(documentSnapshot!);
                return _buildContent();
              } else {
                return Container(
                  height: 70.0,
                  child: CircularProgressIndicator(),
                  alignment: Alignment.center,
                );
              }
          },
        ) :
          _buildContent()
    );
  }
}
