import 'package:alcancia/src/shared/models/suarmi_order_model.dart';
import 'package:alcancia/src/shared/models/transaction_input_model.dart';

class CheckoutModel {
  final SuarmiOrder order;
  final TransactionInput txnInput;

  const CheckoutModel({required this.order, required this.txnInput});
}