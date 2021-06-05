import 'package:flutter/foundation.dart';
import 'package:random_lists_generator/providers/item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/database_provider.dart';
import '../providers/item_list.dart';

class ItemLists with ChangeNotifier {
  List<ItemList> _items = [];
  int _listSize = 10;
  DateTime _lastUpdate = DateTime.now();

  static const String SIZE_KEY = "listSize";
  static const String UPDATE_KEY = "lastUpdate";

  List<ItemList> get itemLists => _items;

  int get listSize => _listSize;

  DateTime get lastUpdate => _lastUpdate;

  setListSize(int size) async {
    _listSize = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(SIZE_KEY, _listSize);
    notifyListeners();
  }

  setLastUpdate(DateTime date) async {
    _lastUpdate = date;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(UPDATE_KEY, _lastUpdate.millisecondsSinceEpoch);
    notifyListeners();
  }

  Future<void> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(UPDATE_KEY))
      _lastUpdate =
          DateTime.fromMillisecondsSinceEpoch(prefs.getInt(UPDATE_KEY)!);
    if (prefs.containsKey(SIZE_KEY)) _listSize = prefs.getInt(SIZE_KEY)!;
    _items = await DatabaseProvider.db.getItemLists();
    for (var i in _items) {
      print("LS: ${i.items!.map((e) => e.name)}");
    }
    notifyListeners();
  }

  Future<void> generate(List<ItemList> list) async {
    for (ItemList ls in list) {
      final item = await DatabaseProvider.db.insertItemList(ls);
      _items.add(item);
    }
    notifyListeners();
  }

  Future<void> updateItem(ItemList list) async {
    await DatabaseProvider.db.updateItemList(list.id as int, list);
    final index = _items.indexWhere((el) => el.id == list.id);
    _items[index] = list;
    notifyListeners();
  }

  Future<void> deleteItem(int id) async {
    await DatabaseProvider.db.deleteItemList(id);
    _items.removeWhere((el) => el.id == id);
    notifyListeners();
  }

  Future<void> clearAll() async {
    await DatabaseProvider.db.clearItemList();
    _items = [];
    notifyListeners();
  }

  int size() {
    return _items.length;
  }

  Future<void> shift(ItemList list) async {
    ItemList deleted = _items.removeAt(0);
    await DatabaseProvider.db.deleteItemList(deleted.id!);
    final item = await DatabaseProvider.db.insertItemList(list);
    _items.add(item);
    notifyListeners();
  }

  Future<void> removeElement(int itemId, int index) async {
    _items[index].items!.where((el) => el.id == itemId).first.use();
    _items[index].items!.removeWhere((el) => el.id == itemId);
    await updateItem(_items[index]);
    notifyListeners();
  }

  Future<void> addItemsToList(List<Item> selectedList, int index) async {
    _items[index].items!.addAll(selectedList);
    await updateItem(_items[index]);
    notifyListeners();
  }
}
