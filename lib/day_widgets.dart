import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lstmkr/database.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'dart:developer';

// my imps
import 'item.dart';
import 'helper.dart';
import 'home.dart';
import 'database.dart';

class DayWidget extends StatefulWidget {
  String weekday;
  String date;
  ItemHolder page;
  DayWidget(
      {Key? key,
      // required this.controller,
      required this.weekday,
      required this.date,
      required this.page})
      : super(key: key);

  @override
  State<DayWidget> createState() => _DayWidgetState();
}

class _DayWidgetState extends State<DayWidget> {
  List<Widget>? columnWidgets;
  late DatabaseHelper db;
  var page = ItemHolder();

  @override
  void initState() {
    super.initState();
    String weekday = widget.weekday;
    print("HERE1");
    asyncMethod();
    // asyncMethod(weekday).then((res) {
    //   page.lst = res;
    //   print(page.lst);
    //   columnWidgets = createLst(page);
    //   print(columnWidgets);
    // });

    // get the data for the day.
    // if data exists in db then use that data
    // otherwise create data and add to db
  }

  // Future<List<ItemObj>> asyncMethod(weekday) async {
  Future<void> asyncMethod() async {
    print("HERE2");
    String weekday = widget.weekday;
    String weekdate = widget.date;
    // print("Weekdate: ${weekdate}");
    // db.database();
    db = DatabaseHelper();
    print(db);
    print("HERE3");
    dynamic lst = await db.retrieveItem(weekday, weekdate);
    print("HERE4");
    page.curr = await db.getCurr(weekday);
    setState(() {
      // print(lst);
      page.lst = lst;
      columnWidgets = createLst(page);
    });
    print("HERE5");
  }

  addLst(page) {
    setState(() {
      page.addItems(db, ItemObj.weekday(widget.weekday, widget.date));
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

  getWeekAbrev(weekday) {
    var abrev = {
      "Monday": "Mon",
      "Tuesday": "Tue",
      "Wednesday": "Wed",
      "Thursday": "Thu",
      "Friday": "Fri",
      "Saturday": "Sat",
      "Sunday": "Sun"
    };
    return abrev[weekday];
  }

  getWeekHeader(weekday, date) {
    var currDayTime = DateTime.now();
    var currDate = DateFormat('yMd').format(currDayTime);
    if (currDate == date) {
      // "Today ${getWeekAbrev(weekday)}";
      return Row(children: [
        const Text(
          "Today ",
          style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 50,
              fontWeight: FontWeight.bold),
        ),
        Text(
          "(${getWeekAbrev(weekday)})",
          style: const TextStyle(
              color: Colors.orange, fontSize: 50, fontWeight: FontWeight.bold),
        )
      ]);
    } else {
      return Text(
        weekday,
        style: const TextStyle(
            color: Colors.orange, fontSize: 50, fontWeight: FontWeight.bold),
      );
    }
  }

  Widget addButton(){
    return InkWell(
        onTap: () {
          setState(() {
            addLst(page);
          });
        },
        child: Container(
          margin: const EdgeInsets.only(left: 10, top: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
            ],
          ),
        ),
      );
  }

  List<Widget> createLst(page) {
    var mapLst = page.lst;
    List<Widget> res = [];
    for (var i = 0; i < mapLst.length; i++) {
      res.add(Item(itemObj: mapLst[i], removeFunc: removeLst, db: db));
    }
    res.add(addButton());
    return res;
  }

  @override
  Widget build(BuildContext context) {
    String weekday = widget.weekday;
    String date = widget.date;
    return Column(children: [
      Container(
          width: double.infinity,
          margin: const EdgeInsets.only(left: 10),
          child: getWeekHeader(weekday, date)),
      Container(
          width: double.infinity,
          margin: const EdgeInsets.only(left: 12),
          child: Text(
            date,
            style: const TextStyle(
                color: CupertinoColors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold),
          )),
      Expanded(
        child: ListView(
          children: columnWidgets ?? [],
        ),
      ),
    ]);

    // return ListView(children: <Widget>[
    //   // WEEK text
    //   Container(
    //       width: double.infinity,
    //       margin: const EdgeInsets.only(left: 10),
    //       child: getWeekHeader(weekday, date)),
    //   // recurring items text
    //   Container(
    //       width: double.infinity,
    //       margin: const EdgeInsets.only(left: 12),
    //       child: Text(
    //         date,
    //         style: const TextStyle(
    //             color: CupertinoColors.black,
    //             fontSize: 25,
    //             fontWeight: FontWeight.bold),
    //       )),
    //   // item widgets
    //   Column(children: columnWidgets ?? []),
    //   // add item button
    //   InkWell(
    //     onTap: () {
    //       setState(() {
    //         addLst(page);
    //       });
    //     },
    //     child: Container(
    //       margin: const EdgeInsets.only(left: 10, top: 10),
    //       child: Row(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           SizedBox(
    //               height: 30,
    //               width: 30,
    //               child: Transform.translate(
    //                   offset: const Offset(-5, -7),
    //                   child: const Icon(
    //                     Icons.add,
    //                     color: Colors.orange,
    //                     size: 25,
    //                   ))),
    //           const Text(
    //             "Add item",
    //             style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    //           )
    //         ],
    //       ),
    //     ),
    //   )
    // ]);
  }
}
