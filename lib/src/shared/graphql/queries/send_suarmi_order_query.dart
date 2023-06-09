const String sendUserTransactionQuery = """
  query(\$orderInput:OrderInput!) {
    sendUserTransaction(orderInput:\$orderInput){
      address,
      concepto,
      from_amount,
      from_currency,
      network,
      to_currency,
      uuid
    }
  }
""";
