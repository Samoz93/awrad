import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:awrad/Views/Library/BookScreen.dart';
import 'package:awrad/Views/Library/LibraryListVM.dart';
import 'package:awrad/widgets/LoadingWidget.dart';
import 'package:awrad/widgets/MyScf.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class MyLibrary extends StatelessWidget {
  const MyLibrary({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: "مكتبة التصوف",
      child: ViewModelBuilder<LibraryListVM>.reactive(
        viewModelBuilder: () => LibraryListVM(),
        builder: (ctx, model, ch) => Container(
          child: model.isBusy
              ? LoadingWidget()
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: model.data.length,
                  itemBuilder: (context, index) {
                    final item = model.data[index];
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
                                item.bookName,
                                style: TextStyle(
                                    fontSize: 25, color: AppColors.mainColor),
                              ),
                              SizedBox(height: 5),
                              Flexible(
                                fit: FlexFit.tight,
                                child: ExtendedImage.network(
                                  item.bookCover,
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
        ),
      ),
    );
  }
}
