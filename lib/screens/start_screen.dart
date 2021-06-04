import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_lists_generator/providers/item.dart';
import 'package:random_lists_generator/providers/item_list.dart';
import 'package:random_lists_generator/screens/home.dart';
import 'package:random_lists_generator/widgets/loading.dart';
import '../providers/types.dart';
import '../providers/items.dart';
import '../providers/item_lists.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  Future<void> _generateLists(BuildContext context) async {
    final itemLists = Provider.of<ItemLists>(context, listen: false);
    final types = Provider.of<Types>(context, listen: false).types;
    final items = Provider.of<Items>(context, listen: false).items;

    if ((itemLists.size() == 0 && items.length >= (itemLists.listSize * 3))) {
      List<ItemList> lists = [];

      for (int i = 0; i < 3; ++i) {
        print("Iteration: #$i");
        List<Item> list = [];

        types.forEach((type) {
          // print("Dealing with: ${type.name}");
          final cluster = items
              .where((item) => item.type!.id == type.id && item.isReady())
              .toList();
          // print("Cluster: ${cluster.map((e) => e.name).toList()}");
          if (cluster.length <= type.instances!) {
            cluster.forEach((item) {
              item.use();
              list.add(item);
            });
          } else {
            final tmp = cluster..shuffle();
            final subCluster = tmp.sublist(0, type.instances);
            // print("Subcluster: ${subCluster.map((e) => e.name).toList()}");
            // final excessCluster =
            //     cluster.where((item) => !subCluster.contains(item));
            // print(
            //     "ExcessCluster: ${excessCluster.map((e) => e.name).toList()}");
            // excessCluster.forEach((item) => item.elapsed());
            subCluster.forEach((item) {
              item.use();
              list.add(item);
            });
          }
        });

        // print("List #$i ${list.map((e) => e.name).toList()}");

        lists.add(ItemList(items: list));
        list = [];
      }
      // print("LISTS: ${lists[1].items!.map((e) => e.name).toList()}");
      await itemLists.generate(lists);
      itemLists.setLastUpdate(DateTime.now());
    } else if (items.length >= (itemLists.listSize * 3) &&
        DateTime.now().difference(itemLists.lastUpdate).inDays >= 21) {
      List<Item> list = [];

      types.forEach((type) {
        final cluster = items
            .where((item) => item.type!.id == type.id && item.isReady())
            .toList();
        if (cluster.length <= type.instances!) {
          cluster.forEach((item) {
            item.use();
            list.add(item);
          });
        } else {
          final tmp = cluster..shuffle();
          final subCluster = tmp.sublist(0, type.instances);
          // final excessCluster =
          //     cluster.where((item) => !subCluster.contains(item));
          // excessCluster.forEach((item) => item.elapsed());
          subCluster.forEach((item) {
            item.use();
            list.add(item);
          });
        }
      });

      print("List ${list.map((e) => e.name).toList()}");

      await itemLists.shift(new ItemList(items: list));
      itemLists.setLastUpdate(DateTime.now());
    } else {
      print("Nothing Happened");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          Provider.of<Types>(context, listen: false).loadItems(),
          Provider.of<Items>(context, listen: false).loadItems(),
          Provider.of<ItemLists>(context, listen: false).loadItems()
        ]),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Loading()
                : FutureBuilder(
                    future: _generateLists(context),
                    builder: (context, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? Loading()
                            : Home(_generateLists)));
  }
}
