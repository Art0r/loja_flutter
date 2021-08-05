import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Product {
  String id = "", category = "", title = "", description = "";
  double price = 0.0;
  List images = [], sizes = [];

  Product.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.id;
    title = snapshot.get("title");
    description = snapshot.get("description");
    images = snapshot.get("images");
    sizes = snapshot.get("sizes");
    price = snapshot.get("price") + 0.0;
  }

  Product.withoutPreviousData();

  Product(String id, String title, String description, String category, List<String> images, List<String> sizes, double price) {
    this.id = id;
    this.title = title;
    this.description = description;
    this.category = category;
    this.images = images;
    this.sizes = sizes;
    this.price = price;
  }

  Map<String, dynamic> toResumedMap(String category){
    return {
      "title": title,
      "description": description,
      "category": category,
    };
  }


}