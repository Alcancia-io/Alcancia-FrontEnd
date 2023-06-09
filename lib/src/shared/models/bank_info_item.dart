class BankInfoItem {
  final String label;
  final String value;
  final bool copyable;

  BankInfoItem({required this.label, required this.value, required this.copyable});

  static List<BankInfoItem> DOPInfo = [
    BankInfoItem(label: "Banco", value: "Banreservas", copyable: false),
    BankInfoItem(label: "Beneficiario", value: "BAPLTECH SRL", copyable: false),
    BankInfoItem(label: "RNC", value: "1-32-75385-2", copyable: true),
    BankInfoItem(label: "No. de cuenta", value: "9605734495", copyable: true),
  ];

  static List<BankInfoItem> MXNInfo = [
    BankInfoItem(label: "Cuenta", value: "Sistema de Transferencias y Pagos (STP)", copyable: false),
    BankInfoItem(label: "Beneficiario", value: "Bctech Solutions SAPI de CV", copyable: true),
    BankInfoItem(label: "CLABE", value: "646180204200011681", copyable: true)
  ];
}
