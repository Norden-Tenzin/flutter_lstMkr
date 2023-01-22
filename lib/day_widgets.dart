import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lstmkr/database.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:sqflite/sqflite.dart';

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

  List<Widget> createLst(page) {
    var mapLst = page.lst;
    List<Widget> res = [];

    for (var i = 0; i < mapLst.length; i++) {
      res.add(Item(itemObj: mapLst[i], removeFunc: removeLst, db: db));
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    String weekday = widget.weekday;
    return ListView(children: <Widget>[
      // monday text
      Container(
          width: double.infinity,
          margin: const EdgeInsets.only(left: 10),
          child: Text(
            weekday,
            style: const TextStyle(
                color: Colors.orange,
                fontSize: 50,
                fontWeight: FontWeight.bold),
          )),

      // recurring items text
      Container(
          width: double.infinity,
          margin: const EdgeInsets.only(left: 12),
          child: const Text(
            "Recurring Items",
            style: TextStyle(
                color: CupertinoColors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold),
          )),

      // item widgets
      Column(children: columnWidgets ?? []),

      // add item button
      InkWell(
        onTap: () {
          setState(() {
            addLst(page);
          });
        },
        child: Container(
          margin: const EdgeInsets.only(left: 10, top: 10, bottom: 150),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  child: Transform.scale(
                      alignment: const Alignment(0, -2),
                      scale: .8,
                      child: const Icon(
                        Icons.add,
                        color: Colors.orange,
                        size: 30,
                      ))),
              const Text(
                "Add item",
                style: TextStyle(fontSize: 15),
              )
            ],
          ),
        ),
      )
    ]);
  }
}
