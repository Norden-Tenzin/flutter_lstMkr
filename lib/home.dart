import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:msh_checkbox/msh_checkbox.dart';

// my imps
import 'item.dart';
import 'helper.dart';

enum Sky { midnight, viridian, cerulean }

Map<Sky, Color> skyColors = <Sky, Color>{
  Sky.midnight: const Color(0xff191970),
  Sky.viridian: const Color(0xff40826d),
  Sky.cerulean: const Color(0xff007ba7),
};

// void main() => runApp(const SegmentedControlApp());

// class ItemController {
//   // late void Function() refresh;
// }

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
  final europeanCountries = [
    'Albania',
    'Andorra',
    'Armenia',
    'Austria',
    'Azerbaijan',
    'Belarus',
    'Belgium',
    'Bosnia and Herzegovina',
    'Bulgaria',
    'Croatia',
    'Cyprus'
  ];
  late List<Widget> columnWidgets;
  var page = ItemHolder();
  bool isChecked = true;

  @override
  void initState() {
    super.initState();
    columnWidgets = createLst(page);
  }

  addLst(page) {
    setState(() {
      page.addItems("", "", 0);
      columnWidgets = createLst(page);
    });
  }

  removeLst(curr) {
    setState(() {
      page.lst.removeWhere((item) => item.id == curr);
      columnWidgets = createLst(page);
    });
  }

  List<Widget> createLst(page) {
    var mapLst = page.lst;
    List<Widget> res = [];

    for (var i = 0; i < mapLst.length; i++) {
      res.add(Item(
        itemObj: mapLst[i],
        removeFunc: removeLst,
      ));
    }
    return res;
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
        child: Material(
            color: CupertinoColors.black,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: ListView(children: <Widget>[
                  Container(
                      padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                      child: CupertinoSlidingSegmentedControl<Sky>(
                          backgroundColor: CupertinoColors.systemGrey2,
                          // thumbColor: skyColors[_selectedSegment]!,
                          // This represents the currently selected segmented control.
                          groupValue: _selectedSegment,
                          // Callback that sets the selected segmented control.
                          onValueChanged: (Sky? value) {
                            if (value != null) {
                              setState(() {
                                _selectedSegment = value;
                              });
                            }
                          },
                          children: const <Sky, Widget>{
                            Sky.midnight: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  'Day',
                                  style: TextStyle(
                                      color: CupertinoColors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                            Sky.cerulean: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  'Month',
                                  style: TextStyle(
                                      color: CupertinoColors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ))
                          })),
                  Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: const Text(
                        "Monday",
                        style: TextStyle(
                            color: Colors.orange,
                            fontSize: 50,
                            fontWeight: FontWeight.bold),
                      )),
                  Container(
                      margin: const EdgeInsets.only(left: 12),
                      child: const Text(
                        "Recurring Items",
                        style: TextStyle(
                            color: CupertinoColors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      )),
                  Column(children: columnWidgets),
                  InkWell(
                    onTap: () {
                      setState(() {
                        addLst(page);
                      });
                    },
                    child: Container(
                      margin:
                          const EdgeInsets.only(left: 10, top: 10, bottom: 150),
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
                ]))));
  }
}
