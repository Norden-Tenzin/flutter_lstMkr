import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

void main(List<String> args) {
  var week = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  var weekindex = [-3, -2, -1, 0, 1, 2, 3];

  createDay() {
    var curr_daytime = DateTime.now();
    // DateFormat('yMd').format(curr_daytime.add(const Duration(days: )));
    var curr_day = DateFormat('EEEE').format(curr_daytime);
    var curr_date = DateFormat('yMd').format(curr_daytime);
    var res = [];
    var index = week.indexWhere((day) => day == curr_day);
    for (int i = 0; i < weekindex.length; i++) {
      var currindex = index + weekindex[i];
      print(currindex);
      if (currindex < 0) {
        res.add([
          week[week.length + currindex],
          DateFormat('yMd')
              .format(curr_daytime.subtract(Duration(days: weekindex[i].abs())))
        ]);
      } else if (currindex == index) {
        res.add([week[index], curr_date]);
      } else {
        res.add([
          week[currindex],
          DateFormat('yMd')
              .format(curr_daytime.add(Duration(days: weekindex[i])))
        ]);
      }
    }

    print(res);
    // print(week[week.length - index] == "Sunday");
  }

  createDay();
}
