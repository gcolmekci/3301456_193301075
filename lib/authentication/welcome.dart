import 'package:flutter/material.dart';
import 'package:school_project/authentication/login.dart';
import 'package:school_project/authentication/register.dart';
import 'package:school_project/const_files/colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double scrHeight = MediaQuery.of(context).size.height;
    double scrWidht = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Hoş Geldiniz"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
              child: Container(
                width: scrWidht * 0.5,
                height: scrHeight * 0.1,
                alignment: Alignment.center,
                child: Text(
                  "Giriş Yap",
                  style: TextStyle(
                      color: whiteColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: blueButtonColor),
              ),
            ),
            SizedBox(height: scrHeight * 0.05),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterScreen()));
              },
              child: Container(
                width: scrWidht * 0.5,
                height: scrHeight * 0.1,
                alignment: Alignment.center,
                child: Text(
                  "Kayıt Ol",
                  style: TextStyle(
                      color: whiteColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: blueButtonColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}
