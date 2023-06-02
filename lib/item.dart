import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:msh_checkbox/msh_checkbox.dart';

// my imps
import 'helper.dart';
import 'database.dart';

class Item extends StatefulWidget {
  // final ItemController controller;
  final Function removeFunc;
  final ItemObj itemObj;
  final DatabaseHelper db;
  final bool active;
  const Item(
      {Key? key,
      // required this.controller,
      required this.itemObj,
      required this.removeFunc,
      required this.db,
      this.active = true})
      : super(key: key);

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  late TextEditingController editingController;

  // @override
  // void didUpdateWidget() {}

  @override
  void initState() {
    super.initState();
    // widget.controller.refresh = refresh;
    editingController = TextEditingController(text: widget.itemObj.itemValue);

    editingController.addListener(() {
      String text = editingController.text;
      widget.itemObj.setItemValue(text);
      widget.db.updateItem(widget.itemObj);
    });
  }

  @override
  void didUpdateWidget(covariant Item oldwidget) {
    super.didUpdateWidget(oldwidget);
    editingController.text = widget.itemObj.itemValue;
  }

  @override
  Widget build(BuildContext context) {
    int initIsChecked = widget.itemObj.checked;
    bool isChecked = initIsChecked == 1 ? true : false;
    return Column(children: [
      Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.only(top: 8, left: 10),
                child: MSHCheckbox(
                    size: 20,
                    value: isChecked,
                    // ignore: deprecated_member_use
                    checkedColor: Colors.orange,
                    style: MSHCheckboxStyle.fillFade,
                    onChanged: (selected) async {
                      if (widget.active) {
                        setState(() {
                          log("$selected");
                          isChecked = selected;
                          int val = selected == true ? 1 : 0;
                          widget.itemObj.setBool(val);
                          widget.db.updateItem(widget.itemObj);
                        });
                      }
                    })),
            widget.active
                ? Expanded(
                    child: CupertinoTextField(
                        enabled: widget.active,
                        placeholder: 'TODO',
                        cursorColor: Colors.orange,
                        controller: editingController,
                        maxLines: null,
                        style: const TextStyle(fontSize: 16),
                        decoration:
                            const BoxDecoration(color: CupertinoColors.white)))
                : Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(top: 8, left: 8),
                        child: Text(
                          widget.itemObj.itemValue,
                          style: const TextStyle(fontSize: 16),
                        ))),
            if (widget.active)
              SizedBox(
                  height: 30,
                  width: 30,
                  child: Transform.translate(
                      offset: const Offset(0, -5),
                      child: IconButton(
                          padding: const EdgeInsets.only(top: 10, right: 10),
                          icon: const Icon(Icons.clear, size: 25),
                          color: Colors.orange,
                          onPressed: () {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                        title: const Text('DEBUG DELETING'),
                                        content: const Text('Are you sure?'),
                                        actionsAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        actions: <Widget>[
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0),
                                              child: SizedBox(
                                                  width: 125,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.black,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, 'Naa');
                                                    },
                                                    child: const Text('Naa'),
                                                  ))),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5.0),
                                              child: SizedBox(
                                                  width: 125,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.orange,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, 'Yes');
                                                      editingController.clear();
                                                      widget.itemObj
                                                          .setItemValue("");
                                                      widget.removeFunc(
                                                          widget.itemObj);
                                                    },
                                                    child: const Text('Yes'),
                                                  )))
                                        ]));
                          })))
          ])
    ]);
  }
}
