const String loginMutation = """
  mutation(\$loginUserInput: LoginUserInput!) {
    login(loginUserInput: \$loginUserInput) {
      access_token,
      user {
        userId,
        surname,
        gender,
        phoneNumber,
        dob,
        name,
        email,
        balance,
        walletAddress
      }
    }
  }
""";
