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

const cryptopayInfo = {'Banco': 'Banco de reservas', 'Beneficiario': 'Cryptopay SLR', 'Cuenta': '9602915498'};

const suarmiInfo = {
  'Cuenta': 'Sistema de Transferencias y Pagos (STP)',
  'Beneficiario': 'Bctech Solutions SAPI de CV',
  'CLABE': '646180204200011681'
};

const cryptopayFee = 1;
const suarmiFee = 2;

enum RiskLevel { alto, medio, bajo }

// investment info

const usdcAsset = """
Esta moneda digital es emitida por Circle, una empresa global de tecnología financiera que ayuda a mover el dinero a la velocidad de Internet y que es soportada de continuas auditorias y pruebas de reserva para continuar garantizando su paridad con el dólar estadounidense. Su valor está respaldado por una reserva de activos, como dólares estadounidenses, bonos del Tesoro estadounidense y otros activos estables.
\nLa idea detrás de USDC es proporcionar una moneda digital estable y confiable que se pueda usar para transacciones y pagos, sin la volatilidad que a menudo se asocia con otras criptomonedas.
""";

const usdcProtocol = """
es un protocolo de finanzas descentralizadas que permite a las personas que tienen fondos adicionales pueden conectarse con las personas que necesitan pedir prestado esos fondos.
\nLa plataforma utiliza contratos inteligentes para garantizar que todas las transacciones sean seguras y transparentes, y que los prestatarios y prestamistas estén protegidos.
\nAave permite a los usuarios ganar intereses en sus depósitos, al tiempo que brinda a los prestatarios acceso a términos de préstamo más flexibles y mejores tasas de interés en comparación con las plataformas de préstamos tradicionales. 
""";

const celoAsset = """
es una moneda estable que fue desarrollada por Celo.org, una plataforma de tecnología financiera que busca mejorar la inclusión financiera a través de la tecnología blockchain.
cUSD funciona de manera similar a otras monedas estables, como Tether o USDC, que están diseñadas para mantener su valor, esto significa que 1 cUSD siempre tendrá un valor aproximado de 1 dólar estadounidense.
\nLa idea detrás de cUSD es proporcionar una moneda digital estable y fácil de usar que se pueda utilizar para transacciones y pagos, sin la volatilidad que a menudo se asocia con otras criptomonedas.
""";

const celoProtocol = """
es una plataforma descentralizada que permite conectar personas que necesitan pedir dinero prestado con personas que tienen fondos adicionales para prestar.
\nLa plataforma utiliza contratos inteligentes para garantizar que todas las transacciones sean seguras y transparentes, y que los prestatarios y prestamistas estén protegidos. 
\nEn general, Moola Market es una forma en que las personas pueden acceder a la liquidez y ganar intereses sobre sus tenencias de moneda digital, sin tener que pasar por un banco o institución financiera tradicional.
""";

class AssetDescription extends StatelessWidget {
  final String boldText;
  final String regularText;

  const AssetDescription({super.key, required this.boldText, required this.regularText});

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: boldText,
            style: TextStyle(fontWeight: FontWeight.bold, color: txtTheme.bodyText1?.color),
          ),
          TextSpan(text: regularText, style: txtTheme.bodyText1),
        ],
      ),
    );
  }
}

const usdcDescription = AssetDescription(boldText: 'USD Coin (USDC) ', regularText: usdcAsset);
const usdcProtocolDescription = AssetDescription(boldText: 'Aave ', regularText: usdcProtocol);
const celoDescription = AssetDescription(boldText: 'Celo Dollar (cUSD) ', regularText: celoAsset);
const celoProtocolDescription = AssetDescription(boldText: 'Moola Market ', regularText: celoProtocol);
