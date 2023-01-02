const String meQuery = """
  query {
    me {
      authId,
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
""";

const String userProfitQuery = """
  query{
    getUserProfit
  }
""";

const String isAuthenticated = """
  query {
    isUserAuthenticated
  }
""";
