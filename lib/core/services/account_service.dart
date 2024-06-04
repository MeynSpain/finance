import 'package:finance/core/models/account_model.dart';

class AccountService {
  int getTotalBalance(List<AccountModel> accounts) {
    int totalBalance = 0;

    for (var account in accounts) {
      if (account.isAccountedInTotalBalance ?? true) {
        totalBalance += account.balance;
      }
    }

    return totalBalance;
  }
}
