import 'package:alcancia/src/shared/services/referral_service.dart';

class ReferralController {
  final _referralService = ReferralService();

  Future<bool> subscribeToCampaign({String? code}) async {
    final response = await _referralService.subscribeToCampaign(code: code);
    if (response.data != null) {
      final data = response.data!["subscribeToCampaign"];
      return data;
    } else {
      return Future.error('Error subscribing to campaign: ${response}');
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
