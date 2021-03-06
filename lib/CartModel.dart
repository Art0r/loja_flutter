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
  String coupon = "";
  int discountPercent = 0;

  CartModel(this.userModel) {
    if(this.userModel.isLoggedIn())
    loadCartItens();
  }



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

  void decProduct(CartProduct product) async {
    product.quantity--;

    await Firebase.initializeApp();
    FirebaseFirestore.instance
        .collection("orders")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("cart")
        .doc(product.cid)
        .update(product.toMap());

    notifyListeners();
  }

  void incProduct(CartProduct product) async {
    product.quantity++;

    await Firebase.initializeApp();
    FirebaseFirestore.instance
        .collection("orders")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("cart")
        .doc(product.cid)
        .update(product.toMap());

    notifyListeners();
  }

  void loadCartItens() async {
    await Firebase.initializeApp();

    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("orders")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("cart")
        .get();

    products = query.docs.map((document) =>
        CartProduct.fromDocument(document)).toList();

    notifyListeners();
  }

  double getProductsPrice(){
    double price = 0.0;
    for(CartProduct c in products){
      if(c.product != null){
        price += c.quantity * c.product.price;
      }
    }
    return price;
  }

  double getDiscount(){
    return getProductsPrice() * discountPercent / 100;
  }

  double getShipPrice(){
    return 9.90;
  }

  void updatePrices(){
    notifyListeners();
  }

  void setCoupon(String couponCode, int percent){
    this.coupon = coupon;
    this.discountPercent = percent;
  }

  Future<String> finishOrder() async {
    if (products.length == 0) return "";

    this.isLoading = true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    await Firebase.initializeApp();
    DocumentReference refOrder = await FirebaseFirestore.instance
      .collection("users_orders")
      .add({
          "clientId": FirebaseAuth.instance.currentUser!.uid,
          "products": products.map((e) => e.toMap()).toList(),
          "shipPrice": shipPrice,
          "productsPrice": productsPrice,
          "discount": discount,
          "totalPrice": productsPrice - discount + shipPrice,
          "status": 1
      });

    await FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("orders")
      .doc(refOrder.id)
      .set({
        "orderId": refOrder.id
      });

    QuerySnapshot query = await FirebaseFirestore.instance
      .collection("orders")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("cart")
      .get();

    for(DocumentSnapshot doc in query.docs) {
      doc.reference.delete();
    }

    products.clear();
    discountPercent = 0;
    coupon = "";

    this.isLoading = false;
    notifyListeners();

    return refOrder.id;
  }


}