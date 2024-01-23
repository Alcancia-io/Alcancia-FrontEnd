const String updateAuthenticatedUserMutation = """
  mutation(\$updateAuthenticatedUserInput: UpdateAuthenticatedUserInput!) {
    updateAuthenticatedUser(input: \$updateAuthenticatedUserInput){
      id
    }
  }
""";
