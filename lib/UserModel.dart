import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class UserModel extends Model {

  Map<String, dynamic> _userData = Map();
  bool _isLoading = false;

  static UserModel of(BuildContext context) =>
    ScopedModel.of<UserModel>(context);

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
  }

  Map<String, dynamic> get userData => _userData;

  set userData(Map<String, dynamic> value) {
    _userData = value;
  }


  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    _loadCurrentUser();

  }

  void signIn({required String email, required String pass,
    required VoidCallback onSuccess, required VoidCallback onFail}) async {

    this.isLoading = true;
    notifyListeners();

    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, password: pass).then((user) async {
      FirebaseAuth.instance.currentUser;

      await _loadCurrentUser();

      onSuccess();
      _isLoading = false;
      notifyListeners();
    }).catchError((onError) {
      onFail();
      _isLoading = false;
      notifyListeners();
    });
  }

  void signUp({required Map<String, dynamic> userData, required String pass,
      required VoidCallback onSuccess, required VoidCallback onFail}) async {

    FirebaseAuth _auth = FirebaseAuth.instance;
    this.isLoading = true;

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

  void recoveryPass(String email) async {
    await Firebase.initializeApp();

    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.sendPasswordResetEmail(email: email);
  }

  void initDB() async {
    await Firebase.initializeApp();

  }

  bool isLoggedIn() {
    initDB();
    return FirebaseAuth.instance.currentUser != null;
  }

  void signOut() async {
    await Firebase.initializeApp();
    await FirebaseAuth.instance.signOut();

    userData = Map();
    notifyListeners();
  }
  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firebase.initializeApp();
    await FirebaseFirestore.instance
        .collection("users").doc(FirebaseAuth
        .instance.tenantId)
        .set(this.userData);
  }

  Future<Null> _loadCurrentUser() async {
    await Firebase.initializeApp();

    QuerySnapshot docUser =
        await FirebaseFirestore.instance.collection('users')
            .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
            .get();

    userData["name"] = docUser.docs.first.get("name");
    userData["email"] = docUser.docs.first.get("email");
    userData["address"] = docUser.docs.first.get("address");
    
    notifyListeners();
  }
}