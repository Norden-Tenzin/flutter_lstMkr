import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// my imps
import 'helper.dart';
import 'day_widgets.dart';
import 'month_widgets.dart';

class SegmentedControlApp extends StatelessWidget {
  const SegmentedControlApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      theme: CupertinoThemeData(brightness: Brightness.light),
      localizationsDelegates: <LocalizationsDelegate<dynamic>>[
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
      ],
      home: SegmentedControlExample(),
    );
  }
}

class SegmentedControlExample extends StatefulWidget {
  // final ItemController controller = ItemController();
  const SegmentedControlExample({super.key});

  @override
  State<SegmentedControlExample> createState() =>
      _SegmentedControlExampleState();
}

class _SegmentedControlExampleState extends State<SegmentedControlExample> {
  late PageController pageController;

  List<Widget> createDayWidgets() {
    List<dynamic> week = createWeek();
    List<Widget> res = [];
    for (dynamic i in week) {
      res.add(DayWidget(weekday: i[0], date: i[1], page: page));
    }
    return res;
  }

  var page = ItemHolder();
  var isWeek = true;

  @override
  void initState() {
    super.initState();
    var currDaytime = DateTime.now();
    var currDay = DateFormat('EEEE').format(currDaytime);
    pageController = PageController(initialPage: getDayInt(currDay));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.white,
        navigationBar: CupertinoNavigationBar(
          backgroundColor: CupertinoColors.black,
          leading: GestureDetector(
              onTap: () {
                setState(() {
                  isWeek = !isWeek;
                });
              },
              child: isWeek
                  ? Image.asset(
                      "assets/month.png",
                      width: 35,
                      height: 35,
                    )
                  : Image.asset(
                      "assets/week.png",
                      width: 35,
                      height: 35,
                    )),
          middle: const Text(
            'LstMkr.',
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.white),
          ),
          // trailing: GestureDetector(
          //     onTap: () {
          //       showModalBottomSheet<void>(
          //           context: context,
          //           backgroundColor: Colors.transparent,
          //           builder: (BuildContext context) {
          //             return Container(
          //                 height: 600,
          //                 decoration: const BoxDecoration(
          //                     color: Colors.white,
          //                     borderRadius: BorderRadius.only(
          //                         topRight: Radius.circular(10.0),
          //                         topLeft: Radius.circular(10.0))),
          //                 child: Center(
          //                     child: Column(children: <Widget>[
          //                   Row(
          //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                     children: [
          //                       const TextButton(
          //                           onPressed: null, child: Text("Save")),
          //                       const Text(
          //                         "Settings",
          //                         style: TextStyle(
          //                             fontSize: 20,
          //                             fontWeight: FontWeight.bold),
          //                       ),
          //                       IconButton(
          //                           padding: const EdgeInsets.only(
          //                               top: 5),
          //                           icon: const Icon(Icons.clear, size: 25),
          //                           color: Colors.orange,
          //                           onPressed: () => Navigator.pop(context))
          //                     ],
          //                   )
          //                   // const Text('Modal BottomSheet'),
          //                   // ElevatedButton(
          //                   //   child: const Text('Close BottomSheet'),
          //                   //   onPressed: () => Navigator.pop(context),
          //                   // )
          //                 ])));
          //           });
          //     },
          //     child: Image.asset(
          //       "assets/gear.png",
          //       width: 30,
          //       height: 30,
          //     )),
        ),
        child: Material(
            color: CupertinoColors.black,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Column(children: [
                  isWeek
                      ? Expanded(
                          child: PageView(
                            controller: pageController,
                            children: createDayWidgets(),
                          ),
                        )
                      : const MonthWidget()
                ]))));
  }
}
