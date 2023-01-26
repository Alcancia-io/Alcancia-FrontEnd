const dominicanBanks = [
  {'name': 'Banco Santa Cruz'},
  {'name': 'Banco Popular'},
  {'name': 'Banco de reservas'},
  {'name': 'Scotiabank'},
  {'name': 'Banco BHD'},
  {'name': 'Banco Promerica'},
  {'name': 'Banco Lopez de Haro'},
  {'name': 'Asociación popular'},
];

const cryptopayInfo = {'Banco': 'Banco de reservas', 'Beneficiario': 'Cryptopay SLR', 'Cuenta': '9602915498'};

const suarmiInfo = {
  'Cuenta': 'Sistema de Transferencias y Pagos (STP)',
  'Beneficiario': 'Bctech Solutions SAPI de CV',
  'CLABE': '646180204200011681'
};

const cryptopayFee = 1;
const suarmiFee = 2;

enum RiskLevel { alto, medio, bajo }
