import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class UserModel extends Model {

  Map<String, dynamic> _userData = Map();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
  }

  Map<String, dynamic> get userData => _userData;

  set userData(Map<String, dynamic> value) {
    _userData = value;
  }


  void signIn() async {
    this.isLoading = true;
    notifyListeners();
    
    await Future.delayed(Duration(seconds: 3));

    this.isLoading = false;
    notifyListeners();
  }

  void signUp({required Map<String, dynamic> userData, required String pass,
      required VoidCallback onSuccess, required VoidCallback onFail}) async {

    FirebaseAuth _auth = FirebaseAuth.instance;
    this.isLoading = true;
    notifyListeners();

    _auth.createUserWithEmailAndPassword(
        email: userData['email'],
        password: pass
    ).then((user) async {
      await this._saveUserData(userData);
      onSuccess();
      this.isLoading = false;
      notifyListeners();
    }).catchError((error) {
      onFail();
      this.isLoading = false;
      notifyListeners();
    });
  }

  void recoveryPass() {

  }

  bool isLoggedIn() {
    return false;
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firebase.initializeApp();
    await FirebaseFirestore.instance
        .collection("users").doc(FirebaseAuth
        .instance.tenantId)
        .set(this.userData);
  }
}