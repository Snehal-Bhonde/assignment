import 'package:assignment/FriendList.dart';
import 'package:assignment/database/DatabaseHelper.dart';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddFriend extends StatefulWidget {
  FriendForm? registerForm;
  AddFriend({Key? key, this.registerForm}) : super(key: key);
  @override
  _AddFriendState createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {

    final formGlobalKey = GlobalKey <FormState>();
    final firstNameController = TextEditingController();
    final mobNoController = TextEditingController();
    final lastNameController = TextEditingController();
    final emailController = TextEditingController();
    List<FriendForm> myRegForms = [];


    void initState() {
      initDb();
      //addRegData();
      super.initState();
    }
    void initDb() async {
      await DatabaseRepository.instance.database;
    }

    void addRegData() {
      if (widget.registerForm != null) {
        if (mounted) {
          setState(() {
            firstNameController.text = widget.registerForm!.Name!;
            mobNoController.text = widget.registerForm!.mobNo!.toString();
            emailController.text = widget.registerForm!.email!;
          });
        }
      }
    }


    @override
    void dispose() {
      firstNameController.dispose();
      lastNameController.dispose();
      mobNoController.dispose();
      emailController.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return SafeArea(
          child: Scaffold(
              appBar: AppBar(
                title: Text('Registration'),
              ),
              body:
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: formGlobalKey,
                  child: ListView(

                    children: [
                      const SizedBox(height: 50),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'First Name'),
                        keyboardType: TextInputType.name,
                        controller: firstNameController,
                        //maxLength: 30,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(30),
                          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'))
                        ],
                        //validator: validateMobile,
                        validator: (val) {
                          // _mobile = val;
                          if (val!.length == 0) {
                            return 'Enter First Name';
                          } else
                            return null;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Last Name'),
                        keyboardType: TextInputType.name,
                        controller: lastNameController,
                        //validator: validateMobile,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(30),
                          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'))

                        ],

                        validator: (val) {
                          // _mobile = val;
                          if (val!.length == 0) {
                            return 'Enter Last Name';
                          } else
                            return null;
                        },
                      ),

                      TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Mobile'),
                          keyboardType: TextInputType.phone,
                          controller: mobNoController,
                          //validator: validateMobile,
                          validator: (val) {
                            // _mobile = val;
                            if (val!.length != 10) {
                              return 'Mobile Number must be of 10 digit';
                            } else
                              return null;
                          },
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                          ]
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "Email"
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(40),
                        ],
                        controller: emailController,
                        validator: (email) {
                          if (isEmailValid(email!))
                            return null;
                          else
                            return 'Enter a valid email address';
                        },
                      ),
                      const SizedBox(height: 24),

                      const SizedBox(height: 50),
                      ElevatedButton(
                          onPressed: () {
                            if (formGlobalKey.currentState!.validate()) {
                              addRecord();
                              formGlobalKey.currentState!.save();

                              formGlobalKey.currentState!.reset();
                            }
                          },
                          child: widget.registerForm == null
                              ? Text("Submit")
                              : Text("Edit")),
                      Visibility(
                          visible: widget.registerForm == null ? true : false,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return FriendList();
                                    }));
                              },
                              child: Text("Show all Records")))
                    ],
                  ),
                ),
              )));
    }

    void addRecord() async {
      var now = new DateTime.now();

      if (widget.registerForm != null) {

      }

      FriendForm regForm = FriendForm(
        Name: firstNameController.text,
        mobNo: int.parse(mobNoController.text),
        email: emailController.text,
      );
      if (widget.registerForm == null) {
        await DatabaseRepository.instance.insert(registerForm: regForm).then((
            value) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Record Saved')));
          print("saved");
        }).catchError((e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.toString())));
        });
      }
      else {
        print("update started");
        FriendForm regForm = FriendForm(
          userId: widget.registerForm!.userId,
          Name: firstNameController.text,
          mobNo: int.parse(mobNoController.text),
          email: emailController.text,
        );
        await DatabaseRepository.instance.update(regForm).then((value) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Updated')));
          // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => RecordsPage()),(route) => true,);
          Navigator.pop(context);
          Navigator.of(context).popAndPushNamed("/second");
        }).catchError((e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.toString())));
        });
      }
    }
  }

bool isEmailValid(String s) {
  final bool emailValid =
  RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(s);
  return emailValid;
}

  mixin InputValidationMixin {
  bool isPasswordValid(String password) => password.length == 6;

  bool isEmailValid(String email) {
    // Pattern patterns =
    //      '^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    // RegExp regex = RegExp(patterns);
    //return regex.hasMatch(email);

    final bool emailValid =
    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    return emailValid;
  }

}

