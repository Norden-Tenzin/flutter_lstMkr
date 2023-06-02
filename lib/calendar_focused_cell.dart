import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database.dart';

class CalendarFocusedCell extends StatefulWidget {
  final DateTime date;
  const CalendarFocusedCell({
    Key? key,
    required this.date,
  }) : super(key: key);

  @override
  _CalendarFocusedCellState createState() => _CalendarFocusedCellState();
}

class _CalendarFocusedCellState extends State<CalendarFocusedCell> {
  late DatabaseHelper db;
  String dateText = "";
  var taskCount = 0;

  @override
  void initState() {
    super.initState();
    dateText = DateFormat("dd").format(widget.date);
    asyncMethod();
  }

  Future<void> asyncMethod() async {
    db = DatabaseHelper();
    String date = DateFormat('MM.dd.yyyy').format(widget.date);
    int count = await db.getTasksCount(date);
    setState(() {
      taskCount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2.5, right: 2.5, bottom: 5),
      child: Stack(children: [
        Container(
            constraints: const BoxConstraints.expand(),
            decoration: const BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: Center(child: Text(dateText))),
        if (taskCount > 0)
          Positioned(
              right: 3,
              top: 3,
              child: Container(
                  height: 10,
                  width: 10,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white)))
      ]),
    );
  }
}
