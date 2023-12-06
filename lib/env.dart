import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Environment { stage, prod }

class Env {
  static var environment = dotenv.env['ENV'] as String;
  static var firebaseAndroidApiKey = dotenv.env['FIREBASE_ANDROID_API_KEY'] as String;
  static var firebaseIosApiKey = dotenv.env['FIREBASE_IOS_API_KEY'] as String;
  static var firebaseAppIdAndroid = dotenv.env['FIREBASE_ANDROID_APP_ID'] as String;
  static var firebaseAppIdIos = dotenv.env['FIREBASE_IOS_APP_ID'] as String;
  static var firebaseMessageSenderId = dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] as String;
  static var firebaseProjectId = dotenv.env['FIREBASE_PROJECT_ID'] as String;
  static var firebaseStorageBucket = dotenv.env['FIREBASE_STORAGE_BUCKET'] as String;
  static var firebaseIosClientId = dotenv.env['FIREBASE_IOS_CLIENT_ID'] as String?;
  static var firebaseIosBundleId = dotenv.env['FIREBASE_IOS_BUNDLE_ID'] as String;
}
