const forgotPasswordQuery = """
  mutation(\$input: ForgotPasswordInput!) {
    initiateForgotPasswordRequest(input: \$input){
      deliveryMedium
    }
  }
""";
