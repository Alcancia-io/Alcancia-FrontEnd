import 'package:alcancia/src/features/registration/model/user_registration_model.dart';
import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/extensions/string_extensions.dart';
import 'package:alcancia/src/shared/models/kyc_status.dart';
import 'package:alcancia/src/shared/provider/balance_provider.dart';
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

final emailsInUseProvider = StateProvider<List<String>>((ref) => []);

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
        appBar: AlcanciaToolbar(
          toolbarHeight: size.height / 13,
          state: StateToolbar.logoLetters,
          logoHeight: size.height / 16,
        ),
        body: SafeArea(
          bottom: false,
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: ListView(
              padding:
                  const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 32.0),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appLocalization.labelHello,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 35),
                    ),
                    Text(appLocalization.labelRegisterSubtitle,
                        style: const TextStyle(fontSize: 15)),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                LabeledTextFormField(
                  controller: nameController,
                  labelText: appLocalization.labelName,
                  inputType: TextInputType.name,
                  autofillHints: const [AutofillHints.givenName],
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
                  labelText: appLocalization.labelLastName,
                  inputType: TextInputType.name,
                  autofillHints: const [AutofillHints.familyName],
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
                      return appLocalization.errorAge;
                    }
                    return appLocalization.labelSelectDate;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                GenderPicker(
                  selectedGenderProvider: selectedGenderProvider,
                  validator: (Gender? gender) {
                    if (selectedGender == null)
                      return appLocalization.errorSelectGender;
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                LabeledTextFormField(
                  controller: emailController,
                  labelText: appLocalization.labelEmail,
                  inputType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (unavailableEmails.contains(value)) {
                      return appLocalization.errorEmailInUse;
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
                  labelText: appLocalization.labelPassword,
                  obscure: obscurePassword,
                  autofillHints: const [AutofillHints.newPassword],
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
                  labelText: appLocalization.labelConfirmPassword,
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
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                AlcanciaButton(
                  buttonText: appLocalization.buttonNext,
                  color: alcanciaLightBlue,
                  width: 304,
                  height: 64,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final user = User(
                        id: "",
                        authId: "",
                        name: nameController.text,
                        surname: lastNameController.text,
                        email: emailController.text,
                        gender: selectedGender.string(appLocalization),
                        phoneNumber: "",
                        dob: selectedDate,
                        walletAddress: "",
                        country: '',
                        profession: '',
                        kycStatus: KYCStatus.none,
                      );
                      if (isValid(selectedGender, selectedDate)) {
                        context.push("/phone-registration",
                            extra: UserRegistrationModel(
                                user: user, password: passwordController.text));
                      }
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
