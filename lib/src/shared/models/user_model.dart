import 'package:alcancia/src/shared/models/kyc_status.dart';
import 'package:alcancia/src/shared/models/transaction_model.dart';
import 'package:alcancia/src/shared/provider/balance_provider.dart';
import 'package:intl/intl.dart';

class User {
  final String id;
  final String authId;
  final String email;
  final String name;
  final String surname;
  final String gender;
  String country;
  String phoneNumber;
  final DateTime dob;
  Balance balance;
  String walletAddress;
  List<Transaction>? transactions;
  double userProfit;
  KYCStatus kycStatus;
  String? profession;
  String? address;
  String? lastUsedBankAccount;

  User({
    required this.id,
    required this.authId,
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
    required this.kycStatus,
    required this.profession,
    this.address,
    this.lastUsedBankAccount,
  });

  static final sampleUser = User(
    id: "",
    authId: "",
    surname: "",
    gender: "",
    country: "",
    phoneNumber: "",
    dob: DateTime.now(),
    name: "",
    email: "",
    balance: Balance(total: 0, aPolUSDC: 0, cUSD: 0, etherscan: 0, mcUSD: 0),
    walletAddress: "",
    kycStatus: KYCStatus.none,
    profession: "",
  );

  factory User.fromJSON(Map<String, dynamic> map) {
    return User(
      id: map["id"],
      authId: map["authId"],
      surname: map["surname"],
      gender: map["gender"],
      country: map["country"],
      phoneNumber: map["phoneNumber"],
      dob: DateFormat('yyyy-MM-dd').parse(map["dob"]),
      name: map["name"],
      email: map["email"],
      balance: Balance.fromMap(map['balance']),
      walletAddress: map['walletAddress'],
      kycStatus: KYCStatus.values.firstWhere((element) => element.name.toLowerCase() == map['kycStatus'].toString().toLowerCase(),  orElse: () => KYCStatus.none),
      profession: map["profession"],
      address: map["address"],
      lastUsedBankAccount: map["lastUsedBankAccount"]
    );
  }
}
