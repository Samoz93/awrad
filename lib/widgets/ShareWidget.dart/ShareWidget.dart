import 'dart:io';

import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:awrad/models/SettingsModel.dart';
import 'package:awrad/widgets/ShareWidget.dart/ShareVM.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class ShareWidget extends StatelessWidget {
  final String link;
  final String name;
  final String html;
  final String uid;
  final bool isPdf;
  final String soundLink;
  const ShareWidget(
      {Key key,
      this.isPdf = false,
      this.html,
      this.link,
      this.name,
      this.uid,
      @required this.soundLink})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final setting = Provider.of<SettingMode>(context);
    return !setting.openShare
        ? SizedBox()
        : ViewModelBuilder<ShareVm>.reactive(
            viewModelBuilder: () => ShareVm(
                isPdf: isPdf,
                html: html,
                link: link,
                name: name,
                uid: uid,
                soundLink: soundLink),
            builder: (ctx, model, ch) => InkWell(
              onTap: () async {
                model.shareWrd();
              },
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: model.isBusy
                    ? StreamBuilder<double>(
                        stream: model.pr,
                        builder: (context, snapshot) =>
                            CircularProgressIndicator(
                          value: snapshot.data,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Platform.isIOS
                              ? CupertinoIcons.share
                              : FontAwesomeIcons.shareSquare,
                          size: 30,
                          color: AppColors.addColor,
                        ),
                      ),
              ),
            ),
          );
  }
}
