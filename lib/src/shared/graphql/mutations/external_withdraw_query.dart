const String externalWithdrawQuery = """
  mutation(\$cryptoWithdrawalInput: CryptoWithdrawalInput!) {
    executeCryptoWithdrawal(input: \$cryptoWithdrawalInput) {
    amount,
    receiverAddress,
    senderAddress,
    token
    }
  }
""";
