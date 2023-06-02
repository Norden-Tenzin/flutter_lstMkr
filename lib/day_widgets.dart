import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lstmkr/database.dart';
import 'package:intl/intl.dart';

// my imps
import 'item.dart';
import 'helper.dart';

class DayWidget extends StatefulWidget {
  final String weekday;
  final String date;
  final ItemHolder page;
  const DayWidget(
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
    asyncMethod();
  }

  Future<void> asyncMethod() async {
    String weekday = widget.weekday;
    String weekdate = widget.date;
    db = DatabaseHelper();
    dynamic lst = await db.retrieveItem(weekday, weekdate);
    page.curr = await db.getCurr(weekday);
    setState(() {
      page.lst = lst;
      columnWidgets = createLst(page);
    });
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

  getWeekHeader(weekday, date) {
    var currDayTime = DateTime.now();
    var currDate = DateFormat('MM.dd.yyyy').format(currDayTime);
    if (currDate == date) {
      return Row(children: [
        const Text(
          "Today ",
          style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 50,
              fontWeight: FontWeight.bold),
        ),
        Text(
          "(${weekAbbreviations[weekday]})",
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

  Widget addButton() {
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
    List date_split = date.split(".");
    return Column(children: [
      Container(
          width: double.infinity,
          margin: const EdgeInsets.only(left: 10),
          child: getWeekHeader(weekday, date)),
      Container(
          width: double.infinity,
          margin: const EdgeInsets.only(left: 12),
          child: Text(
            "${date_split[0]}.${date_split[1]}",
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
  }
}
