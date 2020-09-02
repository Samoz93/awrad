import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:flutter/material.dart';

class MyScaffold extends StatelessWidget {
  final Widget child;
  final String title;
  final Widget extraWidget;
  const MyScaffold({Key key, this.child, this.title = "", this.extraWidget})
      : super(key: key);

  Widget _getTitle() {
    return Text(
      title,
      style: AppThemes.pageTitleStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: this.extraWidget == null
            ? _getTitle()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[_getTitle(), extraWidget],
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
