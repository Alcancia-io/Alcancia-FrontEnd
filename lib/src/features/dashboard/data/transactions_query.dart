const String transactionsQuery = """
  query(\$userTransactionsInput: UserTransactionsInput!){
    getUserTransactions(getUserTransactionsInput: \$userTransactionsInput) {
      totalItems,
      items {
        createdAt,
        transactionID,
        sourceAmount,
        sourceAsset,
        targetAsset,
        amount,
        type
      }
    }
  }
""";
