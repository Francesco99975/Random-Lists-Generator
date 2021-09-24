import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_lists_generator/providers/items.dart';
import 'package:random_lists_generator/providers/types.dart';
import '../providers/item.dart';
import '../providers/type.dart';

class ItemListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final item = Provider.of<Item>(context);
    return Dismissible(
      key: ValueKey(item.id),
      background: Container(
        padding: const EdgeInsets.only(left: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
        color: Theme.of(context).primaryColor,
        child: Icon(
          Icons.edit,
          color: Theme.of(context).accentColor,
          size: 40,
        ),
        alignment: Alignment.centerLeft,
      ),
      secondaryBackground: Container(
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
        } else if (direction == DismissDirection.startToEnd) {
          return await showDialog(
              context: context,
              builder: (context) {
                final itemCtrl = TextEditingController(text: item.name);
                Type _type = item.type!;
                final types = Provider.of<Types>(context, listen: false).types;
                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                        backgroundColor: Theme.of(context).backgroundColor,
                        title: Text(
                          "Edit Item",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        titlePadding: const EdgeInsets.all(15.0),
                        contentPadding: const EdgeInsets.all(15.0),
                        elevation: 5,
                        actions: <Widget>[
                          ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text(
                                "Close",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(color: Colors.red),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).backgroundColor,
                              )),
                          ElevatedButton(
                            child: Text(
                              "Save Changes",
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                            ),
                            onPressed: () async {
                              if (itemCtrl.text.trim().isNotEmpty) {
                                await item.update(itemCtrl.text.trim(), _type);
                                Navigator.of(context).pop(false);
                              }
                            },
                          )
                        ],
                        content: SingleChildScrollView(
                          child: Container(
                            height: MediaQuery.of(context).size.height / 3,
                            child: Column(
                              children: [
                                TextField(
                                    controller: itemCtrl,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                    decoration: InputDecoration(
                                        labelText: "Item Name",
                                        labelStyle: Theme.of(context)
                                            .textTheme
                                            .bodyText1)),
                                SizedBox(height: 10),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(22.0),
                                    child: DropdownButton<Type>(
                                        value: _type,
                                        dropdownColor:
                                            Theme.of(context).primaryColor,
                                        elevation: 6,
                                        iconSize: 28,
                                        isExpanded: true,
                                        underline: Container(
                                          height: 2,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        icon: Icon(
                                          Icons.arrow_drop_down_sharp,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            _type = value!;
                                            print(value.name);
                                          });
                                        },
                                        items: types
                                            .map((type) =>
                                                DropdownMenuItem<Type>(
                                                  child: Text(
                                                    "${type.name}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2,
                                                  ),
                                                  value: type,
                                                ))
                                            .toList()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ));
                  },
                );
              });
        }
      },
      onDismissed: (direction) async {
        if (direction == DismissDirection.endToStart) {
          await Provider.of<Items>(context, listen: false).deleteItem(item.id!);
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
          ),
          subtitle: Text(
            item.elapsedInstances! < 0
                ? "Never Listed"
                : "Elapsed Instances: ${item.elapsedInstances}",
            style:
                Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
