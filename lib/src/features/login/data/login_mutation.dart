const String loginMutation = """
  mutation(\$loginUserInput: LoginUserInput!) {
    login(loginUserInput: \$loginUserInput) {
      access_token,
      user {
        userId,
        name,
        surname,
        gender,
        phoneNumber,
        email,
        dob
        
      }
    }
  }
""";
