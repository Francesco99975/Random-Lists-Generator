import 'package:flutter/foundation.dart';
import 'package:random_lists_generator/db/database_provider.dart';
import 'type.dart';

class Item with ChangeNotifier {
  int? id;
  String? name;
  Type? type;
  int? elapsedInstances;

  Item(
      {this.id,
      required this.name,
      required this.type,
      this.elapsedInstances = -1});

  Item.fromJson(Map<String, dynamic> jsonData, Type type) {
    this.id = jsonData[DatabaseProvider.COLUMN_ITEM_ID];
    this.name = jsonData[DatabaseProvider.COLUMN_ITEM_NAME];
    this.elapsedInstances =
        jsonData[DatabaseProvider.COLUMN_ITEM_ELAPSED_INSTANCES];
    this.type = type;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_ITEM_ID: this.id,
      DatabaseProvider.COLUMN_ITEM_NAME: this.name,
      DatabaseProvider.COLUMN_TYPE_ID: this.type!.id,
      DatabaseProvider.COLUMN_ITEM_ELAPSED_INSTANCES: this.elapsedInstances
    };

    if (this.id != null) map[DatabaseProvider.COLUMN_ITEM_ID] = id;

    return map;
  }

  bool isReady() {
    return this.elapsedInstances == -1 || this.elapsedInstances! >= 2;
  }

  update(String text, Type type) async {
    this.name = text;
    this.type = type;
    DatabaseProvider.db.updateItem(id!, this);
    notifyListeners();
  }

  use() {
    if (this.elapsedInstances! < 0)
      this.elapsedInstances = 1;
    else
      this.elapsedInstances = this.elapsedInstances! + 1;
    DatabaseProvider.db.updateItem(id!, this);
  }

  restore() {
    this.elapsedInstances = 0;
    DatabaseProvider.db.updateItem(id!, this);
    notifyListeners();
  }

  reset() {
    this.elapsedInstances = -1;
    DatabaseProvider.db.updateItem(id!, this);
    notifyListeners();
  }
}
