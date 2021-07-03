import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'UserModel.dart';
import 'SignupScreen.dart';

class LoginScreen extends StatelessWidget {

  final _formKey =  GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignupScreen())
                );
              },
              child: Text(
                  "Criar conta",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white
                ),
              )
          ),
        ],
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading) return Center(child: CircularProgressIndicator(),);
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "E-mail",
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (text) {
                    if (text!.isEmpty || !text.contains("@")) return "Email inválido";
                  },
                ),
                SizedBox(height: 16.0,),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Password",
                  ),
                  obscureText: true,
                  validator: (text){
                    if (text!.isEmpty || text.length < 6) return "Senha faltando";
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {

                    },
                    child: Text(
                      "Esqueci minha senha",
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
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

                        }
                        model.signIn();
                      },
                      child: Text(
                        "Entrar",
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
        },
      )
    );
  }
}
