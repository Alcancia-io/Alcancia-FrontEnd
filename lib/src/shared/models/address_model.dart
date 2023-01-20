class Address {
  Address({
    required this.street,
    required this.colonia,
    required this.extNum,
    required this.intNum,
    required this.state,
    required this.zip,
  });

  final String street;
  final String colonia;
  final String extNum;
  final String intNum;
  final String state;
  final String zip;

  String toJsonString() {
    return {"street": street, "colonia": colonia, "extNum": extNum, "intNum": intNum, "state": state, "zip": zip}
        .toString();
  }
}
