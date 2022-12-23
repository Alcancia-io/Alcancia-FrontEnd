const String meQuery = """
  query {
    me {
      authId,
      surname,
      gender,
      country,
      phoneNumber,
      dob,
      name,
      email,
      balance,
      walletAddress,
      kycStatus,
      id
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
