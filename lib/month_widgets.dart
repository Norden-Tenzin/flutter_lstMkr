import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lstmkr/database.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
// import 'package:table_calendar/';
// my imps
import 'item.dart';
import 'helper.dart';
import 'calendar_date_cell.dart';
import 'calendar_focused_cell.dart';
import 'calendar_disabled_cell.dart';
import 'calender_helper.dart';
import 'calendar_selected_cell.dart';

class MonthWidget extends StatefulWidget {
  const MonthWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<MonthWidget> createState() => _MonthWidgetState();
}

class _MonthWidgetState extends State<MonthWidget> {
  late DatabaseHelper db;
  List<Widget>? columnWidgets;
  DateTime? _selectedDay;
  var page = ItemHolder();
  var _focusedDay = DateTime.now();
  final _firstDay = DateTime(DateTime.now().month);
  final _lastDay = DateTime(DateTime.now().year, DateTime.now().month + 1)
      .subtract(const Duration(days: 1));

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    if (_selectedDay != null) {
      asyncMethod(DateFormat('MM.dd.yyyy').format(_selectedDay!));
    }
  }

  Future<void> asyncMethod(weekdate) async {
    db = DatabaseHelper();
    dynamic lst = await db.getTasksList(weekdate);
    setState(() {
      page.lst = lst;
      columnWidgets = createLst(page);
    });
  }

  removeLst(item) async {
    db.deleteItem(item);
    setState(() {
      page.lst.removeWhere((i) => i.lid == item.lid);
      columnWidgets = createLst(page);
    });
  }

  addLst(page) {
    setState(() {
      page.addItems(
          db,
          ItemObj.weekday(week[_selectedDay!.weekday - 1],
              DateFormat('MM.dd.yyyy').format(_selectedDay!)));
      columnWidgets = createLst(page);
    });
  }

  Widget addButton() {
    return InkWell(
        onTap: () {
          setState(() {
            addLst(page);
          });
        },
        child: Container(
            margin: const EdgeInsets.only(left: 10, top: 10),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                  height: 30,
                  width: 30,
                  child: Transform.translate(
                      offset: const Offset(-5, -7),
                      child: const Icon(
                        Icons.add,
                        color: Colors.orange,
                        size: 25,
                      ))),
              const Text(
                "Add item",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              )
            ])));
  }

  List<Widget> createLst(page) {
    var mapLst = page.lst;
    List<Widget> res = [];
    for (var i = 0; i < mapLst.length; i++) {
      res.add(Item(
          itemObj: mapLst[i], removeFunc: removeLst, db: db, active: true));
    }
    res.add(addButton());
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(children: [
      Container(
          margin: const EdgeInsets.only(left: 10),
          width: double.infinity,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              monthAbbreviations[DateFormat("MMMM").format(_focusedDay)]!,
              style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 50,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              DateFormat("yyyy").format(_focusedDay),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 50,
                  fontWeight: FontWeight.bold),
            )
          ])),
      Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: TableCalendar(
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (isSameDay(selectedDay, _selectedDay)) {
                setState(() {
                  _focusedDay = focusedDay;
                  _selectedDay = null;
                  columnWidgets = [];
                });
              } else {
                setState(() {
                  _focusedDay = focusedDay;
                  _selectedDay = selectedDay;
                });
                asyncMethod(DateFormat('MM.dd.yyyy').format(selectedDay));
              }
            },
            onPageChanged: (focusedDay) {
              Provider.of<UserDetailsProvider>(context, listen: false).month =
                  monthAbbreviations[DateFormat("MMMM").format(focusedDay)]!;
              Provider.of<UserDetailsProvider>(context, listen: false).year =
                  DateFormat("yyyy").format(focusedDay);
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            headerVisible: false,
            firstDay: _firstDay,
            lastDay: _lastDay,
            focusedDay: _focusedDay,
            calendarBuilders: CalendarBuilders(
              selectedBuilder: (context, day, focusedDay) {
                return CalendarSelectedCell(date: day);
              },
              todayBuilder: (context, day, focusedDay) {
                return CalendarFocusedCell(date: day);
              },
              defaultBuilder: (context, day, focusedDay) {
                return CalendarDateCell(date: day);
              },
              outsideBuilder: (context, day, focusedDay) {
                return CalendarDisabledCell(date: day);
              },
              disabledBuilder: (context, day, focusedDay) {
                return CalendarDisabledCell(date: day);
              },
            ),
          )),
      Expanded(
        child: ListView(
          children: columnWidgets ?? [],
        ),
      ),
    ]));
  }
}
