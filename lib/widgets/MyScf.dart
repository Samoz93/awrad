import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:flutter/material.dart';

class MyScaffold extends StatelessWidget {
  final Widget child;
  final String title;
  const MyScaffold({Key key, this.child, this.title = ""}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          title,
          style: AppThemes.pageTitleStyle,
        ),
        leading: Center(
          child: IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: AppColors.deleteColor,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      body: child,
    );
  }
}
