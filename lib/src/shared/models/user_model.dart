import 'package:alcancia/src/shared/models/kyc_status.dart';
import 'package:alcancia/src/shared/models/transaction_model.dart';
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
  String walletAddress;
  List<Transaction>? transactions;
  double userProfit;
  KYCStatus kycStatus;
  String? profession;
  String? address;
  String? lastUsedBankAccount;
  String? referralCode;

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
    required this.walletAddress,
    this.userProfit = 0,
    required this.kycStatus,
    required this.profession,
    this.address,
    this.lastUsedBankAccount,
    this.referralCode,
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
    walletAddress: "",
    kycStatus: KYCStatus.none,
    profession: "",
    referralCode: null,
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
      walletAddress: map['walletAddress'],
      kycStatus: KYCStatus.values.firstWhere((element) => element.name.toLowerCase() == map['kycStatus'].toString().toLowerCase(),  orElse: () => KYCStatus.none),
      profession: map["profession"],
      address: map["address"],
      lastUsedBankAccount: map["lastUsedBankAccount"],
    );
  }
}
