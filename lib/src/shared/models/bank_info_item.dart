class AccountInfo {
  final String bank;
  final String beneficiary;
  final String? rnc;
  final String? accountNumber;
  final String? clabe;

  AccountInfo._({required this.bank, required this.beneficiary, this.rnc, this.accountNumber, this.clabe});

  static AccountInfo DOPInfo = AccountInfo._(
    bank: "Banreservas",
    beneficiary: "BAPLTECH SRL",
    rnc: "1-32-75385-2",
    accountNumber: "9605734495",
  );

  static AccountInfo MXNInfo = AccountInfo._(
    bank: "Sistema de Transferencias y Pagos (STP)",
    beneficiary: "Bctech Solutions SAPI de CV",
    clabe: "646180204200011681",
  );
}
