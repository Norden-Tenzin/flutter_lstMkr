import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// my imps
import 'helper.dart';
import 'day_widgets.dart';

enum Sky { midnight, viridian, cerulean }

Map<Sky, Color> skyColors = <Sky, Color>{
  Sky.midnight: const Color(0xff191970),
  Sky.viridian: const Color(0xff40826d),
  Sky.cerulean: const Color(0xff007ba7),
};

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
  Sky _selectedSegment = Sky.midnight;
  late PageController pageController;

  List<Widget> createDayWidgets() {
    List<dynamic> week = createWeek();
    print("WEEK: $week");
    List<Widget> res = [];
    for (dynamic i in week) {
      res.add(DayWidget(weekday: i[0], date: i[1], page: page));
    }
    return res;
  }

  var page = ItemHolder();

  @override
  void initState() {
    super.initState();
    var curr_daytime = DateTime.now();
    var curr_day = DateFormat('EEEE').format(curr_daytime);
    pageController = PageController(initialPage: getDayInt(curr_day));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.white,
        navigationBar: const CupertinoNavigationBar(
            backgroundColor: CupertinoColors.black,
            middle: Text(
              'LstMkr.',
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.white),
            )),
        child: SizedBox(
            width: double.infinity,
            child: Material(
                color: CupertinoColors.black,
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      children: [
                        // cupertino slider
                        // Container(
                        //     width: double.infinity,
                        //     padding: const EdgeInsets.only(
                        //         left: 5, right: 5, top: 5),
                        //     child: CupertinoSlidingSegmentedControl<Sky>(
                        //         backgroundColor: CupertinoColors.systemGrey2,
                        //         // thumbColor: skyColors[_selectedSegment]!,
                        //         // This represents the currently selected segmented control.
                        //         groupValue: _selectedSegment,
                        //         // Callback that sets the selected segmented control.
                        //         onValueChanged: (Sky? value) {
                        //           if (value != null) {
                        //             setState(() {
                        //               _selectedSegment = value;
                        //             });
                        //           }
                        //         },
                        //         children: const <Sky, Widget>{
                        //           Sky.midnight: Padding(
                        //               padding:
                        //                   EdgeInsets.symmetric(horizontal: 20),
                        //               child: Text(
                        //                 'Day',
                        //                 style: TextStyle(
                        //                     color: CupertinoColors.black,
                        //                     fontSize: 20,
                        //                     fontWeight: FontWeight.bold),
                        //               )),
                        //           Sky.cerulean: Padding(
                        //               padding:
                        //                   EdgeInsets.symmetric(horizontal: 20),
                        //               child: Text(
                        //                 'Month',
                        //                 style: TextStyle(
                        //                     color: CupertinoColors.black,
                        //                     fontSize: 20,
                        //                     fontWeight: FontWeight.bold),
                        //               ))
                        //         })),
                        // the list part
                        Expanded(
                          child: PageView(
                            controller: pageController,
                            children: createDayWidgets(),
                          ),
                        )
                      ],
                    )))));
  }
}
