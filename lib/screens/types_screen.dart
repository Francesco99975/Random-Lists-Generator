import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_lists_generator/providers/types.dart';
import 'package:random_lists_generator/widgets/add_type.dart';
import 'package:random_lists_generator/widgets/main_drawer.dart';
import 'package:random_lists_generator/widgets/type_list_item.dart';

class TypesScreen extends StatelessWidget {
  static const ROUTE_NAME = "/types";

  Widget _buildEmptyPage(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Text(
          "No types at this moment, press [+] to add one",
          style: Theme.of(context).textTheme.bodyText1,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _startAddType(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (ctx) {
          return GestureDetector(
            child: AddType(),
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Types",
          style: Theme.of(context).textTheme.headline1,
        ),
        iconTheme: IconThemeData(color: Theme.of(context).accentColor),
        actions: [
          IconButton(
              onPressed: () => _startAddType(context), icon: Icon(Icons.add))
        ],
      ),
      drawer: MainDrawer(),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: Consumer<Types>(
          builder: (context, types, child) {
            return types.size() < 1
                ? _buildEmptyPage(context)
                : ListView.builder(
                    itemCount: types.size(),
                    itemBuilder: (context, index) =>
                        ChangeNotifierProvider.value(
                      value: types.types[index],
                      child: TypeListItem(),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
