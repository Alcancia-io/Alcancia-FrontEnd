const String userPhoneNumberSearchQuery = """
  query(\$phoneNumber: String!){
    userPhoneNumberSearch(phoneNumber: \$phoneNumber) {
      id,
      surname,
      phoneNumber,
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
