import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// my imps
import 'helper.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), "lst.db"),
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE WeekdayTasksTemplate(templateId TEXT PRIMARY KEY, lid INTEGER, day TEXT, des TEXT)");
        await db.execute(
            "CREATE TABLE WeekdayTasks(taskId TEXT PRIMARY KEY, lid INTEGER, day TEXT, date TEXT, des TEXT, checked INTEGER)");
      },
      version: 1,
    );
  }

  Future<void> insertItem(ItemObj item) async {
    Database db = await database();
    await db.insert(
      'WeekdayTasks',
      {
        "taskId": item.taskId,
        "lid": item.lid,
        "day": item.day,
        "date": item.date,
        "des": item.itemValue,
        "checked": item.checked
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await db.insert(
      'WeekdayTasksTemplate',
      {
        "templateId": item.taskId,
        "lid": item.lid,
        "day": item.day,
        "des": item.itemValue
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> getTasksCount(date) async {
    final db = await database();
    final List<Map<String, dynamic>> tasks =
        await db.query("WeekdayTasks where date = '$date'");
    if (tasks.isNotEmpty) {
      return tasks.length;
    } else {
      return 0;
    }
  }

  Future<List<ItemObj>> getTasksList(date) async {
    final db = await database();
    List<ItemObj> lst;
    final List<Map<String, dynamic>> tasks =
        await db.query("WeekdayTasks where date = '$date'");
    if (tasks.isNotEmpty) {
      try {
        lst = List.generate(tasks.length, (i) {
          return ItemObj.maps(tasks[i]);
        });
      } catch (e) {
        lst = [];
      }
      return lst;
    } else {
      return [];
    }
  }

  Future<List<ItemObj>> retrieveItem(weekday, weekdate) async {
    final db = await database();
    List<ItemObj> lst;
    final List<Map<String, dynamic>> tasks = await db
        .query("WeekdayTasks where date = '$weekdate' and day = '$weekday'");

    if (tasks.isNotEmpty) {
      try {
        lst = List.generate(tasks.length, (i) {
          return ItemObj.maps(tasks[i]);
        });
      } catch (e) {
        lst = [];
      }
      return lst;
    } else {
      await db.rawInsert(
          "insert into WeekdayTasks(taskId, lid, day, date, des, checked) select templateId as taskId, lid, day, '$weekdate' as date, des, 0 as checked from WeekdayTasksTemplate where day = '$weekday'");

      final List<Map<String, dynamic>> tasksTemplate =
          await db.query("WeekdayTasksTemplate where day = '$weekday'");
      try {
        lst = List.generate(tasksTemplate.length, (i) {
          return ItemObj.maps(tasksTemplate[i]);
        });
      } catch (e) {
        lst = [];
      }
      return lst;
    }
  }

  Future<int> getCurr(weekday) async {
    final db = await database();
    List<Map<String, Object?>> query = await db.rawQuery(
        "SELECT lid as curr FROM WeekdayTasks where day = '$weekday' ORDER BY lid DESC LIMIT 1");
    dynamic res;
    try {
      res = query.first['curr'] as int;
      res += 1;
    } catch (e) {
      res = 0;
    }
    return res;
  }

  Future<List<ItemObj>> retrieveEverything() async {
    final db = await database();
    final List<Map<String, dynamic>> maps = await db.query("WeekdayTasks");
    List<ItemObj> lst = List.generate(maps.length, (i) {
      return ItemObj.maps(maps[i]);
    });
    return lst;
  }

  Future<void> updateItem(ItemObj item) async {
    final db = await database();
    await db.update(
      'WeekdayTasks',
      {"des": item.itemValue, "checked": item.checked},
      where: 'taskId = ? and day = ? and date = ?',
      whereArgs: [item.taskId, item.day, item.date],
    );
    await db.update(
      'WeekdayTasksTemplate',
      {"des": item.itemValue},
      where: 'templateId = ? and day = ?',
      whereArgs: [item.taskId, item.day],
    );
  }

  Future<void> deleteItem(ItemObj item) async {
    final db = await database();
    await db.delete(
      'WeekdayTasks',
      where: 'taskId = ? and day = ? and date = ?',
      whereArgs: [item.taskId, item.day, item.date],
    );
    await db.delete(
      'WeekdayTasksTemplate',
      where: 'templateId = ? and day = ?',
      whereArgs: [item.taskId, item.day],
    );
  }
}
