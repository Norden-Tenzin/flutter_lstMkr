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
  const Item(
      {Key? key,
      // required this.controller,
      required this.itemObj,
      required this.removeFunc,
      required this.db})
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

  // void refresh() {
  //   int id = widget.itemObj.id;
  //   print("IN REFRESH $id");
  // }

  // @override
  // void dispose() {
  //   int id = widget.itemObj.id;
  //   print("IN DISPOSE $id");
  //   editingController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    int initIsChecked = widget.itemObj.checked;
    bool isChecked = initIsChecked == 1 ? true : false;
    return
        // Container(
        //     height: 50,
        //     padding: const EdgeInsets.only(left: 15, right: 10),
        //     child:
        Column(
      children: [
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.only(top: 8, left: 10),
                child: MSHCheckbox(
                    size: 20,
                    value: isChecked,
                    checkedColor: Colors.orange,
                    style: MSHCheckboxStyle.fillScaleColor,
                    onChanged: (selected) async {
                      setState(() {
                        log("$selected");
                        isChecked = selected;
                        int val = selected == true ? 1 : 0;
                        widget.itemObj.setBool(val);
                        widget.db.updateItem(widget.itemObj);
                      });
                    })),
            Expanded(
                child: CupertinoTextField(
                    placeholder: 'TODO',
                    controller: editingController,
                    maxLines: null,
                    decoration:
                        const BoxDecoration(color: CupertinoColors.white))),
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
                        editingController.clear();
                        widget.itemObj.setItemValue("");
                        widget.removeFunc(widget.itemObj);
                      })),
            ),
          ],
        ),
      ],
    );
    // );
  }
}
