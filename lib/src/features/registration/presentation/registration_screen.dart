import 'package:alcancia/src/features/registration/data/country.dart';
import 'package:alcancia/src/features/registration/data/signup_mutation.dart';
import 'package:alcancia/src/shared/extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import '../data/gender.dart';
import 'gender_picker.dart';
import 'country_picker.dart';

class RegistrationScreen extends ConsumerWidget {
  RegistrationScreen({Key? key}) : super(key: key);

  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final obscurePasswordProvider =
      StateProvider.autoDispose<bool>((ref) => true);
  final obscureConfirmPasswordProvider =
      StateProvider.autoDispose<bool>((ref) => true);

  final selectedDateProvider =
      StateProvider.autoDispose<DateTime>((ref) => DateTime.now());
  final selectedCountryProvider =
      StateProvider.autoDispose<Country>((ref) => countries[0]);
  final selectedGenderProvider =
      StateProvider.autoDispose<Gender?>((ref) => null);

  var signupInput;

  bool validDate(DateTime date) {
    DateTime adultDate = DateTime(
      date.year + 18,
      date.month,
      date.day,
    );

    if (adultDate.isBefore(DateTime.now())) {
      return true;
    }
    return false;
  }

  bool passwordsMatch() {
    if (passwordController.text.isNotEmpty && passwordController.text == confirmPasswordController.text && passwordController.text.isValidPassword()) {
      return true;
    }
    return false;
  }

  bool isValid(Country country, Gender? gender, DateTime date) {
    final name = nameController.text;
    final lastName = lastNameController.text;
    final phone = phoneController.text;
    final email = emailController.text;
    return (name.isNotEmpty && lastName.isNotEmpty && phone.isNotEmpty && email.isValidEmail() && passwordsMatch() && gender != null && validDate(date));
  }

  setRegistrationInput(Country selectedCountry, Gender? selectedGender, DateTime selectedDate) {
    signupInput = {
      "name": nameController.text,
      "surname": lastNameController.text,
      "email": emailController.text,
      "phoneNumber": "${selectedCountry.dialCode}${phoneController.text}",
      "gender": selectedGender.string,
      "password": confirmPasswordController.text,
      "dob": DateFormat('dd/MM/yyyy').format(selectedDate)
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final obscurePassword = ref.watch(obscurePasswordProvider);
    final obscureConfirmPassword = ref.watch(obscureConfirmPasswordProvider);
    final appLocalization = AppLocalizations.of(context)!;
    final selectedCountry = ref.watch(selectedCountryProvider);
    final selectedGender = ref.watch(selectedGenderProvider);
    final selectedDate = ref.watch(selectedDateProvider);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding:
                  const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 32.0),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AlcanciaLogo(
                    height: size.height / 20,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "¡Hola!",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                    ),
                    Text(
                        "Completa la siguiente información para crear tu cuenta",
                        style: TextStyle(fontSize: 15)),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                LabeledTextFormField(
                  controller: nameController,
                  labelText: "Nombre(s)",
                  inputType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return appLocalization.errorRequiredField;
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                LabeledTextFormField(
                  controller: lastNameController,
                  labelText: "Apellido(s)",
                  inputType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return appLocalization.errorRequiredField;
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Celular"),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: CountryPicker(
                            selectedCountryProvider: selectedCountryProvider,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .inputDecorationTheme
                                    .fillColor,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: TextField(
                                style: Theme.of(context).textTheme.bodyText1,
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                AlcanciaDatePicker(
                  dateProvider: selectedDateProvider,
                  maximumDate: DateTime.now().add(const Duration(days: 1)),
                  validator: (selectedDate) {
                    if (selectedDate != null) {
                      DateTime adultDate = DateTime(
                        selectedDate.year + 18,
                        selectedDate.month,
                        selectedDate.day,
                      );

                      if (adultDate.isBefore(DateTime.now())) {
                        return null;
                      }
                      return "Necesitas ser mayor de 18 años de edad";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                GenderPicker(
                  selectedGenderProvider: selectedGenderProvider,
                  validator: (Gender? gender) {
                    if (selectedGender == null) return "Selecciona un género";
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                LabeledTextFormField(
                  controller: emailController,
                  labelText: "Correo electrónico",
                  inputType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return appLocalization.errorRequiredField;
                    } else {
                      return value.isValidEmail()
                          ? null
                          : appLocalization.errorEmailFormat;
                    }
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                LabeledTextFormField(
                  controller: passwordController,
                  labelText: "Contraseña",
                  obscure: obscurePassword,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      ref.read(obscurePasswordProvider.notifier).state =
                          !obscurePassword;
                    },
                    child: Icon(obscurePassword
                        ? CupertinoIcons.eye
                        : CupertinoIcons.eye_fill),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return appLocalization.errorRequiredField;
                    } else {
                      return value.isValidPassword()
                          ? null
                          : appLocalization
                              .errorInvalidPassword; // TODO: Password validation text
                    }
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                LabeledTextFormField(
                  controller: confirmPasswordController,
                  labelText: "Confirmar contraseña",
                  obscure: obscureConfirmPassword,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      ref.read(obscureConfirmPasswordProvider.notifier).state =
                          !obscureConfirmPassword;
                    },
                    child: Icon(obscureConfirmPassword
                        ? CupertinoIcons.eye
                        : CupertinoIcons.eye_fill),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return appLocalization.errorRequiredField;
                    } else if (value != passwordController.text) {
                      return appLocalization.errorPasswordMatch; // TODO: Confirm password validation text
                    }
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Mutation(
                  options: MutationOptions(
                    document: gql(signupMutation),
                    onCompleted: (resultData) {
                      if (resultData != null) {
                        context.go("/login");
                      }
                    },
                  ),
                  builder: (
                    MultiSourceResult<Object?> Function(Map<String, dynamic>,
                            {Object? optimisticResult})
                        runMutation,
                    QueryResult<Object?>? result,
                  ) {
                    print(result);
                    if (result != null) {
                      if (result.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (result.hasException) {
                        return Column(
                          children: [
                            AlcanciaButton(
                              () {
                                setRegistrationInput(selectedCountry, selectedGender, selectedDate);
                                if (isValid(selectedCountry, selectedGender, selectedDate)) {
                                  runMutation(
                                    {"signupUserInput": signupInput},
                                  );
                                }
                              },
                              "Siguiente",
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                result.exception!.graphqlErrors.first.message,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 12),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                    return AlcanciaButton(
                      ()  {

                        setRegistrationInput(selectedCountry, selectedGender, selectedDate);
                        if (isValid(selectedCountry, selectedGender, selectedDate)) {
                          runMutation(
                            {"signupUserInput": signupInput},
                          );
                        }
                      },
                      "Siguiente",
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
