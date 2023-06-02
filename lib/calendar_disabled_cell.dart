import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database.dart';

class CalendarDisabledCell extends StatefulWidget {
  final DateTime date;
  const CalendarDisabledCell({
    Key? key,
    required this.date,
  }) : super(key: key);

  @override
  _CalendarDisabledCellState createState() => _CalendarDisabledCellState();
}

class _CalendarDisabledCellState extends State<CalendarDisabledCell> {
  late DatabaseHelper db;
  String date_text = "";
  var taskCount = 0;

  @override
  void initState() {
    super.initState();
    date_text = DateFormat("dd").format(widget.date);
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
        child: Stack(
          children: [
            Container(
                constraints: const BoxConstraints.expand(),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 240, 240, 240),
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                child: Center(
                    child: Text(
                  date_text,
                  style: const TextStyle(color: Colors.grey),
                ))),
            if (taskCount > 0)
              Positioned(
                  right: 3,
                  top: 3,
                  child: Container(
                      height: 10,
                      width: 10,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white)))
          ],
        ));
  }
}
