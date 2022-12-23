const String signupMutation = """
  mutation(\$signupUserInput: CreateUserInput!) {
    signup(signupUserInput: \$signupUserInput) {
      id,
      authId
      name,
      surname,
      email,
      phoneNumber,
      gender,
      dob,
      country,
    }
  }
""";
