import 'package:alcancia/src/shared/models/jwt_zendesk.dart';
import 'package:alcancia/src/shared/provider/balance_provider.dart';
import 'package:alcancia/src/shared/services/metamap_service.dart';
import 'package:alcancia/src/shared/services/referral_service.dart';
import 'package:alcancia/src/shared/services/services.dart';
import 'package:alcancia/src/shared/models/alcancia_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../shared/models/balance_history_model.dart';

class DashboardController {
  final MetamapService metaMapService = MetamapService();

  final metamapMexicanINEId = dotenv.env['MEXICO_INE_FLOW_ID'] as String;
  final metamapDomicanFlowId = dotenv.env['DOMINICAN_FLOW_ID'] as String;

  var userTransactionsInput = {
    "userTransactionsInput": {
      "currentPage": 0,
      "itemsPerPage": 10,
    },
  };

  Future<User> fetchUser() async {
    UserService userService = UserService();
    try {
      var response = await userService.getUser();
      if (response.data != null) {
        Map<String, dynamic> data = response.data!["getAuthenticatedUser"];
        final user = User.fromJSON(data);
        return user;
      }
    } catch (error) {
      return Future.error(error);
    }
    return Future.error('Error getting user');
  }

  Future<JWTZendesk> getUserToken() async {
    UserService userService = UserService();
    try {
      var response = await userService.getUserToken();
      if (response.data != null) {
        var resp = response.data!["getUserSupportToken"];
        final jwt = JWTZendesk.fromJson(resp);
        return jwt;
      }
    } catch (error) {
      return Future.error(error);
    }
    return Future.error('Error getting JWT');
  }

  Future<Balance> fetchUserBalance() async {
    UserService userService = UserService();
    var response = await userService.getUserBalance();
    if (response.data != null) {
      final balanceData = response.data!["getWalletBalance"];
      final balance = Balance.fromMap(balanceData);
      return balance;
    } else {
      return Future.error('Error getting balance: ${response}');
    }
  }

  Future<List<UserBalanceHistory>> fetchUserBalanceHistory() async {
    UserService userService = UserService();
    try {
      var response = await userService.getUserBalanceHisotry();
      if (response.data != null) {
        List<dynamic> balanceHistData = response.data!["getUserBalanceHistory"];
        if (balanceHistData != null) {
          final balanceHist = balanceHistData
              .map((data) => UserBalanceHistory.fromJson(data))
              .toList();
          return balanceHist;
        }
      }
    } catch (error) {
      return Future.error(error);
    }
    return Future.error('Error getting balance history');
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

  Future<User?> verifyUser(User user, AppLocalizations appLoc) async {
    if (user.country == "MX") {
      await metaMapService.showMatiFlow(metamapMexicanINEId, user.id, appLoc);
    } else if (user.country == "DO") {
      await metaMapService.showMatiFlow(metamapDomicanFlowId, user.id, appLoc);
    } else {
      return Future.error("Country not supported");
    }
    return await fetchUser();
  }

  Future<bool> campaignUserExists() async {
    UserService userService = UserService();
    var response = await userService.campaignUserExists();
    if (response.data != null) {
      final data = response.data!["campaignUserExists"];
      final exists = data as bool;
      return exists;
    } else {
      return Future.error('Error checking campaign: ${response}');
    }
  }

  Future<String> getReferralCode() async {
    ReferralService referralService = ReferralService();
    var response = await referralService.getReferralCode();
    if (response.data != null) {
      final data = response.data!["getReferralCode"];
      final code = data["code"] as String;
      return code;
    } else {
      return Future.error('Error getting referral: ${response}');
    }
  }
}
