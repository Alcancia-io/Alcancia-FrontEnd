const String transactionsQuery = """
  query(\$userTransactionsInput: UserTransactionsInput!){
    getUserTransactions(getUserTransactionsInput: \$userTransactionsInput) {
      totalItems,
      items {
          createdAt,
          id,
          sourceAmount,
          sourceAsset,
          targetAsset,
          amount,
          type,
          status,
          senderId,
          receiverId,
      }
    }
  }
""";
