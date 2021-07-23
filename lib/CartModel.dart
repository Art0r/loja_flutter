import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'CartProduct.dart';
import 'UserModel.dart';
import 'package:flutter/material.dart';

class CartModel extends Model {
  UserModel userModel;
  List<CartProduct> products = [];
  bool isLoading = false;

  CartModel(this.userModel);

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addItemOnCart(CartProduct cartProduct) async {
    products.add(cartProduct);

    await Firebase.initializeApp();
    FirebaseAuth auth =  FirebaseAuth.instance;
    FirebaseFirestore.instance.collection("orders")
        .doc(auth.currentUser!.uid)
        .collection("cart").add(cartProduct.toMap()).then(
            (doc) {
              cartProduct.cid = doc.id;
            });
        notifyListeners();
  }

  void removeItemOnCart(CartProduct cartProduct) async {
    await Firebase.initializeApp();
    FirebaseAuth auth =  FirebaseAuth.instance;
    FirebaseFirestore.instance.collection("orders")
        .doc(auth.currentUser!.uid)
        .collection("cart")
        .doc(cartProduct.cid)
        .delete();
    
    products.remove(cartProduct);
    notifyListeners();
  }
}