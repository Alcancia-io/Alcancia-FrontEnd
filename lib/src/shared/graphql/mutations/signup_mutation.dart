const String signupMutation = """
  mutation(\$input: SignUpInput!) {
    signUp(input: \$input) {
      status
    }
  }
""";

const String confirmSignUpMutation = """
  mutation(\$input: ConfirmSignUpInput){
    confirmSignUp(input: \$input){
      status
    }
  }
""";

const String requestNewVerificationCodeMutation = """
  mutation(\$input: RequestNewVerificationCodeInput){
    requestNewVerificationCode(input: \$input){
      deliveryMedium
    }
  }
""";
