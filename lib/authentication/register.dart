import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:school_project/const_files/colors.dart';
import 'package:school_project/widgets/appbar.dart';
import 'package:school_project/widgets/my_loader.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late double scrHeight;
  late double scrWidht;
  late final TextEditingController _userMailController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passcontroller;
  late final TextEditingController _passConfirmcontroller;

  @override
  void dispose() {
    _userMailController.dispose();
    _usernameController.dispose();
    _passcontroller.dispose();
    _passConfirmcontroller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _userMailController = TextEditingController();
    _usernameController = TextEditingController();
    _passcontroller = TextEditingController();
    _passConfirmcontroller = TextEditingController();
  }

  bool isObscure = true;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    scrHeight = MediaQuery.of(context).size.height;
    scrWidht = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: MyAppBar(appBarTitle: "Kayıt Ol"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value!.isNotEmpty) {
                      return null;
                    } else {
                      return "Bu alanı boş geçmeyiniz";
                    }
                  },
                  keyboardType: TextInputType.name,
                  controller: _usernameController,
                  decoration: const InputDecoration(hintText: "Ad Soyad"),
                ),
                SizedBox(
                  height: scrHeight * 0.015,
                ),
                TextFormField(
                  validator: (value) {
                    bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value!);
                    if (emailValid) {
                      return null;
                    } else {
                      return "Geçerli bir email giriniz";
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  controller: _userMailController,
                  decoration: const InputDecoration(hintText: "Email Adresi"),
                ),
                SizedBox(
                  height: scrHeight * 0.015,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isNotEmpty) {
                      return null;
                    } else {
                      return "Bir şifre giriniz";
                    }
                  },
                  controller: _passcontroller,
                  decoration: InputDecoration(
                      hintText: "Şifre",
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          },
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: isObscure ? blueButtonColor : tealColor,
                          ))),
                  obscureText: isObscure,
                ),
                SizedBox(
                  height: scrHeight * 0.015,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isNotEmpty && value == _passcontroller.text) {
                      return null;
                    } else if (value != _passcontroller.text) {
                      return "Şifreniz uyuşmuyor";
                    }
                  },
                  controller: _passConfirmcontroller,
                  obscureText: isObscure,
                  decoration: InputDecoration(
                      hintText: "Şifre(tekrar)",
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          },
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: isObscure ? blueButtonColor : tealColor,
                          ))),
                ),
                SizedBox(
                  height: scrHeight * 0.015,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        MyLoader.showLoader(context);
                        registerRequest(
                                _userMailController.text, _passcontroller.text)
                            .whenComplete(() {
                          Navigator.pop(context);
                        });
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: scrHeight * 0.01,
                          horizontal: scrWidht * 0.2),
                      child: const Text("Kayıt ol"),
                    )),
                SizedBox(
                  height: scrHeight * 0.015,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> registerRequest(String userName, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: userName, password: password)
          .then((value) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(_userMailController.text)
            .set({
          "userType": 1,
          "userName": _usernameController.text,
          "userMail": _userMailController.text,
          "userPassword": _passcontroller.text
        }).then((value) {
          Fluttertoast.showToast(msg: "Kaydınız Başarıyla gerçekleşti");
          Navigator.pop(context);
        });
      });
    } catch (e) {
      if (e.toString().contains("[firebase_auth/invalid-email]")) {
        Fluttertoast.showToast(msg: "Geçersiz bir email adresi girdiniz");
      } else if (e
          .toString()
          .contains("[firebase_auth/email-already-in-use]")) {
        Fluttertoast.showToast(
            msg: "Bu email ile kayıt mevcut. başka bir email deneyiniz");
      }
    }
  }
}
