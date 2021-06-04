import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_lists_generator/providers/item_lists.dart';
import 'package:random_lists_generator/providers/types.dart';
import '../providers/type.dart';

class TypeListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final type = Provider.of<Type>(context);
    return Dismissible(
      key: ValueKey(type.id),
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
                "Do you want to remove this type?",
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
                final typeCtrl = TextEditingController(text: type.name);
                double _instances = type.instances!.toDouble();
                final maxInstances = _instances +
                    (Provider.of<ItemLists>(context, listen: false).listSize -
                        Provider.of<Types>(context, listen: false)
                            .occupiedInstances());
                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                        backgroundColor: Theme.of(context).backgroundColor,
                        title: Text(
                          "Edit Department",
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
                              if (typeCtrl.text.trim().isNotEmpty) {
                                await type.update(
                                    typeCtrl.text, _instances.toInt());
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
                                    controller: typeCtrl,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                    decoration: InputDecoration(
                                        labelText: "Type Name",
                                        labelStyle: Theme.of(context)
                                            .textTheme
                                            .bodyText1)),
                                SizedBox(height: 10),
                                Center(
                                  child: Container(
                                    margin: EdgeInsets.all(8.0),
                                    padding: EdgeInsets.all(5.0),
                                    child: Text(
                                      "Instances of this type: ${_instances.toInt()}",
                                      textAlign: TextAlign.center,
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Slider(
                                    value: _instances,
                                    min: 0,
                                    max: maxInstances,
                                    label: _instances.round().toString(),
                                    divisions: maxInstances.toInt(),
                                    activeColor: Theme.of(context).accentColor,
                                    onChanged: (double value) {
                                      setState(() {
                                        _instances = value;
                                      });
                                    }),
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
          await Provider.of<Types>(context, listen: false).deleteItem(type.id!);
        }
      },
      child: Card(
        elevation: 3,
        color: Theme.of(context).primaryColor,
        child: ListTile(
          leading: Icon(Icons.format_list_numbered_rtl_rounded,
              color: Theme.of(context).accentColor, size: 26),
          title: Text(
            type.name!,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          subtitle: Text(
            "Instances: ${type.instances.toString()}",
            style:
                Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
