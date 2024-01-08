const String completeMFASignInMutation = '''
  mutation(\$input: CompleteMFASignInInput!) {
    completeMFASignIn(input: \$input) {
      accessToken,
      refreshToken,
      user {
        name,
        email
      }
    }
  }
''';
