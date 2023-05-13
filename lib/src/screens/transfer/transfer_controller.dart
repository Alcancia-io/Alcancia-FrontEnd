import 'package:alcancia/src/shared/models/alcancia_models.dart';
import 'package:alcancia/src/shared/services/services.dart';

class TransferController {
  final _exceptionHandler = ExceptionService();

  Future<MinimalUser> searchUser({required String phoneNumber}) async {
    UserService userService = UserService();
    try {
      final response = await userService.searchUserFromPhoneNumber(phoneNumber: phoneNumber);
      if (response.hasException) return Future.error("${_exceptionHandler.handleException(response.exception!)}");
      if (response.data != null) {
        Map<String, dynamic> data = response.data!["userPhoneNumberSearch"];
        print(data);
        final user = MinimalUser.fromJSON(data);
        return user;
      }
    } catch (error) {
      return Future.error(error);
    }
    return Future.error('Error getting user');
  }

  Future<TransferResponse> transferFunds({required String amount, required String destionationUserId, required String sourceUserId, required String token}) async {
    TransactionsService transactionService = TransactionsService();
    try {
      final transferInput = {
        "transferData": {
          "amount": amount,
          "destUserId": destionationUserId,
          "srcUserId": sourceUserId,
          "token": token,
        },
      };
      final response = await transactionService.transferFunds(transferInput);
      if (response.hasException) return Future.error("${_exceptionHandler.handleException(response.exception!)}");
      if (response.data != null) {
        Map<String, dynamic> data = response.data!["transferFunds"];
        print(data);
        final transferResponse = TransferResponse.fromJSON(data);
        return transferResponse;
      }
    } catch (error) {
      return Future.error(error);
    }
    return Future.error('Error transfering funds');
  }
}
