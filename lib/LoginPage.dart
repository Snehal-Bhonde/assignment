


import 'package:assignment/database/DatabaseHelper.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  late BuildContext _ctx;
  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  late String _email, _password;


  void _register() {
    Navigator.of(context).pushNamed("/register");
  }

  void _submit() {
    final form = formKey.currentState;

    if (form!.validate()) {
      setState(() {
        _isLoading = true;
        form.save();
       // _presenter.doLogin(_email, _password);
      });
    }
  }

  void _showSnackBar(String text) {
    // scaffoldKey.currentState?.showSnackBar(new SnackBar(
    //   content: new Text(text),
    // ));
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    var loginBtn = new ElevatedButton(
      onPressed: _submit,
      child: new Text("Login"),
      //color: Colors.green,
    );
    var registerBtn = new ElevatedButton(
      onPressed: _register,
      child: new Text("Register"),
    );
    var loginForm = new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Text(
          "Sqflite App Login",
          textScaleFactor: 2.0,
        ),
        new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(20.0),
                child: new TextFormField(
                  onSaved: (val) => _email = val!,
                  decoration: new InputDecoration(labelText: "Email"),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(20.0),
                child: new TextFormField(
                  onSaved: (val) => _password = val!,
                  decoration: new InputDecoration(labelText: "Password"),
                ),
              )
            ],
          ),
        ),
        new Padding(
            padding: const EdgeInsets.all(10.0),
            child: loginBtn),

        registerBtn
      ],
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Login Page"),
      ),
      key: scaffoldKey,
      body: new Container(
        child: new Center(
          child: loginForm,
        ),
      ),
    );
  }

  void onLoginError(String error) {
    // TODO: implement onLoginError
    _showSnackBar("Login not successful");
    setState(() {
      _isLoading = false;
    });
  }


void onLoginSuccess(User user) async {
  // TODO: implement onLoginSuccess
  if(user.username == ""){
    _showSnackBar("Login not successful");
  }else{
    _showSnackBar(user.toString());
  }
  setState(() {
    _isLoading = false;
  });
  if(user.flaglogged == "logged"){
    print("Logged");
    Navigator.of(context).pushNamed("/home");
  }else{
    print("Not Logged");
  }
}
}