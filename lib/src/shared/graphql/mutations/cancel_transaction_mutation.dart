const String cancelTransactionMutation = """
  mutation(\$id: String!) {
    cancelTransaction(id: \$id) {
      id
    }
  }
""";
