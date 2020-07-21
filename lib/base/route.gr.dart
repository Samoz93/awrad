// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../Views/MainPage.dart';
import '../Views/awrad/AwradListScreen.dart';
import '../Views/awrad/AwradTypesScreen.dart';
import '../models/AwradTypesModel.dart';

class Routes {
  static const String mainPage = '/';
  static const String awradTypesScreen = '/awrad-types-screen';
  static const all = <String>{
    mainPage,
    awradTypesScreen,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.mainPage, page: MainPage),
    RouteDef(
      Routes.awradTypesScreen,
      page: AwradTypesScreen,
      generator: AwradTypesScreenRouter(),
    ),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    MainPage: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const MainPage(),
        settings: data,
      );
    },
    AwradTypesScreen: (data) {
      var args = data.getArgs<AwradTypesScreenArguments>(
        orElse: () => AwradTypesScreenArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => AwradTypesScreen(key: args.key),
        settings: data,
      );
    },
  };
}

class AwradTypesScreenRoutes {
  static const String awradTypesScreen = '/';
  static const String awradListScreen = '/list';
  static const all = <String>{
    awradTypesScreen,
    awradListScreen,
  };
}

class AwradTypesScreenRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(AwradTypesScreenRoutes.awradTypesScreen, page: AwradTypesScreen),
    RouteDef(AwradTypesScreenRoutes.awradListScreen, page: AwradListScreen),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    AwradTypesScreen: (data) {
      var args = data.getArgs<AwradTypesScreenArguments>(
        orElse: () => AwradTypesScreenArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => AwradTypesScreen(key: args.key),
        settings: data,
      );
    },
    AwradListScreen: (data) {
      var args = data.getArgs<AwradListScreenArguments>(
        orElse: () => AwradListScreenArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => AwradListScreen(
          key: args.key,
          type: args.type,
        ),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// AwradTypesScreen arguments holder class
class AwradTypesScreenArguments {
  final Key key;
  AwradTypesScreenArguments({this.key});
}

/// AwradListScreen arguments holder class
class AwradListScreenArguments {
  final Key key;
  final AwradTypesModel type;
  AwradListScreenArguments({this.key, this.type});
}
