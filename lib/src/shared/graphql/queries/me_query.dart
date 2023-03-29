const String meQuery = """
  query {
    me {
      id,
      authId,
      surname,
      gender,
      country,
      phoneNumber,
      dob,
      name,
      email,
      balance {
        total,
        aPolUSDC,
        mcUSD,
        cUSD,
        etherscan
      },
      walletAddress,
      kycStatus,
      profession,
      address,
      lastUsedBankAccount,
    }
  }
""";
