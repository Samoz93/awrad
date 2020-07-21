import 'package:auto_route/auto_route_annotations.dart';
import 'package:awrad/Views/MainPage.dart';
import 'package:awrad/Views/awrad/AwradListScreen.dart';
import 'package:awrad/Views/awrad/AwradTypesScreen.dart';
import 'package:flutter/material.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    // initial route is named "/"
    MaterialRoute(page: MainPage, initial: true),
    MaterialRoute(page: AwradTypesScreen, children: [
      MaterialRoute(path: "/", page: AwradTypesScreen),
      MaterialRoute(path: "/list", page: AwradListScreen),
    ]),
  ],
)
class $Router {}
