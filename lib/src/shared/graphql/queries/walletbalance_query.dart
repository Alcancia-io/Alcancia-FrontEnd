const String balanceQuery = """
  query {
    getWalletBalance {
      total,
      aPolUSDC,
      mcUSD,
      cUSD,
      etherscan
    }
  }
""";
