const String externalWithdrawQuery = """
  query(\$amount: String!, \$receiverAddress: String!) {
    alcanciaExternalWithdraw(amount: \$amount, receiverAddress: \$receiverAddress) {
    amount,
    receiverAddress,
    senderAddress,
    token,
    senderId
    }
  }
""";
