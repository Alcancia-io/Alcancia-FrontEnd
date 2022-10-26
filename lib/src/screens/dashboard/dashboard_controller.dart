import 'package:alcancia/src/shared/services/services.dart';
import 'package:alcancia/src/shared/models/alcancia_models.dart';

class DashboardController {
  final UserService userService = UserService();
  final TransactionsService transactionsService = TransactionsService();

  var userTransactionsInput = {
    "userTransactionsInput": {
      "currentPage": 0,
      "itemsPerPage": 3,
    },
  };

  Future<User> fetchUser() async {
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

  Future<List<Transaction>> fetchUserTransactions() async {
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
}
