import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:flutter/material.dart';

class MyBtn extends StatelessWidget {
  final String txt;
  final int index;
  final bool isSelected;
  final double width;
  final double selectedWidth;
  final Function(String, int) onPressed;
  final String icon;
  const MyBtn(
      {Key key,
      this.onPressed,
      this.txt,
      this.index,
      this.selectedWidth,
      this.icon,
      this.isSelected = false,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Colors.white;
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      width: isSelected ? selectedWidth : width,
      color: isSelected ? AppColors.mainColorSelected : AppColors.mainColor,
      child: FlatButton(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              getSvgIcon(icon, color: color, size: width * 0.23),
              SizedBox(width: selectedWidth * 0.1),
              !isSelected
                  ? SizedBox()
                  : Text(
                      txt,
                      style: AppThemes.navTextStyle,
                    ),
            ],
          ),
        ),
        onPressed: () => onPressed(icon, index),
      ),
    );
  }
}
