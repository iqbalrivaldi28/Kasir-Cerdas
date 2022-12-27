import 'package:intl/intl.dart';

String rupiah(int amount) {
  return NumberFormat.currency(
    locale: 'id',
    name: 'Rp ',
    decimalDigits: 0,
  ).format(amount);
}
