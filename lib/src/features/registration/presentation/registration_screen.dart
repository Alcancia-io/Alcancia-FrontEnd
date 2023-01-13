import 'package:alcancia/src/features/registration/model/user_registration_model.dart';
import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/models/user_model.dart';
import '../data/gender.dart';
import 'gender_picker.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';

final emailsInUseProvider = StateProvider((ref) => [""]);

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  final selectedDateProvider =
      StateProvider.autoDispose<DateTime>((ref) => DateTime.now());
  final selectedGenderProvider =
      StateProvider.autoDispose<Gender?>((ref) => null);

  var signupInput;

  final _formKey = GlobalKey<FormState>();

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
    if (passwordController.text.isNotEmpty &&
        passwordController.text == confirmPasswordController.text &&
        passwordController.text.isValidPassword()) {
      return true;
    }
    return false;
  }

  bool isValid(Gender? gender, DateTime date) {
    final name = nameController.text;
    final lastName = lastNameController.text;
    final email = emailController.text;
    return (name.isNotEmpty &&
        lastName.isNotEmpty &&
        email.isValidEmail() &&
        passwordsMatch() &&
        gender != null &&
        validDate(date));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appLocalization = AppLocalizations.of(context)!;
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedGender = ref.watch(selectedGenderProvider);
    final unavailableEmails = ref.watch(emailsInUseProvider);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: ListView(
              padding:
                  const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 32.0),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AlcanciaToolbar(
                    state: StateToolbar.logoLetters,
                    logoHeight: size.height / 12,
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
                  autofillHints: [AutofillHints.givenName],
                  textInputAction: TextInputAction.next,
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
                  autofillHints: [AutofillHints.familyName],
                  textInputAction: TextInputAction.next,
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
                  autofillHints: [AutofillHints.email],
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (unavailableEmails.contains(value)) {
                      return "Este correo ya esta en uso.";
                    }
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
                  autofillHints: [AutofillHints.newPassword],
                  textInputAction: TextInputAction.next,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
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
                  textInputAction: TextInputAction.done,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        obscureConfirmPassword = !obscureConfirmPassword;
                      });
                    },
                    child: Icon(obscureConfirmPassword
                        ? CupertinoIcons.eye
                        : CupertinoIcons.eye_fill),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return appLocalization.errorRequiredField;
                    } else if (value != passwordController.text) {
                      return appLocalization
                          .errorPasswordMatch; // TODO: Confirm password validation text
                    }
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                AlcanciaButton(
                  buttonText: "Siguiente",
                  color: alcanciaLightBlue,
                  width: 304,
                  height: 64,
                  onPressed: () {
                    final user = User(
                      id: "",
                      authId: "",
                      name: nameController.text,
                      surname: lastNameController.text,
                      email: emailController.text,
                      gender: selectedGender.string,
                      phoneNumber: "",
                      dob: selectedDate,
                      balance: 0.0,
                      walletAddress: "",
                      country: '',
                    );
                    if (isValid(selectedGender, selectedDate)) {
                      context.push("/phone-registration",
                          extra: UserRegistrationModel(
                              user: user, password: passwordController.text));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
