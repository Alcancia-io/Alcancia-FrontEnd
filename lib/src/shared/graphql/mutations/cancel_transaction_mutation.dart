const cancelTransactionMutation = """
  mutation(\$id: String!){
    cancelTransaction(id: \$id){
      amount,
      clearedDate,
      conversionRate,
      createdAt,
      currentBalance,
      id,
      method,
      newBalance,
      paymentGatewayID,
      receiverId,
      senderId,
      sourceAmount,
      sourceAsset,
      status,
      targetAsset,
      txnHash,
      type,
      userID,
      provider,
    }
  }
""";
