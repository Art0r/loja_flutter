import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Product {
  String _id = "", _category = "", _title = "", _description = "";
  double _price = 0.0;
  List _images = [], _sizes = [];

  Product.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.id;
    title = snapshot.get("title");
    description = snapshot.get("description");
    images = snapshot.get("images");
    sizes = snapshot.get("sizes");
    price = snapshot.get("price") + 0.0;
  }

  Product(String id, String title, String description, String category, List<String> images, List<String> sizes, double price) {
    this.id = id;
    this.title = title;
    this.description = description;
    this.category = category;
    this.images = images;
    this.sizes = sizes;
    this.price = price;
  }

  void ShowData() {
    print(id);
    print(title);
    print(description);
    print(category);
    print(images);
    print(sizes);
    print(price);
  }

  get sizes => _sizes;

  set sizes(value) {
    _sizes = value;
  }

  List get images => _images;

  set images(List value) {
    _images = value;
  }

  double get price => _price;

  set price(double value) {
    _price = value;
  }

  get description => _description;

  set description(value) {
    _description = value;
  }

  get title => _title;

  set title(value) {
    _title = value;
  }

  get category => _category;

  set category(value) {
    _category = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }


}