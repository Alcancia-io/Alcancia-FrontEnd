enum TransactionType { deposit, withdraw, p2p, unknown }

enum TransactionMethod { cryptopay, suarmi }

class TransactionInput {
  final TransactionMethod txnMethod;
  final TransactionType txnType;
  final double sourceAmount;
  final double targetAmount;
  final String? concept;
  final String targetCurrency;
  final String network;

  TransactionInput({
    required this.txnMethod,
    required this.txnType,
    required this.sourceAmount,
    required this.targetAmount,
    required this.targetCurrency,
    required this.network,
    this.concept,
  });
}
