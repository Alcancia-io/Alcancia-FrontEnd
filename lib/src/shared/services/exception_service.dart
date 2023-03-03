import 'package:graphql_flutter/graphql_flutter.dart';

class CustomException implements Exception {
  String message;

  CustomException(this.message);
}

class ExceptionService {
  handleLinkException(LinkException? linkException) {
    if (linkException is NetworkException) return linkException.message;
    if (linkException is HttpLinkServerException) return linkException.parsedResponse!.errors![0].message;
    if (linkException is ServerException) return linkException.originalException.message;
  }

  String? handleException(OperationException? exception) {
    if (exception != null) {
      if (exception.graphqlErrors.isNotEmpty) {
        return exception.graphqlErrors[0].message;
      }
      if (exception.linkException != null) {
        return handleLinkException(exception.linkException);
      }
    }
    return null;
  }
}
