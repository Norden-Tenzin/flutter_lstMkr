import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'database.dart';

var uuid = const Uuid();

class ItemHolder {
  late int curr;
  late List<ItemObj> lst;

  ItemHolder() {
    curr = 0;
    lst = [];
  }

  addItems(DatabaseHelper dbHelper, ItemObj item) {
    item.setLID(curr);
    lst.add(item);
    try {
      dbHelper.insertItem(item);
    } on DatabaseException {
      print("COULDNT ADD");
    } catch (e) {
      print(e);
    }
    curr++;
  }
}

class ItemObj {
  late String taskId;
  late int lid;
  late String day;
  late String date;
  late String itemValue;

  // 0 == False and 1 == True
  late int checked;

  ItemObj() {
    itemValue = "";
    checked = 0;
  }

  ItemObj.weekday(String weekday, String weekdate) {
    taskId = uuid.v4();
    itemValue = "";
    day = weekday;
    date = weekdate;
    checked = 0;
  }

  ItemObj.arg(this.taskId, this.lid, this.day, this.itemValue, this.checked);

  ItemObj.maps(maps) {
    taskId = maps['taskId'];
    lid = maps['lid'];
    day = maps['day'];
    date = maps['date'];
    itemValue = maps['des'];
    checked = maps['checked'];
  }

  flipSwitch() {
    if (checked == 1) {
      checked = 0;
    } else if (checked == 0) {
      checked = 1;
    }
  }

  setLID(int curr) {
    lid = curr;
  }

  setTrue() {
    checked = 1;
  }

  setFalse() {
    checked = 0;
  }

  setBool(int newBoolValue) {
    checked = newBoolValue;
  }

  setItemValue(newItemValue) {
    itemValue = newItemValue;
  }

  Map<String, dynamic> toMap() {
    return {
      "taskId": taskId,
      "lid": lid,
      "description": itemValue,
      "check": checked
    };
  }

  @override
  String toString() {
    return "taskId $taskId, lid: $lid, description: $itemValue, day: $day, date: $date, check: $checked";
  }
}

var week = [
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday"
];

var weekAbbreviations = {
    'Monday': 'Mon',
    'Tuesday': 'Tue',
    'Wednesday': 'Wed',
    'Thursday': 'Thu',
    'Friday': 'Fri',
    'Saturday': 'Sat',
    'Sunday': 'Sun'
};

var month = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
];

var monthAbbreviations = {
  'January': 'Jan',
  'February': 'Feb',
  'March': 'Mar',
  'April': 'Apr',
  'May': 'May',
  'June': 'Jun',
  'July': 'Jul',
  'August': 'Aug',
  'September': 'Sep',
  'October': 'Oct',
  'November': 'Nov',
  'December': 'Dec'
};

List<dynamic> createWeek() {
  var weekindex = [-3, -2, -1, 0, 1, 2, 3];
  var currDayTime = DateTime.now();
  var currDay = DateFormat('EEEE').format(currDayTime);
  var currDate = DateFormat('MM.dd.yyyy').format(currDayTime);
  var index = week.indexWhere((day) => day == currDay);
  var res = [];

  try {
    for (int i = 0; i < 7; i++) {
      var currindex = index + weekindex[i];
      if (currindex < 0) {
        res.add([
          week[week.length + currindex],
          DateFormat('MM.dd.yyyy')
              .format(currDayTime.subtract(Duration(days: weekindex[i].abs())))
        ]);
      } else if (currindex == index) {
        res.add([week[index], currDate]);
      } else if (currindex >= 7) {
        res.add([
          week[currindex - weekindex.length],
          DateFormat('MM.dd.yyyy')
              .format(currDayTime.add(Duration(days: weekindex[i])))
        ]);
      } else {
        res.add([
          week[currindex],
          DateFormat('MM.dd.yyyy')
              .format(currDayTime.add(Duration(days: weekindex[i])))
        ]);
      }
    }
  } catch (e) {
    print("ERROR: $e");
  }
  return res;
}

List<dynamic> createMonth() {
  var monthIndex = [-3, -2, -1, 0, 1, 2, 3];
  var currDayTime = DateTime.now();
  var currMonth = DateFormat('MMMM').format(currDayTime);
  var currDate = DateFormat('MM.dd.yyyy').format(currDayTime);
  var index = month.indexWhere((month) => month == currMonth);
  var res = [];
  try {
    for (int i = 0; i < 7; i++) {
      var currindex = index + monthIndex[i];
      if (currindex < 0) {
        res.add([
          month[month.length + currindex],
          DateFormat('MM.dd.yyyy')
              .format(currDayTime.subtract(Duration(days: monthIndex[i].abs())))
        ]);
      } else if (currindex == index) {
        res.add([month[index], currDate]);
      } else if (currindex >= 12) {
        res.add([
          month[currindex - monthIndex.length],
          DateFormat('MM.dd.yyyy')
              .format(currDayTime.add(Duration(days: monthIndex[i])))
        ]);
      } else {
        res.add([
          month[currindex],
          DateFormat('MM.dd.yyyy')
              .format(currDayTime.add(Duration(days: monthIndex[i])))
        ]);
      }
    }
  } catch (e) {
    print("ERROR: $e");
  }
  return res;
}

int getDayInt(currday) {
  List<dynamic> week = createWeek();
  for (int i = 0; i < week.length; i++) {
    if (currday == week[i][0]) {
      return i;
    }
  }
  return 0;
}
