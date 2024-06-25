import 'package:intl/intl.dart';

class MoneyService {
  String convert(int summa, int convertValue) {
    int rub = 0;
    int cop = 0;

    rub = summa ~/ convertValue;
    cop = summa % convertValue;


    final String formattedIntPart = NumberFormat('#,###', 'en_US')
        .format(int.tryParse(rub.toString()) ?? 0)
        .replaceAll(',', ' ');

    return '$formattedIntPart,$cop';
  }

  int convertToKopecks(String input) {
    String sanitizedInput = input.replaceAll(' ', '');

    int decimalIndex = sanitizedInput.indexOf(',');


    String integerPart = decimalIndex == -1
        ? sanitizedInput
        : sanitizedInput.substring(0, decimalIndex);

    String decimalPart = decimalIndex == -1
        ? '00'
        : sanitizedInput.substring(decimalIndex + 1).padRight(2, '0');


    String combined = integerPart + decimalPart;


    return int.parse(combined);
  }
}
