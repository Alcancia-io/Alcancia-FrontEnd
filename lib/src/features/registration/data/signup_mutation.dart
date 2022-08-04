const String signupMutation = """
  mutation(\$signupUserInput: CreateUserInput!) {
    signup(signupUserInput: \$signupUserInput) {
      userId,
      name,
      surname,
      email,
      phoneNumber,
      gender,
      dob,
    }
  }
""";