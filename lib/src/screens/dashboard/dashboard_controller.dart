import 'package:alcancia/src/shared/provider/balance_provider.dart';
import 'package:alcancia/src/shared/services/services.dart';
import 'package:alcancia/src/shared/models/alcancia_models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashboardController {
  var userTransactionsInput = {
    "userTransactionsInput": {
      "currentPage": 0,
      "itemsPerPage": 20,
    },
  };

  Future<User> fetchUser() async {
    UserService userService = UserService();
    try {
      var response = await userService.getUser();
      if (response.data != null) {
        Map<String, dynamic> data = response.data!["me"];
        final user = User.fromJSON(data);
        return user;
      }
    } catch (error) {
      return Future.error(error);
    }
    return Future.error('Error getting user');
  }

  Future<Balance> fetchUserBalance() async {
    UserService userService = UserService();
    try {
      var response = await userService.getUserBalance();
      if (response.data != null) {
        final balanceData = response.data!["getWalletBalance"];
        final balance = Balance.fromMap(balanceData);
        return balance;
      }
    } catch (error) {
      return Future.error(error);
    }
    return Future.error('Error getting balance');
  }

  Future<List<Transaction>> fetchUserTransactions() async {
    TransactionsService transactionsService = TransactionsService();
    try {
      var response = await transactionsService.getUserTransactions(
        userTransactionsInput,
      );
      if (response.data != null) {
        Map<String, dynamic> data = response.data!["getUserTransactions"];
        final txns = transactionsService.getTransactionsFromJson(data);
        return txns;
      }
    } catch (error) {
      return Future.error(error);
    }
    return Future.error('Error getting transactions');
  }

  Future<UserInformationModel> fetchUserInformation() async {
    try {
      var user = await fetchUser();
      var txns = await fetchUserTransactions();
      return UserInformationModel(
        user: user,
        txns: txns,
      );
    } catch (error) {
      return Future.error(error);
    }
  }

  String displayKycStatus(String? status, AppLocalizations appLoc) {
    // user has completed the process
    if (status == 'PENDING') return appLoc.labelStatusProcessing;
    if (status == 'FAILED') return appLoc.labelStatusRejected;
    if (status == 'VERIFIED') return appLoc.labelStatusSuccessful;

    // user hasn't done any verfication
    return appLoc.labelStatusNotStarted;
  }
}
