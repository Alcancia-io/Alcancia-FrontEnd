const String sendSuarmiOrderQuery = """
  query(\$orderInput:OrderInput!) {
    sendSuarmiOrder(orderInput:\$orderInput){
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
