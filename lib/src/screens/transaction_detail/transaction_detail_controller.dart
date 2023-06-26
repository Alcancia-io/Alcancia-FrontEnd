import 'package:alcancia/src/shared/services/services.dart';

class TransactionDetailController {
  TransactionsService transactionsService = TransactionsService();


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
}
