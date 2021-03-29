import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ubberclone/allscreen/LoginScreen.dart';
import 'package:ubberclone/allscreen/mainsreen.dart';
import 'package:ubberclone/main.dart';
import 'package:ubberclone/allwidgets/progressDialog.dart';

class Register extends StatelessWidget {
  static const String idScreen = "registerscreen";
  TextEditingController nameTextditingController = TextEditingController();
  TextEditingController emailTextditingController = TextEditingController();
  TextEditingController phoneTextditingController = TextEditingController();
  TextEditingController passwordTextditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 23.0,
              ),
              Image(
                image: AssetImage("images/logo.png"),
                width: 390.0,
                height: 250.0,
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "Register as Rider",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: nameTextditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(fontSize: 14.0),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0)),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: emailTextditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(fontSize: 14.0),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0)),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: phoneTextditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          labelText: "Phone",
                          labelStyle: TextStyle(fontSize: 14.0),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0)),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: passwordTextditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(fontSize: 14.0),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0)),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    RaisedButton(
                      color: Colors.yellow,
                      textColor: Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Center(
                            child: Text(
                              "Créer un compte",
                              style: TextStyle(
                                  fontSize: 18.0, fontFamily: "Brand bold"),
                            ),
                          ),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0)),
                      onPressed: () {
                        if (nameTextditingController.text.length < 3) {
                          displayToastMessage(
                              "le nom doit contenir 3 caracteres", context);
                        } else if (!emailTextditingController.text
                            .contains("@")) {
                          displayToastMessage(
                              "Email adresse n'est pas valide", context);
                        } else if (phoneTextditingController.text.isEmpty) {
                          displayToastMessage(
                              "le numero de telephone est obligatoire",
                              context);
                        } else if (passwordTextditingController.text.length <
                            6) {
                          displayToastMessage(
                              "le mot de passe doit contenir 6 caracteres",
                              context);
                        } else {
                          registerNewUser(context);
                        }
                      },
                    )
                  ],
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, Login.idScreen, (route) => false);
                },
                child: Text("already have a anncount ! login here"),
              )
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  void registerNewUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(message: "Authentificating , please wait");
        });
    final User firebaseUser = (await auth
            .createUserWithEmailAndPassword(
                email: emailTextditingController.text,
                password: passwordTextditingController.text)
            .catchError((ermsg) {
      displayToastMessage("Error : " + ermsg.toString(), context);
    }))
        .user;

    if (firebaseUser != null) {
      Map userDataMap = {
        "name": nameTextditingController.text.trim(),
        "email": emailTextditingController.text.trim(),
        "phone": phoneTextditingController.text.trim()
      };
      usersref.child(firebaseUser.uid).set(userDataMap);
      displayToastMessage("Congratulations, votre compte est creer", context);
      Navigator.pushNamedAndRemoveUntil(
          context, Login.idScreen, (route) => false);
    } else {
      Navigator.pop(context);
      displayToastMessage("aucun utuilsateur crée", context);
    }
  }
}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}
