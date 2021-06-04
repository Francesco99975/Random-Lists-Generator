import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../providers/type.dart';
import '../providers/item.dart';
import '../providers/item_list.dart';

class DatabaseProvider {
  static const DATABASE_FILE = "rlg.db";

  static const TABLE_TYPES = "types";
  static const COLUMN_TYPE_ID = "typeId";
  static const COLUMN_TYPE_NAME = "typeName";
  static const COLUMN_TYPE_INSTANCES = "typeInstances";

  static const TABLE_ITEMS = "items";
  static const COLUMN_ITEM_ID = "itemId";
  static const COLUMN_ITEM_NAME = "itemName";
  static const COLUMN_ITEM_ELAPSED_INSTANCES = "itemElpsedInstances";

  static const TABLE_ITEM_LISTS = "itemLists";
  static const COLUMN_ITMLST_ID = "itmLstId";
  static const COLUMN_ITMLST_ARRAY = "itmLstArray";

  DatabaseProvider._();
  static final db = DatabaseProvider._();

  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await createDatabase();

    return _database;
  }

  Future<Database> createDatabase() async {
    final dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, DATABASE_FILE),
      version: 1,
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE IF NOT EXISTS $TABLE_TYPES("
            "$COLUMN_TYPE_ID INTEGER PRIMARY KEY,"
            "$COLUMN_TYPE_NAME TEXT NOT NULL,"
            "$COLUMN_TYPE_INSTANCES INTEGER NOT NULL);");

        await db.execute("CREATE TABLE IF NOT EXISTS $TABLE_ITEMS("
            "$COLUMN_ITEM_ID INTEGER PRIMARY KEY,"
            "$COLUMN_ITEM_NAME TEXT NOT NULL,"
            "$COLUMN_ITEM_ELAPSED_INSTANCES INTERGER NOT NULL,"
            "$COLUMN_TYPE_ID INTEGER REFERENCES $TABLE_TYPES($COLUMN_TYPE_ID) ON DELETE NO ACTION ON UPDATE NO ACTION);");

        await db.execute("CREATE TABLE IF NOT EXISTS $TABLE_ITEM_LISTS("
            "$COLUMN_ITMLST_ID INTEGER PRIMARY KEY,"
            "$COLUMN_ITMLST_ARRAY TEXT NOT NULL);");
        print("Created");
      },
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<List<Type>> getTypes() async {
    final db = await database;

    var types = await db!.query(TABLE_TYPES,
        columns: [COLUMN_TYPE_ID, COLUMN_TYPE_NAME, COLUMN_TYPE_INSTANCES]);

    List<Type> typesList = [];
    types.forEach((type) => typesList.add(Type.fromJson(type)));

    return typesList;
  }

  Future<Type> getType(int id) async {
    final db = await database;

    var types = await db!.query(TABLE_TYPES,
        columns: [COLUMN_TYPE_ID, COLUMN_TYPE_NAME, COLUMN_TYPE_INSTANCES],
        where: "$COLUMN_TYPE_ID = ?",
        whereArgs: [id]);

    List<Type> typesList = [];
    types.forEach((type) => typesList.add(Type.fromJson(type)));

    return typesList[0];
  }

  Future<Type> insertType(Type type) async {
    final db = await database;
    type.id = await db!.insert(TABLE_TYPES, type.toMap());
    return type;
  }

  Future<int> updateType(int id, Type type) async {
    final db = await database;
    return await db!.update(TABLE_TYPES, type.toMap(),
        where: "$COLUMN_TYPE_ID = ?", whereArgs: [id]);
  }

  Future<int> deleteType(int id) async {
    final db = await database;
    return await db!
        .delete(TABLE_TYPES, where: "$COLUMN_TYPE_ID = ?", whereArgs: [id]);
  }

  // -------------------------------------------------------------------------------

  Future<List<Item>> getItems() async {
    final db = await database;

    var items = await db!.query(TABLE_ITEMS, columns: [
      COLUMN_ITEM_ID,
      COLUMN_ITEM_NAME,
      COLUMN_ITEM_ELAPSED_INSTANCES,
      COLUMN_TYPE_ID
    ]);

    final types = await this.getTypes();

    List<Item> itemsList = [];
    items.forEach((itm) {
      final type = types.firstWhere(
          (type) => itm[DatabaseProvider.COLUMN_TYPE_ID] == type.id);
      itemsList.add(Item.fromJson(itm, type));
    });

    return itemsList;
  }

  Future<Item> getItem(int id) async {
    final db = await database;

    var items = await db!.query(TABLE_ITEMS,
        columns: [
          COLUMN_ITEM_ID,
          COLUMN_ITEM_NAME,
          COLUMN_ITEM_ELAPSED_INSTANCES,
          COLUMN_TYPE_ID
        ],
        where: "$COLUMN_ITEM_ID = ?",
        whereArgs: [id]);

    final types = await this.getTypes();

    List<Item> itemsList = items.map((itm) {
      final type = types.firstWhere(
          (type) => itm[DatabaseProvider.COLUMN_TYPE_ID] == type.id);
      return Item.fromJson(itm, type);
    }).toList();

    return itemsList[0];
  }

  Future<Item> insertItem(Item itm) async {
    final db = await database;
    itm.id = await db!.insert(TABLE_ITEMS, itm.toMap());
    return itm;
  }

  Future<int> updateItem(int id, Item itm) async {
    final db = await database;
    return await db!.update(TABLE_ITEMS, itm.toMap(),
        where: "$COLUMN_ITEM_ID = ?", whereArgs: [id]);
  }

  Future<int> deleteItem(int id) async {
    final db = await database;
    return await db!
        .delete(TABLE_ITEMS, where: "$COLUMN_ITEM_ID = ?", whereArgs: [id]);
  }

  // -------------------------------------------------------------------------------

  Future<List<ItemList>> getItemLists() async {
    final db = await database;

    var itemLists = await db!.query(TABLE_ITEM_LISTS,
        columns: [COLUMN_ITMLST_ID, COLUMN_ITMLST_ARRAY]);

    final items = await this.getItems();

    List<ItemList> itmLstList = [];
    itemLists.forEach((itmLst) {
      final array =
          json.decode(itmLst[DatabaseProvider.COLUMN_ITMLST_ARRAY] as String);
      List<Item> itemsList = [];
      array.forEach((el) => itemsList.add(items.firstWhere(
          (item) => el[DatabaseProvider.COLUMN_ITEM_ID] == item.id)));
      itmLstList.add(ItemList(
          id: itmLst[DatabaseProvider.COLUMN_ITMLST_ID] as int,
          items: itemsList));
    });

    return itmLstList;
  }

  Future<ItemList> insertItemList(ItemList itmLst) async {
    final db = await database;
    itmLst.id = await db!.insert(TABLE_ITEM_LISTS, itmLst.toMap());
    return itmLst;
  }

  Future<int> updateItemList(int id, ItemList itmLst) async {
    final db = await database;
    return await db!.update(TABLE_ITEM_LISTS, itmLst.toMap(),
        where: "$COLUMN_ITMLST_ID = ?", whereArgs: [id]);
  }

  Future<int> deleteItemList(int id) async {
    final db = await database;
    return await db!.delete(TABLE_ITEM_LISTS,
        where: "$COLUMN_ITMLST_ID = ?", whereArgs: [id]);
  }

  Future<int> clearItemList() async {
    final db = await database;

    return await db!.delete(TABLE_ITEM_LISTS, where: null);
  }
}
