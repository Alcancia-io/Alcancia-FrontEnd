import 'dart:convert';

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

  CountryConfig({
    required this.icon,
    required this.enabled,
    required this.currencies,
  });

  factory CountryConfig.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> currenciesJson = json['Currencies'];
    final Map<String, Currency> currencies = currenciesJson.map(
      (key, value) => MapEntry(key, Currency.fromJson(value)),
    );

    return CountryConfig(
      icon: json['icon'],
      enabled: json['enabled'],
      currencies: currencies.cast<String, Currency>(),
    );
  }
}

class Currency {
  final bool enabled;
  final String currencyCode;
  final String icon;
  final int minAmount;
  final int maxAmount;
  final Map<String, Bank> banks;

  Currency({
    required this.enabled,
    required this.currencyCode,
    required this.icon,
    required this.minAmount,
    required this.maxAmount,
    required this.banks,
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
      banks: banks.cast<String, Bank>(),
    );
  }
}

class Bank {
  final bool enabled;
  final String info1;
  final String info2;
  final String info3;

  Bank({
    required this.enabled,
    required this.info1,
    required this.info2,
    required this.info3,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      enabled: json['enabled'],
      info1: json['info1'],
      info2: json['info2'],
      info3: json['info3'],
    );
  }
}
