import 'package:alcancia/src/shared/models/transaction_model.dart';
import 'package:intl/intl.dart';

class User {
  final String userId;
  final String email;
  final String name;
  final String surname;
  final String gender;
  final String country;
  String phoneNumber;
  final DateTime dob;
  final double balance;
  String walletAddress;
  List<Transaction>? transactions;
  double userProfit;

  User({
    required this.userId,
    required this.surname,
    required this.gender,
    required this.country,
    required this.phoneNumber,
    required this.dob,
    required this.name,
    required this.email,
    required this.balance,
    required this.walletAddress,
    this.userProfit = 0,
  });

  factory User.fromJSON(Map<String, dynamic> map) {
    return User(
      userId: map["userId"],
      surname: map["surname"],
      gender: map["gender"],
      country: map["country"],
      phoneNumber: map["phoneNumber"],
      dob: DateFormat('yyyy-MM-dd').parse(map["dob"]),
      name: map["name"],
      email: map["email"],
      balance: map['balance'].toDouble(),
      walletAddress: map['walletAddress'],
    );
  }
}
