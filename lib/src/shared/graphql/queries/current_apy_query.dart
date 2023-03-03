const String getCurrentAPYQuery = """
  query(\$token: String!) {
    getCurrentAPY(token: \$token)
  }
""";
