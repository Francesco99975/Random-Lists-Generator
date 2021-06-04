import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:random_lists_generator/db/database_provider.dart';
import 'item.dart';

// List<Item> parse(String enc) {
//   var parsedData = json.decode(enc) as List;
//   return parsedData.map((el) {
//     return Item.fromJson(el);
//   }).toList();
// }

class ItemList with ChangeNotifier {
  int? id;
  List<Item>? items;

  ItemList({this.id, required this.items});

  // ItemList.fromJson(Map<String, dynamic> jsonData) {
  //   this.id = jsonData[DatabaseProvider.COLUMN_ITMLST_ID];
  //   this.items = parse(jsonData[DatabaseProvider.COLUMN_ITMLST_ARRAY]);
  // }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_ITMLST_ID: this.id,
      DatabaseProvider.COLUMN_ITMLST_ARRAY:
          json.encode(this.items!.map((itm) => itm.toMap()).toList())
    };

    print(map);

    if (this.id != null) map[DatabaseProvider.COLUMN_ITMLST_ID] = id;

    return map;
  }
}
