const String executeP2PTransferMutation = """
  mutation(\$input: P2pTransferInput!){
    executep2pTransfer(input: \$input) {
      amount,
      createdAt,
      id,
      receiverId,
      receiverLastName,
      receiverName,
      senderId,
      token
    }
  }
""";
