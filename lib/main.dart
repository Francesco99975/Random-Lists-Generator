import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:random_lists_generator/db/database_provider.dart';
import 'package:random_lists_generator/providers/item.dart';
import 'package:random_lists_generator/providers/item_list.dart';
import 'package:random_lists_generator/providers/item_lists.dart';
import 'package:random_lists_generator/providers/items.dart';
import 'package:random_lists_generator/providers/theme_changer.dart';
import 'package:random_lists_generator/providers/types.dart';
import 'package:random_lists_generator/screens/items_screen.dart';
import 'package:random_lists_generator/screens/settings_screen.dart';
import 'package:random_lists_generator/screens/start_screen.dart';
import 'package:random_lists_generator/screens/types_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final workManager = Workmanager();

void callbackDispatcher() {
  workManager.executeTask((taskName, inputData) async {
    // Notifications
    late FlutterLocalNotificationsPlugin _localNotification;

    tz.initializeTimeZones();
    var androidInitialize = AndroidInitializationSettings('ic_launcher');
    var iOSInitialize = IOSInitializationSettings();
    var initializeSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    _localNotification = FlutterLocalNotificationsPlugin();
    _localNotification.initialize(initializeSettings);
    tz.setLocalLocation(
        tz.getLocation(await FlutterNativeTimezone.getLocalTimezone()));

    final itemLists = await DatabaseProvider.db.getItemLists();
    final types = await DatabaseProvider.db.getTypes();
    final items = await DatabaseProvider.db.getItems();

    List<Item> list = [];

    switch (taskName) {
      case "shift":
        final prefs = await SharedPreferences.getInstance();
        final lastUpdated = DateTime.fromMillisecondsSinceEpoch(
            prefs.getInt("lastUpdate") as int);
        bool runnable = !prefs.containsKey("lastUpdate")
            ? false
            : lastUpdated.add(Duration(days: 7)).isBefore(DateTime.now());

        if (runnable) {
          itemLists[0].items!.forEach((item) => item.use());
          types.forEach((type) {
            final cluster = items
                .where((item) => item.type!.id == type.id && item.isReady())
                .toList();
            if (cluster.length <= type.instances!) {
              cluster.forEach((item) {
                item.use();
                list.add(item);
              });
            } else {
              final tmp = cluster..shuffle();
              final subCluster = tmp.sublist(0, type.instances);
              // final excessCluster =
              //     cluster.where((item) => !subCluster.contains(item));
              // excessCluster.forEach((item) => item.elapsed());
              subCluster.forEach((item) {
                item.use();
                list.add(item);
              });
            }
          });

          print("List ${list.map((e) => e.name).toList()}");

          await DatabaseProvider.db.deleteItemList(itemLists[0].id!);
          await DatabaseProvider.db.insertItemList(new ItemList(items: list));

          await prefs.setInt(
              "lastUpdate", DateTime.now().millisecondsSinceEpoch);

          await _localNotification.show(
              1,
              "New Lists Generated",
              "Check out the newly genereated list!",
              const NotificationDetails(
                  android: AndroidNotificationDetails(
                      "info-1", "info", "channel for info notifications"),
                  iOS: IOSNotificationDetails()));
        } else {
          print("Runned Else");
        }

        break;
      default:
        print("Runned Default!");
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await workManager.initialize(callbackDispatcher);

  await workManager.registerPeriodicTask("9", "shift",
      frequency: Duration(days: 7));

  runApp(RandomListsGenerator());
}

class RandomListsGenerator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => ThemeChanger(ThemeChanger.dark)),
          ChangeNotifierProvider(create: (_) => Types()),
          ChangeNotifierProvider(create: (_) => Items()),
          ChangeNotifierProvider(create: (_) => ItemLists()),
        ],
        builder: (context, _) {
          final themeChanger = Provider.of<ThemeChanger>(context);
          return MaterialApp(
            theme: themeChanger.theme,
            home: StartScreen(),
            routes: {
              TypesScreen.ROUTE_NAME: (_) => TypesScreen(),
              ItemsScreen.ROUTE_NAME: (_) => ItemsScreen(),
              SettingsScreen.ROUTE_NAME: (_) => SettingsScreen()
            },
          );
        });
  }
}
