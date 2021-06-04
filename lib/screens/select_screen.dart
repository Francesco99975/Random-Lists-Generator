import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_lists_generator/providers/item.dart';
import 'package:random_lists_generator/providers/item_lists.dart';
import 'package:random_lists_generator/providers/items.dart';
import 'package:random_lists_generator/widgets/select_list_item.dart';

class SelectScreen extends StatefulWidget {
  final int index;
  final List<int?> occupiedIds;

  SelectScreen(this.index, this.occupiedIds);

  @override
  _SelectScreenState createState() => _SelectScreenState();
}

class _SelectScreenState extends State<SelectScreen> {
  List<Item> _selectedList = [];

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

  void _add(Item itm) {
    _selectedList.add(itm);
  }

  void _remove(Item itm) {
    _selectedList.removeWhere((el) => el.id == itm.id);
  }

  Future<void> _save(BuildContext context) async {
    await Provider.of<ItemLists>(context, listen: false)
        .addItemsToList(_selectedList, widget.index);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select Items",
          style: Theme.of(context).textTheme.headline1,
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Theme.of(context).accentColor),
        actions: [
          TextButton.icon(
              label: Text(
                "Save",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              onPressed: () async => await _save(context),
              icon: Icon(
                Icons.save,
                color: Theme.of(context).accentColor,
              ))
        ],
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: Consumer<Items>(
          builder: (context, items, child) {
            final filteredItems = items.items
              ..removeWhere((item) => widget.occupiedIds.contains(item.id));
            return filteredItems.length < 1
                ? _buildEmptyPage(context)
                : ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) =>
                        ChangeNotifierProvider.value(
                      value: filteredItems[index],
                      child: SelectListItem(_add, _remove),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
