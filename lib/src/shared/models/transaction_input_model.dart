enum TransactionType { deposit, withdrawal }

enum TransactionMethod { cryptopay, suarmi }

class TransactionInput {
  TransactionInput({
    required this.txnMethod,
    required this.txnType,
    required this.quantity,
  });

  final TransactionMethod txnMethod;

  final TransactionType txnType;

  final double quantity;
}
