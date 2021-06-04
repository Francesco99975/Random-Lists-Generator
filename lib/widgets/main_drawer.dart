import 'package:flutter/material.dart';
import 'package:random_lists_generator/screens/items_screen.dart';
import 'package:random_lists_generator/screens/settings_screen.dart';
import 'package:random_lists_generator/screens/types_screen.dart';

class MainDrawer extends StatelessWidget {
  Widget _buildRoute(
      BuildContext context, String title, IconData icon, String route) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).accentColor,
      ),
      title: Text(title),
      onTap: () => Navigator.of(context).pushReplacementNamed(route),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: <Widget>[
            AppBar(
              title: Text(
                "List Generator",
                style: Theme.of(context).textTheme.headline1,
              ),
              automaticallyImplyLeading: false,
            ),
            _buildRoute(context, "Lists", Icons.list, "/"),
            _buildRoute(context, "Types",
                Icons.format_list_numbered_rtl_rounded, TypesScreen.ROUTE_NAME),
            _buildRoute(context, "Items", Icons.dashboard_sharp,
                ItemsScreen.ROUTE_NAME),
            _buildRoute(
                context, "Settings", Icons.settings, SettingsScreen.ROUTE_NAME)
          ],
        ),
      ),
    );
  }
}
