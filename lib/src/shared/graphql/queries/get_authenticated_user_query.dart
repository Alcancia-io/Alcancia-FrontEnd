const String getAuthenticatedUserQuery = """
  query {
    getAuthenticatedUser {
      id,
      authId,
      surname,
      gender,
      country,
      phoneNumber,
      dob,
      name,
      email,
      walletAddress,
      kycStatus,
      profession,
      address,
      lastUsedBankAccount,
    }
  }
""";
