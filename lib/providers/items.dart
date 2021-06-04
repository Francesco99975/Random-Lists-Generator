import 'package:flutter/foundation.dart';
import '../db/database_provider.dart';
import '../providers/item.dart';

class Items with ChangeNotifier {
  List<Item> _items = [];

  List<Item> get items => _items;

  Future<void> loadItems() async {
    _items = await DatabaseProvider.db.getItems();
    notifyListeners();
  }

  Future<int?> addItem(Item itm) async {
    final item = await DatabaseProvider.db.insertItem(itm);
    _items.add(item);
    notifyListeners();
    return item.id;
  }

  Future<void> updateItem(Item itm) async {
    await DatabaseProvider.db.updateItem(itm.id as int, itm);
    final index = _items.indexWhere((el) => el.id == itm.id);
    _items[index] = itm;
    notifyListeners();
  }

  Future<void> deleteItem(int id) async {
    await DatabaseProvider.db.deleteItem(id);
    _items.removeWhere((el) => el.id == id);
    notifyListeners();
  }

  int size() {
    return _items.length;
  }
}
