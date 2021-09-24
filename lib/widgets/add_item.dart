import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_lists_generator/providers/items.dart';
import 'package:random_lists_generator/providers/types.dart';
import '../providers/item.dart';
import '../providers/type.dart';

class AddItem extends StatefulWidget {
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final _nameCtrl = TextEditingController();
  late Type _type;
  bool isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      final types = Provider.of<Types>(context, listen: false).types;
      _type = types[0];
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final types = Provider.of<Types>(context, listen: false).types;
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).accentColor),
      child: SingleChildScrollView(
        child: Card(
          color: Theme.of(context).backgroundColor,
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.only(
                left: 10,
                top: 10,
                right: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom + 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TextField(
                    style: Theme.of(context).textTheme.bodyText1,
                    decoration: InputDecoration(
                        labelText: "Item Name",
                        labelStyle: Theme.of(context).textTheme.bodyText1),
                    controller: _nameCtrl,
                    autocorrect: false),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: DropdownButton<Type>(
                        value: _type,
                        dropdownColor: Theme.of(context).primaryColor,
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
                            print(_type.name);
                          });
                        },
                        items: types
                            .map((type) => DropdownMenuItem<Type>(
                                  child: Text(
                                    "${type.name}",
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                  value: type,
                                ))
                            .toList()),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_nameCtrl.text.trim().isNotEmpty) {
                        Item newItem =
                            Item(name: _nameCtrl.text.trim(), type: _type);

                        await Provider.of<Items>(context, listen: false)
                            .addItem(newItem);

                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(
                      "Add Item",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
