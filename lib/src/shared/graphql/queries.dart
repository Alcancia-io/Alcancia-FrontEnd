const String meQuery = """
  query {
    me {
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
""";
const String isAuthenticated = """
  query {
    isUserAuthenticated
  }
""";

const String userProfit = """
  query{
    getUserProfit
  }
""";
const String userBalance = """
  query{
    getWalletBalance
  }
""";
