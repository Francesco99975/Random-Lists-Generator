import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_lists_generator/providers/item_lists.dart';
import '../providers/item.dart';

class SpecialListItem extends StatelessWidget {
  final int index;

  SpecialListItem(this.index);

  @override
  Widget build(BuildContext context) {
    final item = Provider.of<Item>(context);
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
      ),
      // ignore: missing_return
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Theme.of(context).backgroundColor,
              title: Text(
                "Are you sure ?",
                style: Theme.of(context).textTheme.headline1,
              ),
              content: Text(
                "Do you want to remove this item?",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              actions: <Widget>[
                TextButton(
                  child: Text("No",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: Colors.red)),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child:
                      Text("Yes", style: Theme.of(context).textTheme.bodyText2),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            ),
          );
        }
      },
      onDismissed: (direction) async {
        if (direction == DismissDirection.endToStart) {
          await Provider.of<ItemLists>(context, listen: false)
              .removeElement(item.id!, index);
        }
      },
      child: Card(
        elevation: 3,
        color: Theme.of(context).primaryColor,
        child: ListTile(
            leading: Icon(Icons.dashboard_rounded,
                color: Theme.of(context).accentColor, size: 26),
            title: Text(
              "${item.name!} - (${item.type!.name!})",
              style: Theme.of(context).textTheme.bodyText2,
            )),
      ),
    );
  }
}
