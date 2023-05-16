const String transferFundsQuery = """
  query(\$transferData: TransferInput!){
    transferFunds(transferData: \$transferData) {
      amount,
      destWallet,
      token,
      createdAt,
      destPhoneNumber,
      destUserName,
      id
    }
  }
""";
