// import 'dart:developer';
// var newMap = {'checked': false, 'itemValue': ""};

class ItemHolder {
  late int curr;
  late List lst;

  ItemHolder() {
    curr = 0;
    lst = [];
  }

  addItems(day, itemValue, checked) {
    lst.add(ItemObj.arg(curr, day, itemValue, checked));
    curr++;
  }
}

class ItemObj {
  late int id;
  late String day;
  late String itemValue;

  // 0 == False and 1 == True
  late int checked;

  ItemObj() {
    itemValue = "";
    checked = 0;
  }

  ItemObj.arg(this.id, this.day, this.itemValue, this.checked);

  flipSwitch() {
    if (checked == 1) {
      checked = 0;
    } else if (checked == 0) {
      checked = 1;
    }
  }

  setTrue() {
    checked = 1;
  }

  setFalse() {
    checked = 0;
  }

  setBool(int newBoolValue) {
    checked = newBoolValue;
  }

  setItemValue(newItemValue) {
    itemValue = newItemValue;
  }

  Map<String, dynamic> toMap() {
    return {"id": id, "description": itemValue, "check": checked};
  }
}
