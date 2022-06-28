import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:school_project/const_files/colors.dart';
import 'package:school_project/widgets/appbar.dart';

class InternetValuesScreen extends StatefulWidget {
  const InternetValuesScreen({Key? key}) : super(key: key);

  @override
  State<InternetValuesScreen> createState() => _InternetValuesScreenState();
}

class _InternetValuesScreenState extends State<InternetValuesScreen> {
  Stream<QuerySnapshot> getDataFromFireStore() {
    return FirebaseFirestore.instance.collection("books").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(appBarTitle: "internet verileri"),
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
}
