import 'package:alcancia/src/shared/provider/token_provider.dart';
import 'package:alcancia/src/shared/services/auth_service.dart';
import 'package:alcancia/src/shared/services/graphql_client_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';



final authServiceProvider = Provider<AuthService>((ref) {
  final service = ref.watch(graphQLServiceProvider);
  return AuthService(graphQLService: service);
});