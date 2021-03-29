import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ubberclone/allscreen/mainsreen.dart';
import 'package:ubberclone/allscreen/registerscreen.dart';
import 'package:ubberclone/main.dart';
import 'package:ubberclone/allwidgets/progressDialog.dart';

class Login extends StatelessWidget {
  static const String idScreen = "loginscreen";
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
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
                height: 35.0,
              ),
              Image(
                image: AssetImage("images/logo.png"),
                width: 390.0,
                height: 250.0,
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 1.0,
              ),
              Text(
                "Login as Rider",
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
                      controller: emailTextController,
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
                      controller: passwordTextController,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(fontSize: 14.0),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0)),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    RaisedButton(
                      color: Colors.yellow,
                      textColor: Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 18.0, fontFamily: "Brand bold"),
                            ),
                          ),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0)),
                      onPressed: () {
                        if (!emailTextController.text.contains("@")) {
                          displayToastMessage(
                              "Email adresse n'est pas valide", context);
                        } else if (passwordTextController.text.isEmpty) {
                          displayToastMessage(
                              "le mot de passe est obligatoire", context);
                        } else {
                          logginAndAuthenUser(context);
                        }
                      },
                    )
                  ],
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, Register.idScreen, (route) => false);
                },
                child: Text("do not have a anncount"),
              )
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  void logginAndAuthenUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(message: "Authentificating , please wait");
        });
    final User firebaseuser = (await auth
            .signInWithEmailAndPassword(
                email: emailTextController.text,
                password: passwordTextController.text)
            .catchError((Ermsg) {
      Navigator.pop(context);
      displayToastMessage("error : " + Ermsg.toString(), context);
    }))
        .user;

    if (firebaseuser != null) {
      usersref.child(firebaseuser.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, MainScreen.idScreen, (route) => false);
        } else {
          Navigator.pop(context);
          auth.signOut();
          displayToastMessage(
              "cet utulisateur n'existe pas ! , please creer un nouveau utilisateur",
              context);
        }
      });
    } else {
      Navigator.pop(context);
      displayToastMessage("vous ne pouvez pas vous connectez", context);
    }
  }
}
