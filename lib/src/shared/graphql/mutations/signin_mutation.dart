const String signInMutation = """
  mutation(\$signInInput: SignInInput!) {
    signIn(input: \$signInInput) {
      token,
      type
    }
  }
""";
