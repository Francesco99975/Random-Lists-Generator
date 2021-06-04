import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_lists_generator/providers/item_lists.dart';
import 'package:random_lists_generator/providers/types.dart';
import '../providers/type.dart';

class AddType extends StatefulWidget {
  @override
  _AddTypeState createState() => _AddTypeState();
}

class _AddTypeState extends State<AddType> {
  final _nameCtrl = TextEditingController();
  double _instances = 1;

  @override
  Widget build(BuildContext context) {
    final listSize = Provider.of<ItemLists>(context, listen: false).listSize;
    final occupied =
        Provider.of<Types>(context, listen: false).occupiedInstances();
    if (occupied == listSize) {
      setState(() {
        _instances = 0;
      });
    }
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
                        labelText: "Type Name",
                        labelStyle: Theme.of(context).textTheme.bodyText1),
                    controller: _nameCtrl,
                    autocorrect: false),
                Center(
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      "Instances of this type: ${_instances.toInt()}",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
                if (listSize.toDouble() - occupied > 1)
                  Slider(
                      value: _instances,
                      min: 0,
                      max: listSize.toDouble() - occupied,
                      label: _instances.round().toString(),
                      divisions: listSize - occupied,
                      activeColor: Theme.of(context).accentColor,
                      onChanged: (double value) {
                        setState(() {
                          _instances = value;
                        });
                      }),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_nameCtrl.text.trim().isNotEmpty) {
                        Type newType = Type(
                            name: _nameCtrl.text,
                            instances: _instances.toInt());

                        await Provider.of<Types>(context, listen: false)
                            .addItem(newType);

                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(
                      "Add Type",
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
