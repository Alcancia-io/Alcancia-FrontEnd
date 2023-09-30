import 'package:alcancia/src/shared/services/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tokenProvider = FutureProvider<String?>((ref) async {
  final StorageService storageService = StorageService();
  final token = await storageService.readSecureData("token");
  return token;
});
