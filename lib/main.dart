import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_lists_generator/providers/item_lists.dart';
import 'package:random_lists_generator/providers/items.dart';
import 'package:random_lists_generator/providers/theme_changer.dart';
import 'package:random_lists_generator/providers/types.dart';
import 'package:random_lists_generator/screens/items_screen.dart';
import 'package:random_lists_generator/screens/settings_screen.dart';
import 'package:random_lists_generator/screens/start_screen.dart';
import 'package:random_lists_generator/screens/types_screen.dart';

void main() {
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
