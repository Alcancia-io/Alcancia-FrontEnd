import 'dart:developer';

import 'package:graphql_flutter/graphql_flutter.dart';

class ExceptionService {
  handleLinkException(LinkException? linkException) {
    if (linkException is NetworkException) return linkException.message;
    if (linkException is HttpLinkServerException) return linkException.parsedResponse!.response.toString();
    if (linkException is ServerException) return linkException.originalException.message;
    if (linkException is OperationException) return linkException?.originalException.toString();
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
