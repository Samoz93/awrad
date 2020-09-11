import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:awrad/models/FolderModel.dart';
import 'package:awrad/widgets/MyScf.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import 'BookScreen.dart';

class MyFolder extends StatelessWidget {
  final List<FBookModel> books;
  final String folderName;
  const MyFolder({Key key, @required this.books, @required this.folderName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: folderName,
      child: books.isEmpty
          ? Center(
              child: Text("المجلد المطلوب فارغ"),
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
              ),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final item = books[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BookScreen(
                        book: item,
                      ),
                    ));
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            item.name,
                            style: TextStyle(
                                fontSize: 25, color: AppColors.mainColor),
                          ),

                          SizedBox(height: 5),
                          Flexible(
                            fit: FlexFit.tight,
                            child: ExtendedImage.network(
                              item.imageLink,
                              fit: BoxFit.cover,
                            ),
                          ),

                          // Text(
                          //   item.bookAuthor,
                          //   style: TextStyle(
                          //       fontSize: 15, color: AppColors.addColor),
                          // ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
