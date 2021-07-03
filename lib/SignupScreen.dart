import 'package:flutter/material.dart';
import 'package:loja_virtual/UserModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_core/firebase_core.dart';
class SignupScreen extends StatelessWidget {

  final _nameController =  TextEditingController();
  final _emailController =  TextEditingController();
  final _passController =  TextEditingController();
  final _addressController =  TextEditingController();

  final _formKey =  GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Signup"),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          if (model.isLoading) return Center(child: CircularProgressIndicator(),);
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Nome Completo",
                  ),
                  validator: (text) {
                    if (text!.isEmpty) return "Nome faltando";
                  },
                ),
                SizedBox(height: 16.0,),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "E-mail",
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (text) {
                    if (text!.isEmpty || !text.contains("@")) return "Email faltando";
                  },
                ),
                SizedBox(height: 16.0,),
                TextFormField(
                  controller: _passController,
                  decoration: InputDecoration(
                    hintText: "Password",
                  ),
                  obscureText: true,
                  validator: (text){
                    if (text!.isEmpty || text.length < 6) return "Senha inválida";
                  },
                ),
                SizedBox(height: 16.0,),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    hintText: "Address",
                  ),
                  validator: (text) {
                    if (text!.isEmpty) return "Address faltando";
                  },
                ),
                SizedBox(height: 16.0,),
                SizedBox(
                  height: 44.0,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor)
                      ),
                      onPressed: () {

                        if (_formKey.currentState!.validate()){

                          Map<String, dynamic> userData = {
                            "name": _nameController.text,
                            "email": _emailController.text,
                            "address": _addressController.text
                          };

                          model.signUp(
                              userData: userData,
                              pass: _passController.text,
                              onSuccess: _onSuccess,
                              onFail: _onFail
                          );
                        }
                      },
                      child: Text(
                        "Cadastrar",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0
                        ),
                      )
                  ),
                )
              ],
            ),
          );
        }
      )
    );
  }
}

void _onSuccess(){

}

void _onFail(){

}