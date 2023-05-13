class MinimalUser {
  final String id;
  final String email;
  final String name;
  final String surname;
  String phoneNumber;
  String walletAddress;


  MinimalUser({
    required this.id,
    required this.surname,
    required this.phoneNumber,
    required this.name,
    required this.email,
    required this.walletAddress,
  });

  factory MinimalUser.fromJSON(Map<String, dynamic> map) {
    return MinimalUser(
        id: map["id"],
        surname: map["surname"],
        phoneNumber: map["phoneNumber"],
        name: map["name"],
        email: map["email"],
        walletAddress: map['walletAddress'],
    );
  }
}
