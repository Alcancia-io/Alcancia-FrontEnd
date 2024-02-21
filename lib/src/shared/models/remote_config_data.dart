class RemoteConfigData {
  final Map<String, CountryConfig> countryConfig;

  RemoteConfigData({
    required this.countryConfig,
  });

  factory RemoteConfigData.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> countryConfigJson = json;
    final Map<String, CountryConfig> countryConfig = countryConfigJson.map(
      (key, value) => MapEntry(key, CountryConfig.fromJson(value)),
    );

    return RemoteConfigData(
      countryConfig: countryConfig.cast<String, CountryConfig>(),
    );
  }
}

class CountryConfig {
  final String icon;
  final bool enabled;
  final Map<String, Currency> currencies;
  final Map<String, CryptoCurrency> cryptoCurrencies;
  final List<String>? banksWithdraw;

  CountryConfig({
    required this.icon,
    required this.enabled,
    required this.currencies,
    required this.cryptoCurrencies,
    this.banksWithdraw,
  });

  factory CountryConfig.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> currenciesJson = json['Currencies'];
    final Map<String, Currency> currencies = currenciesJson.map(
      (key, value) => MapEntry(key, Currency.fromJson(value)),
    );

    final Map<String, dynamic> cryptoCurrenciesJson = json['crypto_currency'];
    final Map<String, CryptoCurrency> cryptoCurrencies =
        cryptoCurrenciesJson.map(
      (key, value) => MapEntry(key, CryptoCurrency.fromJson(value)),
    );

    final List<String> banksWithdraw =
        List<String>.from(json['banks_withdraw']);

    return CountryConfig(
      icon: json['icon'],
      enabled: json['enabled'],
      currencies: currencies.cast<String, Currency>(),
      cryptoCurrencies: cryptoCurrencies.cast<String, CryptoCurrency>(),
      banksWithdraw: banksWithdraw,
    );
  }
}

class CryptoCurrency {
  final bool enabled;
  final String icon;
  final int minAmount;
  final int maxAmount;
  final double depositRate;
  CryptoCurrency(
      {required this.enabled,
      required this.icon,
      required this.minAmount,
      required this.maxAmount,
      required this.depositRate});

  factory CryptoCurrency.fromJson(Map<String, dynamic> json) {
    return CryptoCurrency(
      enabled: json['enabled'],
      icon: json['icon'],
      minAmount: json['minAmount'],
      maxAmount: json['maxAmount'],
      depositRate: json['depositRate'] as double,
    );
  }
}

class Currency {
  final bool enabled;
  final String currencyCode;
  final String icon;
  final int minAmount;
  final int maxAmount;
  final double exchangeRate;
  final Map<String, Bank> banks;

  Currency({
    required this.enabled,
    required this.currencyCode,
    required this.icon,
    required this.minAmount,
    required this.maxAmount,
    required this.banks,
    required this.exchangeRate,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> banksJson = json['Banks'];
    final Map<String, Bank> banks = banksJson.map(
      (key, value) => MapEntry(key, Bank.fromJson(value)),
    );

    return Currency(
      enabled: json['enabled'],
      currencyCode: json['currencyCode'],
      icon: json['icon'],
      minAmount: json['minAmount'],
      maxAmount: json['maxAmount'],
      exchangeRate: json['exchangeRate'] as double,
      banks: banks.cast<String, Bank>(),
    );
  }
}

class Bank {
  final bool enabled;
  final String info1;
  final String info2;
  final String info3;
  final String info4;

  Bank({
    required this.enabled,
    required this.info1,
    required this.info2,
    required this.info3,
    required this.info4,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      enabled: json['enabled'],
      info1: json['info1'],
      info2: json['info2'],
      info3: json['info3'],
      info4: json['info4'],
    );
  }
}
