const String userPhoneNumberSearchQuery = """
  query(\$input: SearchUserByTelephoneNumberInput!){
    searchUserByTelephoneNumber(input: \$input) {
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
