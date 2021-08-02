import 'package:flutter/material.dart';
import 'package:loja_virtual/CartModel.dart';
import 'package:loja_virtual/CartPrice.dart';
import 'package:loja_virtual/DiscountCart.dart';
import 'package:loja_virtual/ShipCard.dart';
import 'package:loja_virtual/UserModel.dart';
import 'package:loja_virtual/orderScreen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'CartTile.dart';
import 'LoginScreen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu Carrinho"),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 8.0),
            alignment: Alignment.center,
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model){
                int p = model.products.length;
                return Text(
                  "${p == null ? 0 : p} ${p == 1 ? 'Item' : 'Itens'}",
                  style: TextStyle(fontSize: 20.0),
                );
              },
            ),
          )
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
        builder: (context, child, model){
            if (model.isLoading && UserModel.of(context).isLoggedIn()) {
              return Center(child: CircularProgressIndicator(),);
            } else if (!UserModel.of(context).isLoggedIn()){
              return Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.remove_shopping_cart,
                      size: 80.0,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(height: 16.0,),
                    Text(
                      "Faça p login para adicionar produtos!",
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
            } else if(model.products == null || model.products.length == 0){
              return Center(
                child: Text("Nenhum produto adicionado!"),
              );
            }
            return ListView(
              children: <Widget>[
                Column(
                  children: model.products.map(
                          (product) {
                            return CartTile(product);
                          }
                  ).toList(),
                ),
                DiscountCard(),
                ShipCard(),
                CartPrice(() async {
                  String orderId = await model.finishOrder();
                  if (orderId != "") {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => OrderScreen(orderId))
                    );
                  }
                })
              ],
            );
        },
      ),
    );
  }
}
