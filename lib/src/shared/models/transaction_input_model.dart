enum TransactionType { deposit, withdrawal }

enum TransactionMethod { cryptopay, suarmi }

class TransactionInput {
  TransactionInput({
    required this.txnMethod,
    required this.txnType,
    required this.sourceAmount,
    required this.targetAmount,
    this.concept,
  });

  final TransactionMethod txnMethod;
  final TransactionType txnType;
  final double sourceAmount;
  final double targetAmount;
  final String? concept;
}
