import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:awrad/models/AwradModel.dart';
import 'package:awrad/widgets/ShareWidget.dart/ShareVM.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ShareWidget extends StatelessWidget {
  final String link;
  final String name;
  final String html;
  final String uid;
  final bool isPdf;
  const ShareWidget({
    Key key,
    this.isPdf = false,
    this.html,
    this.link,
    this.name,
    this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ShareVm>.reactive(
      viewModelBuilder: () => ShareVm(
        isPdf: isPdf,
        html: html,
        link: link,
        name: name,
        uid: uid,
      ),
      builder: (ctx, model, ch) => InkWell(
        onTap: () async {
          model.shareWrd();
        },
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: model.isBusy
              ? StreamBuilder<double>(
                  stream: model.pr,
                  builder: (context, snapshot) => CircularProgressIndicator(
                    value: snapshot.data,
                  ),
                )
              : Icon(
                  Icons.share,
                  size: 30,
                  color: AppColors.addColor,
                ),
        ),
      ),
    );
  }
}
