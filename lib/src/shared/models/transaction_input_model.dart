enum TransactionType { deposit, withdrawal }

enum TransactionMethod { cryptopay, suarmi }

class TransactionInput {
  final TransactionMethod txnMethod;
  final TransactionType txnType;
  final double sourceAmount;
  final double targetAmount;
  final String? concept;
  final String targetCurrency;

  TransactionInput({
    required this.txnMethod,
    required this.txnType,
    required this.sourceAmount,
    required this.targetAmount,
    required this.targetCurrency,
    this.concept,
  });
}
