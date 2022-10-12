import 'package:lstmkr/item.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

// my imps
import 'helper.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(join(await getDatabasesPath(), "lst.db"),
        onCreate: ((db, version) {
      return db.execute(
          "create table tasks(id integer primary key, day text, description text, check: integer)");
    }));
  }

  Future<void> insertItem(ItemObj item) async {
    var date = DateTime.now();
    Database db = await database();
    await db.insert(
        'tasks',
        {
          "id": item.id,
          "day": DateFormat('EEEE').format(date),
          "description": item.itemValue,
          "check": item.checked
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<ItemObj>> retrieveItem() async {
    final db = await database();
    final List<Map<String, dynamic>> maps = await db.query('dogs');

    return List.generate(maps.length, (i) {
      return ItemObj.arg(maps[i]['id'], maps[i]['day'], maps[i]['description'],
          maps[i]['check']);
    });
  }
}
