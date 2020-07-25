import 'package:flutter/material.dart';

class MyErrorWidget extends StatelessWidget {
  final dynamic err;
  const MyErrorWidget({Key key, this.err}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(err.toString()),
    );
  }
}
