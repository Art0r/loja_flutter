import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/Product.dart';

class CartProduct {
  String cid = "", category = "", pid = "", size = "";
  int quantity = 0;
  
  Product _product = Product.withoutData();

  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot documentSnapshot){
    this.cid = documentSnapshot.id;
    this.category = documentSnapshot.get("category");
    this.pid = documentSnapshot.get("pid");
    this.quantity = documentSnapshot.get("quantity");
    this.size = documentSnapshot.get("size");
  }


  Map<String, dynamic> toMap() {
    return {
      "category": this.category,
      "pid": this.pid,
      "quantity": this.quantity,
      "size": this.size,
      //"resume": this.toMap()
    };
  }



}