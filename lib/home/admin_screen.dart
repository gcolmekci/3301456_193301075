import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:school_project/authentication/welcome.dart';
import 'package:school_project/const_files/colors.dart';
import 'package:school_project/const_files/strings.dart';
import 'package:school_project/services/database_helper.dart';
import 'package:school_project/widgets/my_loader.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final DatabaseHelper databaseHelper = DatabaseHelper();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _authorNameController = TextEditingController();
  TextEditingController _publicationDateController = TextEditingController();
  TextEditingController _paperCountController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double scrHeight = MediaQuery.of(context).size.height;
    double scrWidht = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                getImagePath("bg.jpg"),
              ),
              fit: BoxFit.fill)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text("Ana Sayfa"),
            actions: [
              IconButton(
                  onPressed: () async {
                    MyLoader.showLoader(context);
                    await FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                    await Future.delayed(Duration.zero);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WelcomeScreen()),
                        (route) => false);
                  },
                  icon: Icon(Icons.logout))
            ],
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: scrWidht * 0.03,
            ),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  SizedBox(
                    height: scrHeight * 0.01,
                  ),
                  const Text(
                    "Kitabın Adı",
                    style: TextStyle(
                        color: whiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: _nameController,
                    validator: validator,
                  ),

                  SizedBox(
                    height: scrHeight * 0.03,
                  ),
                  const Text(
                    "Yazarın Adı",
                    style: TextStyle(
                        color: whiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: _authorNameController,
                    validator: validator,
                  ),
                  SizedBox(
                    height: scrHeight * 0.03,
                  ),
                  Row(
                    children: const [
                      Expanded(
                        child: Text(
                          "Çıkış Tarihi",
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Sayfa Sayısı",
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                        controller: _publicationDateController,
                        validator: validator,
                      )),
                      SizedBox(
                        width: scrWidht * 0.01,
                      ),
                      Expanded(
                          child: TextFormField(
                        controller: _paperCountController,
                        validator: validator,
                      ))
                    ],
                  ),
                  SizedBox(
                    height: scrHeight * 0.03,
                  ),
                  const Text(
                    "Kitabın Açıklaması",
                    style: TextStyle(
                        color: whiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    minLines: 2,
                    maxLines: 3,
                    validator: validator,
                  ),
                  SizedBox(
                    height: scrHeight * 0.03,
                  ),
                  MaterialButton(
                    color: tealColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        MyLoader.showLoader(context);
                        saveWithFireStore().then((value) {
                          if (value) {
                            Fluttertoast.showToast(
                                msg: "Kayıt işlemi başarılı");
                            _authorNameController.clear();
                            _descriptionController.clear();
                            _nameController.clear();
                            _paperCountController.clear();
                            _publicationDateController.clear();
                          } else {
                            Fluttertoast.showToast(
                                msg: "Beklenmedik bir hata oluştu");
                          }
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: scrHeight * 0.02),
                      child: const Text(
                        "Kitap Bilgilerini Kaydet",
                        style: TextStyle(color: whiteColor),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: scrHeight * 0.03,
                  ),
                                 ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future getData() async {
    var response =
        await FirebaseFirestore.instance.collection("books").snapshots();
    response.forEach((element) {
      print(element.docs.length);
      element.docs.forEach((element) {
        print(element.data());
      });
    });
  }

  String? validator(String? val) {
    if (val!.isNotEmpty) {
      return null;
    } else {
      return "Bu alan boş geçilemez";
    }
  }

  Future saveWithFireStore() async {
    try {
      await FirebaseFirestore.instance
          .collection("books")
          .doc(_nameController.text)
          .set({
        "authorName": _authorNameController.text,
        "bookName": _nameController.text,
        "publicationDate": _publicationDateController.text,
        "paperCount": _paperCountController.text,
        "description": _descriptionController.text
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future saveWithSqflite() async {
    try {
      databaseHelper.insertCurrentBookData({
        "bookName": _nameController.text,
        "authorName": _authorNameController.text,
        "publicationDate": _publicationDateController.text,
        "paperCount": _paperCountController.text
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
