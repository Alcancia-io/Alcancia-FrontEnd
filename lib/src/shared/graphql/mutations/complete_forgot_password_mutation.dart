const completeForgotPasswordMutation = """
  mutation complePassword(\$email: String!, \$newPassword: String!, \$verificationCode: String!) {
    completeForgotPassword(email: \$email, newPassword: \$newPassword, verificationCode: \$verificationCode)
  }
""";
