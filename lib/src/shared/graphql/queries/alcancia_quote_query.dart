const String getAlcanciaQuoteQuery = """
  query(\$quoteInput: AlcanciaQuoteInput!) {
    getAlcanciaQuote(quoteInput: \$quoteInput){
      buyRate,
      sellRate,
      exchange
    }
  }
""";
