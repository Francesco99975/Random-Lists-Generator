import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_lists_generator/providers/items.dart';
import 'package:random_lists_generator/providers/types.dart';
import 'package:random_lists_generator/widgets/add_item.dart';
import 'package:random_lists_generator/widgets/item_list_item.dart';
import 'package:random_lists_generator/widgets/main_drawer.dart';

class ItemsScreen extends StatelessWidget {
  static const ROUTE_NAME = "/items";

  Widget _buildEmptyPage(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Text(
          "No items at this moment, press [+] to add one",
          style: Theme.of(context).textTheme.bodyText1,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _startAddItem(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (ctx) {
          return GestureDetector(
            child: AddItem(),
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final len = Provider.of<Types>(context, listen: false).size();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Items",
          style: Theme.of(context).textTheme.headline1,
        ),
        iconTheme: IconThemeData(color: Theme.of(context).accentColor),
        actions: [
          IconButton(
              onPressed: len < 1 ? null : () => _startAddItem(context),
              icon: Icon(Icons.add))
        ],
      ),
      drawer: MainDrawer(),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: Consumer<Items>(
          builder: (context, items, child) {
            return items.size() < 1
                ? _buildEmptyPage(context)
                : ListView.builder(
                    itemCount: items.size(),
                    itemBuilder: (context, index) =>
                        ChangeNotifierProvider.value(
                      value: items.items[index],
                      child: ItemListItem(),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
