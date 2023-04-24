


import 'package:assignment/CharacterDetails.dart';
import 'package:assignment/SignupPage.dart';
import 'package:assignment/database/DatabaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  late BuildContext _ctx;
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _passwordVisible = false;
  late String _email, _password;


  void _register() {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return SignupPage();
        }));
  }

  Future<void> _submit() async {
    final form = formKey.currentState;
    print("inside login 1");
    if (form!.validate()) {
      //setState(() {
        _isLoading = true;
        form.save();
        var db = DatabaseHelper();
        print("inside login 3");
        print("_email $_email  _password  $_password");
        //_presenter.doLogin(_email, _password);
        User? res= await db.getLogin(_email, _password);
        print(res);
      //});
        if(res!=null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Login Successful')));
          print("Login");
          final prefs = await SharedPreferences.getInstance();
          prefs.setString("Name", res!.name);
          prefs.setString("UserName", res!.username);
          Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return CharacterDetails();
              }));
        }
        else{
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Invalid credentials")));
        }
    }
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(text),
    ));
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    var loginBtn =  ElevatedButton(
      onPressed: _submit,
      child:  Text("Login"),
      //color: Colors.green,
    );
    var registerBtn =  ElevatedButton(
      onPressed: _register,
      child:  Text("Signup"),
    );
    var loginForm =  ListView(
      shrinkWrap: true,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
             Text(
              "Sqflite App Login",
              textScaleFactor: 2.0,
            ),
            Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextFormField(
                      onSaved: (val) => _email = val!,
                      decoration: InputDecoration(labelText: "Email"),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(40),
                      ],
                      validator: (email) {
                        if (isEmailValid(email!))
                          return null;
                        else
                          return 'Enter a valid email address';
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextFormField(
                      onSaved: (val) => _password = val!,
                      decoration: InputDecoration(
                          labelText: "Password",
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(8),
                      ],
                      obscureText: !_passwordVisible,
                      validator: (val){
                        if(val!.length<8){
                          return 'Enter atleast 8 characters';
                        }
                        else return null;
                      },
                    ),
                  )
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: loginBtn),

            registerBtn
          ],
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title:  Text("Login Page"),
      ),
      key: scaffoldKey,
      body:  Container(
        child:  Center(
          child: loginForm,
        ),
      ),
    );
  }

  bool isEmailValid(String s) {
    final bool emailValid =
    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(s);
    return emailValid;
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

abstract class LoginCallBack {
  void onLoginSuccess(User user);
  void onLoginError(String error);
}

class LoginResponse {
  LoginCallBack _callBack;
  LoginRequest loginRequest = new LoginRequest();
  LoginResponse(this._callBack);

  doLogin(String username, String password) {
    loginRequest
        .getLogin(username, password)
        .then((user) => _callBack.onLoginSuccess(user!))
        .catchError((onError) => _callBack.onLoginError(onError.toString()));
  }
}

class LoginRequest {
  DatabaseHelper con = new DatabaseHelper();

  Future<User?> getLogin(String username, String password) {
    var result = con.getLogin(username,password);
    return result;
  }
}