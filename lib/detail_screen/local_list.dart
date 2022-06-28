import 'package:flutter/material.dart';
import 'package:school_project/const_files/colors.dart';
import 'package:school_project/services/database_helper.dart';
import 'package:school_project/widgets/appbar.dart';

class LocaleListScreen extends StatefulWidget {
  const LocaleListScreen({Key? key}) : super(key: key);

  @override
  State<LocaleListScreen> createState() => _LocaleListScreenState();
}

class _LocaleListScreenState extends State<LocaleListScreen> {
  final DatabaseHelper databaseHelper = DatabaseHelper();

  List<Map<String, Object?>>? myBookList = [];

  final key = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(appBarTitle: "Favorilerim"),
      body: FutureBuilder<List<Map<String, Object?>>?>(
          future: getLocalData(),
          builder: (context, snapshot) => !snapshot.hasData
              ? const Center(child: CircularProgressIndicator())
              : AnimatedList(
                  key: key,
                  initialItemCount: snapshot.data!.length,
                  itemBuilder: (context, index, animation) =>
                      buildItem(index, snapshot.data![index], animation))),
    );
  }

  Widget buildItem(int index, Map? snapshot, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: tealColor),
        child: ListTile(
          leading: IconButton(
              onPressed: () =>
                  removeItem(index, snapshot!['bookName'].toString()),
              icon: const Icon(
                Icons.delete,
                color: blueButtonColor,
              )),
          title: Text(snapshot!['bookName'].toString()),
          subtitle: Text(snapshot['authorName'].toString()),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                  text: TextSpan(text: "Yayın Yılı: ", children: [
                TextSpan(
                    text: snapshot['publicationDate'].toString(),
                    style: const TextStyle(color: blackPaleColor))
              ])),
              const SizedBox(
                height: 5,
              ),
              RichText(
                  text: TextSpan(text: "Sayfa Sayısı: ", children: [
                TextSpan(
                    text: snapshot['paperCount'].toString(),
                    style: const TextStyle(color: blueButtonColor))
              ]))
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Map<String, Object?>>?> getLocalData() async {
    myBookList = await databaseHelper.getBookData();
    myBookList = myBookList!.toList();
    return myBookList;
  }

  removeItem(int index, String bookName) async {
    await databaseHelper.deleteItem(bookName);
    var item = myBookList!.removeAt(index);
    print(item);
    key.currentState!.removeItem(
        index, (context, animation) => buildItem(index, item, animation));
  }
}
