import 'package:alcancia/src/shared/models/transaction_model.dart';
import 'package:alcancia/src/shared/services/services.dart';

class TransactionDetailController {
  TransactionsService transactionsService = TransactionsService();

  final userTransactionsInput = {
    "userTransactionsInput": {
      "currentPage": 0,
      "itemsPerPage": 10,
    },
  };

  Future<void> cancelTransaction({required String id}) async {
    final response = await transactionsService.cancelTransaction(id);
    if (response.hasException) {
      return Future.error(response.exception.toString());
    } else if (response.data != null) {
      final data = response.data!;
      print(data);
      return;
    }
    return Future.error("Unknown error");
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
}
