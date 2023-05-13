const String transferFundsQuery = """
  query(\$transferData: TransferInput!){
    transferFunds(transferData: \$transferData) {
      amount,
      destWallet,
      srcUserId,
      token,
    }
  }
""";
