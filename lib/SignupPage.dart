
import 'package:assignment/LoginPage.dart';
import 'package:assignment/database/DatabaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState  extends State<SignupPage> {
  late BuildContext _ctx;
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _passwordVisible = false;
  String _name="", _username="", _password="";


  @override
  void initState() {
    initDb();
  }

  void initDb() async {
    //await DatabaseUser.;
  }
  @override
  Widget build(BuildContext context) {
    _ctx = context;
    var loginBtn = ElevatedButton(
     // onPressed: _submit,
      onPressed: (){
        final form = formKey.currentState;
        if (form!.validate()) {
          _submit();
        }
      },
      child: Text("Signup"),
    );


    var loginForm = ListView(
      shrinkWrap: true,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Sign up",
              textScaleFactor: 2.0,
            ),
            Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      onSaved: (val) => _name = val!.trim(),
                      decoration: InputDecoration(labelText: "Name"),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(30),
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]'))
                      ],
                      validator: (val) {
                        // _mobile = val;
                        if (val!.length == 0) {
                          return 'Enter Name';
                        } else
                          return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      onSaved: (val) => _username = val!,
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
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      onSaved: (val) => _password = val!,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(8),
                      ],
                      obscureText: !_passwordVisible,
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
                        ),
                      ),
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
            loginBtn
          ],
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Signup"),
      ),
      key: scaffoldKey,
      body: Container(
        child: Center(
          child: loginForm,
        ),
      ),
    );
  }

  void _showSnackBar(String text) {
    // scaffoldKey.currentState.showSnackBar(new SnackBar(
    //   content: new Text(text),
    // ));
  }

  Future<void> _submit() async {
    final form = formKey.currentState;
    var user = User(_name, _username, _password, "true");
    var db = DatabaseHelper();
    var isUser=await db.selectUser(user);
    print(isUser);
    if(isUser==null) {
      if (form!.validate()) {
        setState(() {
          _isLoading = true;
          form.save();
          var user = User(_name, _username, _password, "true");
          var db = DatabaseHelper();
          db.saveUser(user).whenComplete(() {
            _isLoading = false;
            Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return LoginPage();
                }));
          });
        });
      }
    }
    else if(isUser.username!=null){
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
          content: Text("User already exist"),
        action: SnackBarAction(
          label: 'Login',
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return LoginPage();
                }));
          },
        ),
      ));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
        content: Text("Unable to Signup"),
      ));
    }
  }
  bool isEmailValid(String s) {
    final bool emailValid =
    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(s);
    return emailValid;
  }
}