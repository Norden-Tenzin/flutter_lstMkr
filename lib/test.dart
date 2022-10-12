import 'package:intl/intl.dart';

void main(List<String> args) {
  var date = DateTime.now();
  print(DateFormat('EEEE').format(date));
}
