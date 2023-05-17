import 'package:intl/intl.dart';

extension LocalIso on DateTime {
  String formattedLocalString() {
    return DateFormat("yyyy-MM-dd hh:mm a").format(toLocal());
  }
}
