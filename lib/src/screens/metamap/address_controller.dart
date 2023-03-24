import 'package:alcancia/src/shared/models/user_model.dart';
import 'package:alcancia/src/shared/services/user_service.dart';

class AddressController {
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
}