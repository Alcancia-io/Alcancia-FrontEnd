import 'package:alcancia/src/shared/models/transaction_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionsProvider = StateProvider<List<Transaction>>((ref) => []);
