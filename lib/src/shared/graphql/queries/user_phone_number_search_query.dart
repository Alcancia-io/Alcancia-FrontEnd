const String userPhoneNumberSearchQuery = """
  query(\$searchUserByTelephoneNumberInput: SearchUserByTelephoneNumberInput!){
    searchUserByTelephoneNumber(input: \$searchUserByTelephoneNumberInput) {
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
