import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_lists_generator/providers/item_lists.dart';
import 'package:random_lists_generator/providers/theme_changer.dart';
import 'package:random_lists_generator/providers/types.dart';
import 'package:random_lists_generator/widgets/main_drawer.dart';

class SettingsScreen extends StatelessWidget {
  static const ROUTE_NAME = "/settings";
  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context, listen: false);
    final occupied =
        Provider.of<Types>(context, listen: false).occupiedInstances();
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Settings",
            style: Theme.of(context).textTheme.headline1,
          ),
          iconTheme: IconThemeData(color: Theme.of(context).accentColor)),
      drawer: MainDrawer(),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: [
            ListTile(
              title: Text("Dark Mode",
                  style: Theme.of(context).textTheme.bodyText1),
              trailing: Switch.adaptive(
                  value: themeChanger.isDark,
                  onChanged: (_) => themeChanger.toggle()),
            ),
            SizedBox(height: 10),
            Consumer<ItemLists>(
                builder: (_, itemLists, __) => Column(
                      children: [
                        Center(
                          child: Container(
                            margin: EdgeInsets.all(8.0),
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              "Lists lenght: ${itemLists.listSize}",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ),
                        Slider(
                            value: itemLists.listSize.toDouble(),
                            min: occupied < 2 ? 2 : occupied.toDouble(),
                            max: 100,
                            label: itemLists.listSize.round().toString(),
                            divisions: 100,
                            activeColor: Theme.of(context).accentColor,
                            onChanged: (double value) {
                              itemLists.setListSize(value.toInt());
                            }),
                      ],
                    ))
          ],
        ),
      ),
    );
  }
}
