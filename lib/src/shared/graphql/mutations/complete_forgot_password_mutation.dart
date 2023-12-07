const completeForgotPasswordMutation = """
  mutation(\$input: CompleteForgotPasswordInput!) {
    completeForgotPasswordRequest(input: \$input){
      status
    }
  }
""";
