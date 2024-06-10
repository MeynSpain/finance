class MoneyService {
  String convert(int summa, int convertValue) {
    int rub = 0;
    int cop = 0;

    rub = summa ~/ convertValue;
    cop = summa % convertValue;

    return '$rub,$cop';
  }
}
