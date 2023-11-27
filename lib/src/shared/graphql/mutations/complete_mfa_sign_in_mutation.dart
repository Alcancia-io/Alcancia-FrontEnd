const String completeMFASignInMutation = '''
  mutation(\$completeMFASignInInput: CompleteMFASignInInput!) {
    completeMFASignIn(input: \$completeMFASignInInput) {
      accessToken,
      refreshToken,
      user {
        name,
        email
      }
    }
  }
''';
