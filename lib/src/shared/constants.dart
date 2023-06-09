import 'package:flutter/material.dart';

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

const alcanciaDOPInfo = {
  'Banco': 'Banreservas',
  'Beneficiario': 'BAPLTECH SRL',
  'RNC': '1-32-75385-2',
  'No. de cuenta': '9605734495'
};


const suarmiInfo = {
  'Cuenta': 'Sistema de Transferencias y Pagos (STP)',
  'Beneficiario': 'Bctech Solutions SAPI de CV',
  'CLABE': '646180204200011681'
};

const cryptopayFee = 1;
const suarmiFee = 2;

enum RiskLevel { alto, medio, bajo }

// investment info

class AssetDescription extends StatelessWidget {
  final String boldText;
  final String regularText;

  const AssetDescription(
      {super.key, required this.boldText, required this.regularText});

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: boldText,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: txtTheme.bodyText1?.color),
          ),
          TextSpan(text: regularText, style: txtTheme.bodyText1),
        ],
      ),
    );
  }
}

const usdcDescription =
    AssetDescription(boldText: 'USD Coin (USDC) ', regularText: '');
const usdcProtocolDescription =
    AssetDescription(boldText: 'Aave ', regularText: '');
const celoDescription =
    AssetDescription(boldText: 'Celo Dollar (cUSD) ', regularText: '');
const celoProtocolDescription =
    AssetDescription(boldText: 'Moola Market ', regularText: '');
