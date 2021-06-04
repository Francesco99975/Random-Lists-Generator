import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_lists_generator/providers/items.dart';
import 'package:random_lists_generator/screens/select_screen.dart';
import 'package:random_lists_generator/widgets/main_drawer.dart';
import 'package:random_lists_generator/widgets/special_list_item.dart';
import '../providers/item_lists.dart';

class Home extends StatefulWidget {
  final Function _generate;

  Home(this._generate);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController!.addListener(_handleTabIndex);
  }

  @override
  void dispose() {
    _tabController!.removeListener(_handleTabIndex);
    _tabController!.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  Widget _buildEmptyPage(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Text(
            "No lists at this moment, add more items to generate some",
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Future<void> _reset(BuildContext context) async {
    final itemLists = Provider.of<ItemLists>(context, listen: false);
    final items = Provider.of<Items>(context, listen: false).items;
    await itemLists.clearAll();
    items.forEach((item) => item.reset());

    await widget._generate(context);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Lists",
              style: Theme.of(context).textTheme.headline1,
            ),
            iconTheme: IconThemeData(color: Theme.of(context).accentColor),
            actions: [
              IconButton(
                  onPressed: () => _reset(context), icon: Icon(Icons.restore)),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SelectScreen(
                          _tabController!.index,
                          Provider.of<ItemLists>(context, listen: false)
                              .itemLists[_tabController!.index]
                              .items!
                              .map((el) => el.id)
                              .toList()),
                    ));
                  },
                  icon: Icon(Icons.add))
            ],
            bottom: TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).accentColor,
              tabs: [
                Tab(
                  icon: Icon(Icons.looks_one_outlined),
                ),
                Tab(
                  icon: Icon(Icons.looks_two_outlined),
                ),
                Tab(
                  icon: Icon(Icons.looks_3_outlined),
                )
              ],
            ),
          ),
          drawer: MainDrawer(),
          body: Consumer<ItemLists>(
            builder: (context, lists, child) {
              return lists.size() < 1
                  ? _buildEmptyPage(context)
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        Container(
                          color: Theme.of(context).backgroundColor,
                          child: ListView.builder(
                            itemCount: lists.itemLists[0].items!.length,
                            itemBuilder: (context, index) =>
                                ChangeNotifierProvider.value(
                              value: lists.itemLists[0].items![index],
                              child: SpecialListItem(_tabController!.index),
                            ),
                          ),
                        ),
                        Container(
                          color: Theme.of(context).backgroundColor,
                          child: ListView.builder(
                            itemCount: lists.itemLists[1].items!.length,
                            itemBuilder: (context, index) =>
                                ChangeNotifierProvider.value(
                              value: lists.itemLists[1].items![index],
                              child: SpecialListItem(_tabController!.index),
                            ),
                          ),
                        ),
                        Container(
                          color: Theme.of(context).backgroundColor,
                          child: ListView.builder(
                            itemCount: lists.itemLists[2].items!.length,
                            itemBuilder: (context, index) =>
                                ChangeNotifierProvider.value(
                              value: lists.itemLists[2].items![index],
                              child: SpecialListItem(_tabController!.index),
                            ),
                          ),
                        ),
                      ],
                    );
            },
          ),
        ));
  }
}
