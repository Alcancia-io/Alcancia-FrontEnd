const String loginMutation = """
  mutation(\$loginUserInput: LoginUserInput!) {
    login(loginUserInput: \$loginUserInput) {
      access_token,
      user {
        authId,
        name,
        surname,
        gender,
        phoneNumber,
        email,
        dob,
        id
        
      }
    }
  }
""";
