import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:school_project/authentication/welcome.dart';
import 'package:school_project/const_files/colors.dart';
import 'package:school_project/detail_screen/book_detail.dart';
import 'package:school_project/detail_screen/local_list.dart';
import 'package:school_project/models/user.dart';
import 'package:school_project/services/database_helper.dart';
import 'package:school_project/widgets/my_loader.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  Stream<QuerySnapshot> getDataFromFireStore() {
    return FirebaseFirestore.instance.collection("books").snapshots();
  }

  final DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    double scrHeight = MediaQuery.of(context).size.height;
    double scrWidht = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kütüpnahe Kitapları"),
        centerTitle: true,
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
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hoşgeldin",
                  style: TextStyle(color: primaryColor, fontSize: 22),
                ),
                Text(
                  MyUserModel.userName ?? "",
                  style: TextStyle(color: blueButtonColor, fontSize: 18),
                ),
                SizedBox(
                  height: scrHeight * 0.1,
                ),
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: tealColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const LocaleListScreen()));
                        },
                        title: Row(
                          children: const [
                            Icon(
                              Icons.favorite,
                              color: Colors.pink,
                            ),
                            Text(
                              "Favori Kitaplarım",
                              style: TextStyle(color: tealColor, fontSize: 16),
                            )
                          ],
                        ))),
              ],
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: getDataFromFireStore(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: tealColor),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BookDetailScreen(
                                          bookName: snapshot.data!.docs[index]
                                              ['bookName'],
                                          authorName: snapshot.data!.docs[index]
                                              ['authorName'],
                                          publicatioonDate: snapshot.data!
                                              .docs[index]['publicationDate'],
                                          paperCount: snapshot.data!.docs[index]
                                              ['paperCount'],
                                          description: snapshot
                                              .data!.docs[index]['description'],
                                        )));
                          },
                          onLongPress: () {
                            showSureDialog(
                                snapshot.data!.docs[index]['bookName'],
                                snapshot.data!.docs[index]['authorName'],
                                snapshot.data!.docs[index]['publicationDate'],
                                snapshot.data!.docs[index]['paperCount']);
                          },
                          title: Text(snapshot.data!.docs[index]['bookName']),
                          subtitle:
                              Text(snapshot.data!.docs[index]['authorName']),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RichText(
                                  text:
                                      TextSpan(text: "Yayın Yılı: ", children: [
                                TextSpan(
                                    text: snapshot.data!.docs[index]
                                        ['publicationDate'],
                                    style: TextStyle(color: blackPaleColor))
                              ])),
                              SizedBox(
                                height: 5,
                              ),
                              RichText(
                                  text: TextSpan(
                                      text: "Sayfa Sayısı: ",
                                      children: [
                                    TextSpan(
                                        text: snapshot.data!.docs[index]
                                            ['paperCount'],
                                        style:
                                            TextStyle(color: blueButtonColor))
                                  ]))
                            ],
                          ),
                        ),
                      ));
            }
          }),
    );
  }

  showSureDialog(String bookName, String authorName, String publicatioonDate,
      String paperCount) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "$bookName Kitabını favorinize eklemek istediğinize Emin misiniz?",
                textAlign: TextAlign.center,
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          MyLoader.showLoader(context);
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(MyUserModel.userMail)
                              .collection("favorites")
                              .doc(bookName)
                              .set({
                            "authorName": authorName,
                            "bookName": bookName,
                            "publicationDate": publicatioonDate,
                            "paperCount": paperCount
                          }).then((value) {
                            saveWithSqflite(bookName, authorName,
                                    publicatioonDate, paperCount)
                                .then((value) {
                              Navigator.pop(context);
                              Fluttertoast.showToast(msg: "Favoriye Eklendi");
                              Navigator.pop(context);
                            });
                          });
                        },
                        child: const Text("Evet")),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Hayır")),
                  ],
                )
              ],
            ));
  }

  Future saveWithSqflite(String bookName, String authorName,
      String publicationDate, String paperCount) async {
    try {
      databaseHelper.insertCurrentBookData({
        "bookName": bookName,
        "authorName": authorName,
        "publicationDate": publicationDate,
        "paperCount": paperCount
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
