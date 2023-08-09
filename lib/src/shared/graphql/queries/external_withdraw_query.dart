const String externalWithdrawQuery = """
  query(\$amount: String!, \$receiverAddress) {
    alcanciaExternalWithdraw(amount: \$amount, receiverAddress: \$receiverAddress)
  }
""";
