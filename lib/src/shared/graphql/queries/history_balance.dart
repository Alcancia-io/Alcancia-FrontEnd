const String historyBalanceQuery = """
  query {
    getUserBalanceHistory{
      balance,
      id,
      createdAt
    }
  }
""";
