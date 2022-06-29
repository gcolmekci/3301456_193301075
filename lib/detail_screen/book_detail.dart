import 'package:flutter/material.dart';
import 'package:school_project/const_files/colors.dart';
import 'package:school_project/widgets/appbar.dart';

class BookDetailScreen extends StatefulWidget {
  const BookDetailScreen(
      {Key? key,
      required this.bookName,
      required this.authorName,
      required this.publicatioonDate,
      required this.paperCount,
      required this.description})
      : super(key: key);
  final String bookName;
  final String authorName;
  final String publicatioonDate;
  final String paperCount;
  final String? description;
  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(appBarTitle: widget.bookName),
      backgroundColor: primaryColor,
      body: ListView(
        children: [
          SizedBox(
            height: 15,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: whiteColor.withOpacity(0.3)),
            child: ListTile(
              leading: Text(
                widget.bookName,
                style: TextStyle(color: whiteColor),
              ),
              trailing: Text(
                widget.authorName,
                style: TextStyle(color: whiteColor),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: whiteColor.withOpacity(0.3)),
            child: ListTile(
              leading: Text(
                "Çıkış Tarihi: " + widget.publicatioonDate,
                style: TextStyle(color: whiteColor),
              ),
              trailing: Text(
                "Sayfa Sayısı: " + widget.paperCount,
                style: TextStyle(color: whiteColor),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: whiteColor.withOpacity(0.3)),
            child: Text(
              widget.description ?? "Açıklama yok",
              style: TextStyle(color: whiteColor),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
