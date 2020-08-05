import 'package:awrad/Consts/DATABASECONST.dart';
import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:awrad/Views/MainPage.dart';

import 'package:awrad/models/ReminderModel.dart';
import 'package:awrad/services/NotificationService.dart';
import 'package:awrad/testScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';

import 'base/locator.dart';

Box mainBox;
Box notificationBox;
Box<ReminderModel> reminderBox;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ar');
  setupLocator();
  await setupNotification();
  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter<ReminderModel>(ReminderModelAdapter());

  mainBox = await Hive.openBox(
    MAINBOX,
    compactionStrategy: (entries, deletedEntries) {
      if (deletedEntries > 20) return true;
      return false;
    },
  );

  notificationBox = await Hive.openBox(
    NOTIFICATIONBOX,
    compactionStrategy: (entries, deletedEntries) {
      if (deletedEntries > 20) return true;
      return false;
    },
  );
  reminderBox = await Hive.openBox<ReminderModel>(
    REMINDER_BOX,
    compactionStrategy: (entries, deletedEntries) {
      if (deletedEntries > 20) return true;
      return false;
    },
  );
  _setupSchedule();
  runApp(MyApp());
}

_setupSchedule() {
  // initWorkManager();
  Get.find<NotificationService>().scheduleAzanTimes();
}

class MyApp extends StatelessWidget {
  // final _exNavigatorKey = GlobalKey<ExtendedNavigatorState>();
  final _nab = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'أوراد وأذكار',
      navigatorKey: _nab,
      theme: ThemeData(
        primaryColor: AppColors.mainColorSelected,
        accentColor: AppColors.mainColor,
        fontFamily: "gg",
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: MainPage(),
      ),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//   final String title;
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   bool _hasPermissions = false;
//   double _lastRead = 0;
//   DateTime _lastReadAt;

//   @override
//   void initState() {
//     super.initState();
//   }

//   int index = 0;
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         bottomNavigationBar: BottomAppBar(
//           child: BottomAppBar(
//             shape: CircularNotchedRectangle(),
//             notchMargin: 4.0,
//             child: new Row(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 IconButton(
//                   icon: Icon(Icons.menu),
//                   onPressed: () {},
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.search),
//                   onPressed: () {},
//                 ),
//               ],
//             ),
//           ),
//         ),
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           title: const Text('Flutter Compass'),
//         ),
//         body: Builder(builder: (context) {
//           if (_hasPermissions) {
//             return Column(
//               children: <Widget>[
//                 _buildManualReader(),
//                 Expanded(child: _buildCompass()),
//               ],
//             );
//           } else {
//             return _buildPermissionSheet();
//           }
//         }),
//       ),
//     );
//   }

//   Widget _buildManualReader() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Row(
//         children: <Widget>[
//           RaisedButton(
//             child: Text('Read Value'),
//             onPressed: () async {
//               final double tmp = await FlutterCompass.events.first;
//               setState(() {
//                 _lastRead = tmp;
//                 _lastReadAt = DateTime.now();
//               });
//             },
//           ),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: <Widget>[
//                 Text(
//                   '$_lastRead',
//                   style: Theme.of(context).textTheme.caption,
//                 ),
//                 Text(
//                   '$_lastReadAt',
//                   style: Theme.of(context).textTheme.caption,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCompass() {
//     return StreamBuilder<double>(
//       stream: FlutterCompass.events,
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Text('Error reading heading: ${snapshot.error}');
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }

//         double direction = snapshot.data;

//         // if direction is null, then device does not support this sensor
//         // show error message
//         if (direction == null)
//           return Center(
//             child: Text("Device does not have sensors !"),
//           );

//         return Container(
//           alignment: Alignment.center,
//           child: Transform.rotate(
//             angle: ((direction ?? 0) * (math.pi / 180) * -1),
//             child: Icon(
//               Icons.compare_arrows,
//               size: 100,
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildPermissionSheet() {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Text('Location Permission Required'),
//           RaisedButton(
//             child: Text('Request Permissions'),
//             onPressed: () async {
//               final x = await Permission.locationWhenInUse.request();
//               setState(() {
//                 _hasPermissions = x == PermissionStatus.granted;
//               });
//             },
//           ),
//           SizedBox(height: 16),
//           RaisedButton(
//             child: Text('Open App Settings'),
//             onPressed: () {},
//           )
//         ],
//       ),
//     );
//   }
// }
