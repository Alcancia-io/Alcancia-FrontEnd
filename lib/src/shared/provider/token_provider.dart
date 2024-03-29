import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alcancia/src/shared/services/storage_service.dart';

final tokenProvider = FutureProvider<String?>((ref) async {
  final StorageService storageService = StorageService();
  final token = await storageService.readSecureData("token");
  return token;
});
