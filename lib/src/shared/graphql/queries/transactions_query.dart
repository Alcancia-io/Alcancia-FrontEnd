const String transactionsQuery = """
  query(\$userTransactionsInput: UserTransactionsInput!){
    getUserTransactions(getUserTransactionsInput: \$userTransactionsInput) {
      totalItems,
      items {
        ... on Transaction {
          createdAt,
          id,
          sourceAmount,
          sourceAsset,
          targetAsset,
          amount,
          type,
          status,
        }
        ... on P2P {
          createdAt,
          id,
          senderId,
          receiverId,
          amount,
          status,
        }
      }
    }
  }
""";
