const forgotPasswordQuery = """
  query(\$email: String!) {
    forgotPassword(email: \$email)
  }
""";
