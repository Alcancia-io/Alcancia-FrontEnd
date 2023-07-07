import 'package:shared_preferences/shared_preferences.dart';

class OnboardingController {
  Future<bool> finishOnboarding() async {
    final preferences = await SharedPreferences.getInstance();
    return await preferences.setBool("finishedOnboarding", true);
  }
}
