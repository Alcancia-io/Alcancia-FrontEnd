const String refreshTokenMutation = '''
mutation refreshToken(\$input: RefreshTokenInput!) {
  refreshToken(input: \$input) {
    token
  }
}
''';
