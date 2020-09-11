import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:flutter/material.dart';

class BkScaffold extends StatelessWidget {
  final Widget child;
  const BkScaffold({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/bk.png',
          ),
          colorFilter: ColorFilter.mode(
              AppColors.mainColorSelected, BlendMode.colorDodge),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
