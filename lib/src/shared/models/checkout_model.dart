import 'package:alcancia/src/shared/models/remote_config_data.dart';
import 'package:alcancia/src/shared/models/suarmi_order_model.dart';
import 'package:alcancia/src/shared/models/transaction_input_model.dart';

class CheckoutModel {
  final AlcanciaOrder order;
  final TransactionInput txnInput;
  final Map<String, String>? bank;

  const CheckoutModel({
    required this.order,
    required this.txnInput,
    this.bank,
  });
}
