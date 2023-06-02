import 'package:flutter/material.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
//
import 'home.dart';
import 'calender_helper.dart';
import 'helper.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) =>
          UserDetailsProvider(month: monthAbbreviations[DateFormat('MMMM').format(DateTime.now())]!, year: DateFormat('yyyy').format(DateTime.now()), selectedDate: null),
      child: const MaterialApp(home: SegmentedControlApp())));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isChecked = false;
  bool isDisabled = false;
  MSHCheckboxStyle style = MSHCheckboxStyle.stroke;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MSHCheckbox Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('MSHCheckbox Example')),
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: MSHCheckbox(
                  size: 100,
                  value: isChecked,
                  isDisabled: isDisabled,
                  checkedColor: Colors.blue,
                  uncheckedColor: Colors.black12,
                  style: style,
                  onChanged: (selected) {
                    setState(() {
                      isChecked = selected;
                    });
                  },
                ),
              ),
            ),
            Container(
              height: 150,
              color: Colors.blue,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    control(
                      "Disabled",
                      Switch(
                        value: isDisabled,
                        activeColor: Colors.white,
                        onChanged: (value) => setState(() {
                          isDisabled = value;
                        }),
                      ),
                    ),
                    control(
                      "Style",
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: DropdownButton<MSHCheckboxStyle>(
                              isDense: true,
                              iconEnabledColor: Colors.grey,
                              dropdownColor: Colors.white,
                              underline: Container(),
                              items: MSHCheckboxStyle.values
                                  .map(
                                    (style) => DropdownMenuItem(
                                      value: style,
                                      child: Text(
                                        style.name(),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              value: style,
                              onChanged: (style) => setState(() {
                                if (style != null) {
                                  this.style = style;
                                }
                              }),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget control(String title, Widget control) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        control,
      ],
    );
  }
}

extension StyleName on MSHCheckboxStyle {
  String name() {
    switch (this) {
      case MSHCheckboxStyle.stroke:
        return "Stroke";
      case MSHCheckboxStyle.fillScaleColor:
        return "Scale Color";
      case MSHCheckboxStyle.fillScaleCheck:
        return "Scale Check";
      case MSHCheckboxStyle.fillFade:
        return "Fade";
    }
  }
}

