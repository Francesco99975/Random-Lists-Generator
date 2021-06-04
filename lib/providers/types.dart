import 'package:flutter/foundation.dart';
import '../db/database_provider.dart';
import '../providers/type.dart';

class Types with ChangeNotifier {
  List<Type> _items = [];

  List<Type> get types => _items;

  Future<void> loadItems() async {
    _items = await DatabaseProvider.db.getTypes();
    notifyListeners();
  }

  Future<int?> addItem(Type itm) async {
    final item = await DatabaseProvider.db.insertType(itm);
    _items.add(item);
    notifyListeners();
    return item.id;
  }

  Future<void> updateItem(Type itm) async {
    await DatabaseProvider.db.updateType(itm.id as int, itm);
    final index = _items.indexWhere((el) => el.id == itm.id);
    _items[index] = itm;
    notifyListeners();
  }

  Future<void> deleteItem(int id) async {
    await DatabaseProvider.db.deleteType(id);
    _items.removeWhere((el) => el.id == id);
    notifyListeners();
  }

  int size() {
    return _items.length;
  }

  int occupiedInstances() {
    return this._items.fold(0, (prev, el) => prev + el.instances!);
  }
}
