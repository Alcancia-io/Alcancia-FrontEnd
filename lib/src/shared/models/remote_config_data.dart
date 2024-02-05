import 'dart:convert';

class RemoteConfigData {
  final bool minimumAppVersion;
  final DataObject doConfig;

  RemoteConfigData({
    required this.minimumAppVersion,
    required this.doConfig,
  });

  factory RemoteConfigData.fromJson(Map<String, dynamic> json) {
    return RemoteConfigData(
      minimumAppVersion: json['MinimumAppVersion'] ?? false,
      doConfig: DataObject.fromJson(json['DO'] ?? {}),
    );
  }
}

class DataObject {
  final bool enabled;
  final Map<String, Currency> currencies;

  DataObject({
    required this.enabled,
    required this.currencies,
  });

  factory DataObject.fromJson(Map<String, dynamic> json) {
    final currencies = json['Currencies'] ?? {};
    final currencyMap =
        currencies.map((key, value) => MapEntry(key, Currency.fromJson(value)));

    return DataObject(
      enabled: json['enabled'] ?? false,
      currencies: currencyMap,
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
    final banks = json['Banks'] ?? {};
    final bankMap =
        banks.map((key, value) => MapEntry(key, Bank.fromJson(value)));

    return Currency(
      enabled: json['enabled'] ?? false,
      currencyCode: json['currencyCode'] ?? '',
      icon: json['icon'] ?? '',
      minAmount: json['minAmount'] ?? 0,
      maxAmount: json['maxAmount'] ?? 0,
      banks: bankMap,
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
      enabled: json['enabled'] ?? false,
      info1: json['info1'] ?? '',
      info2: json['info2'] ?? '',
      info3: json['info3'] ?? '',
    );
  }
}
