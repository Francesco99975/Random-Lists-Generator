import 'package:flutter/foundation.dart';
import 'package:random_lists_generator/db/database_provider.dart';

class Type with ChangeNotifier {
  int? id;
  String? name;
  int? instances;

  Type({this.id, required this.name, required this.instances});

  Type.fromJson(Map<String, dynamic> jsonData) {
    this.id = jsonData[DatabaseProvider.COLUMN_TYPE_ID];
    this.name = jsonData[DatabaseProvider.COLUMN_TYPE_NAME];
    this.instances = jsonData[DatabaseProvider.COLUMN_TYPE_INSTANCES];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_TYPE_ID: this.id,
      DatabaseProvider.COLUMN_TYPE_NAME: this.name,
      DatabaseProvider.COLUMN_TYPE_INSTANCES: this.instances
    };

    if (this.id != null) map[DatabaseProvider.COLUMN_TYPE_ID] = id;

    return map;
  }

  bool operator ==(dynamic other) {
    return this.id == other.id;
  }

  update(String text, int number) async {
    this.name = text;
    this.instances = number;
    await DatabaseProvider.db.updateType(id!, this);
    notifyListeners();
  }

  @override
  int get hashCode => super.hashCode;
}
