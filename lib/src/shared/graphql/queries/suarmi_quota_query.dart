const String suarmiQuota = """
  query(\$quoteInput: QuoteInput!) {
    getSuarmiQuote(quoteInput: \$quoteInput){
      to_amount
    }
  }
""";
