import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:school_project/const_files/colors.dart';
import 'package:school_project/home/home_screen.dart';
import 'package:school_project/home/user_screen.dart';
import 'package:school_project/models/user.dart';
import 'package:school_project/widgets/appbar.dart';
import 'package:school_project/widgets/my_loader.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late double scrHeight;
  late double scrWidht;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    scrHeight = MediaQuery.of(context).size.height;
    scrWidht = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: MyAppBar(appBarTitle: "Giriş Yap"),
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
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
                  controller: _usernameController,
                  decoration: const InputDecoration(hintText: "Email Adresi"),
                ),
                SizedBox(
                  height: scrHeight * 0.015,
                ),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value!.isNotEmpty) {
                      return null;
                    } else {
                      return "Bir şifre giriniz";
                    }
                  },
                  controller: _passcontroller,
                  decoration: const InputDecoration(hintText: "Şifre"),
                ),
                SizedBox(
                  height: scrHeight * 0.015,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        MyLoader.showLoader(context);
                        loginRequest(
                                _usernameController.text, _passcontroller.text)
                            .then((value) {
                          Navigator.pop(context);
                          if (value == 3) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AdminScreen()),
                              (route) => false,
                            );
                          } else if (value == 1) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const UserScreen()),
                              (route) => false,
                            );
                          }
                        });
                      }
                    },
                    child: const Text("Giriş Yap")),
                SizedBox(
                  height: scrHeight * 0.02,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<int> loginRequest(String userName, String password) async {
    try {
      return await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: userName, password: password)
          .then((value) async => FirebaseFirestore.instance
                  .collection("users")
                  .doc(userName)
                  .get()
                  .then((value) {
                print(value.data());
                if (value.data() != null) {
                  MyUserModel.userMail = value.data()!['userMail'];
                  MyUserModel.userName = value.data()!['userName'];
                  return value.data()!['userType'];
                } else {
                  return -1;
                }
              }));
    } catch (e) {
      print("login throw exeption");
      print(e);
      if (e.toString().contains("[firebase_auth/wrong-password]")) {
        Fluttertoast.showToast(msg: "Şifreniz Yanlış");
      }
      if (e.toString().contains("[firebase_auth/user-not-found]")) {
        Fluttertoast.showToast(msg: "Kaydınız bulunamadı");
      }
      return -1;
    }
  }
}
