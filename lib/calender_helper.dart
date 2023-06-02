import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserDetailsProvider extends ChangeNotifier {
  String? _month;
  String? _year;
  DateTime? _selectedDate;
  UserDetailsProvider(
      {required String month, required String year, required DateTime? selectedDate}) {
    _month = month;
    _year = year;
    _selectedDate = selectedDate;
    notifyListeners();
  }

  String get month => _month??"";
  String get year => _year??"";
  DateTime? get selectedDate => _selectedDate;

  set month(String newMonth) {
    _month = newMonth;
    notifyListeners();
  }

  set year(String newYear) {
    _year = newYear;
    notifyListeners();
  }

  set selectedDate(DateTime? newDate) {
    _selectedDate = newDate;
    notifyListeners();
  }
}
