import 'package:alcancia/src/shared/extensions/string_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart' as user_fire;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fx_stepper/fx_stepper.dart';
import 'package:go_router/go_router.dart';
import '../../features/registration/data/gender.dart';
import '../../features/registration/model/user_registration_model.dart';
import '../../features/registration/presentation/gender_picker.dart';
import '../../features/registration/presentation/registration_screen.dart';
import '../../resources/colors/app_theme.dart';
import '../../resources/colors/colors.dart';
import '../../shared/components/alcancia_components.dart';
import '../../shared/components/alcancia_toolbar.dart';
import '../../shared/models/kyc_status.dart';
import '../../shared/models/user_model.dart' as user_model;
import '../../shared/services/responsive_service.dart';

class RegistrationStepper extends ConsumerStatefulWidget {
  const RegistrationStepper({Key? key, required this.registrationParam})
      : super(key: key);
  final RegistrationParam registrationParam;
  @override
  ConsumerState<RegistrationStepper> createState() =>
      _RegistrationStepperState();
}

class _RegistrationStepperState extends ConsumerState<RegistrationStepper> {
  int currentStep = 0;
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

  final _formKeyBirth = GlobalKey<FormState>();
  final _formKeyGender = GlobalKey<FormState>();
  final _formKeyPass = GlobalKey<FormState>();
  final _formNameReg = GlobalKey<FormState>();
  final _formLastReg = GlobalKey<FormState>();
  final _formBirthReg = GlobalKey<FormState>();
  final _formGenderReg = GlobalKey<FormState>();
  final _formEmailReg = GlobalKey<FormState>();
  final _formPassReg = GlobalKey<FormState>();

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
    return (passwordsMatch() && gender != null && validDate(date));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appLocalization = AppLocalizations.of(context)!;
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedGender = ref.watch(selectedGenderProvider);
    final ResponsiveService responsiveService = ResponsiveService();
    final screenHeight = size.height;
    final screenWidth = size.width;

    return Scaffold(
      appBar: AlcanciaToolbar(
        toolbarHeight: size.height / 13,
        state: StateToolbar.logoLetters,
        logoHeight: size.height / 16,
      ),
      body: Theme(
        data: (MediaQuery.of(context).platformBrightness == Brightness.light)
            ? AlcanciaTheme.lightTheme
            : AlcanciaTheme.darkTheme,
        child: FxStepper(
          type: FxStepperType.horizontal,
          steps: widget.registrationParam.isCompleteRegistration == true
              ? getStepsCompleteRegistration(
                  appLocalization, selectedDate, selectedGender)
              : getSteps(appLocalization, selectedDate, selectedGender),
          currentStep: currentStep,
          onStepContinue: () {
            if (widget.registrationParam.isCompleteRegistration != true) {
              //Condiciones que solo aplican para Stepper Thirdparty signIn
              if (!validDate(selectedDate) && currentStep == 0) {
                return;
              }
              if (selectedGender == null && currentStep == 1) {
                return;
              }
            }
            var isLastStep = false;
            if (widget.registrationParam.isCompleteRegistration != true) {
              isLastStep = currentStep ==
                  getSteps(appLocalization, selectedDate, selectedGender)
                          .length -
                      1;
            } else {
              isLastStep = currentStep ==
                  getStepsCompleteRegistration(
                              appLocalization, selectedDate, selectedGender)
                          .length -
                      1;
            }
            //Check if third party registration is valid
            if (isLastStep &&
                widget.registrationParam.isCompleteRegistration != true) {
              if (_formKeyBirth.currentState!.validate() &&
                  _formKeyGender.currentState!.validate() &&
                  _formKeyPass.currentState!.validate()) {
                final user = user_model.User(
                  id: "",
                  authId: "",
                  name: widget.registrationParam.user!.displayName!,
                  surname: "",
                  email: widget.registrationParam.user!.email!,
                  gender: selectedGender.string(appLocalization),
                  phoneNumber: "",
                  dob: selectedDate,
                  walletAddress: "",
                  country: '',
                  profession: '',
                  kycStatus: KYCStatus.none,
                );
                if (isValid(selectedGender, selectedDate)) {
                  context.push(
                    "/phone-registration",
                    extra: UserRegistrationModel(
                        user: user,
                        password: passwordController.text,
                        thirdSignin: true),
                  );
                }
              }
            } //Check if comple registration is valid
            else if (isLastStep &&
                widget.registrationParam.isCompleteRegistration == true) {
              if (_formNameReg.currentState!.validate() &&
                  _formLastReg.currentState!.validate() &&
                  _formBirthReg.currentState!.validate() &&
                  _formGenderReg.currentState!.validate() &&
                  _formEmailReg.currentState!.validate() &&
                  _formPassReg.currentState!.validate()) {
                final user = user_model.User(
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
            } else {
              setState(() => currentStep += 1);
            }
          },
          onStepCancel: () {
            currentStep == 0 ? null : setState(() => currentStep--);
          },
          controlsBuilder: (context, details) {
            var isLastStep = false;
            if (widget.registrationParam.isCompleteRegistration != true) {
              isLastStep = currentStep ==
                  getSteps(appLocalization, selectedDate, selectedGender)
                          .length -
                      1;
            } else {
              isLastStep = currentStep ==
                  getStepsCompleteRegistration(
                              appLocalization, selectedDate, selectedGender)
                          .length -
                      1;
            }

            return Container(
              padding: (isLastStep)
                  ? EdgeInsets.only(top: size.height * 0.5)
                  : EdgeInsets.only(top: size.height * 0.6),
              child: Row(
                children: [
                  if (currentStep > 0) ...[
                    Expanded(
                      child: AlcanciaButton(
                        width: screenWidth / 2,
                        height:
                            responsiveService.getHeightPixels(64, screenHeight),
                        color: alcanciaLightBlue,
                        buttonText: appLocalization.buttonBack,
                        onPressed: details.onStepCancel,
                      ),
                    )
                  ],
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: AlcanciaButton(
                      width: screenWidth / 2,
                      height:
                          responsiveService.getHeightPixels(64, screenHeight),
                      color: alcanciaLightBlue,
                      buttonText: isLastStep
                          ? appLocalization.buttonConfirm
                          : appLocalization.buttonNext,
                      onPressed: details.onStepContinue,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<FxStep> getStepsCompleteRegistration(AppLocalizations appLocalization,
          DateTime selectedDate, Gender? selectedGender) =>
      [
        FxStep(
            isActive: currentStep >= 0,
            title: Text(appLocalization.labelName),
            content: Form(
              key: _formNameReg,
              autovalidateMode: AutovalidateMode.disabled,
              child: LabeledTextFormField(
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
            )),
        FxStep(
            isActive: currentStep >= 1,
            title: Text(appLocalization.labelLastName),
            content: Form(
              key: _formLastReg,
              autovalidateMode: AutovalidateMode.disabled,
              child: LabeledTextFormField(
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
            )),
        FxStep(
            isActive: currentStep >= 2,
            title: Text(appLocalization.labelBirthdate),
            content: Form(
              key: _formBirthReg,
              autovalidateMode: AutovalidateMode.disabled,
              child: AlcanciaDatePicker(
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
            )),
        FxStep(
            isActive: currentStep >= 3,
            title: Text(appLocalization.labelGender),
            content: Form(
              key: _formGenderReg,
              autovalidateMode: AutovalidateMode.disabled,
              child: GenderPicker(
                selectedGenderProvider: selectedGenderProvider,
                validator: (Gender? gender) {
                  if (selectedGender == null)
                    return appLocalization.errorSelectGender;
                  return null;
                },
              ),
            )),
        FxStep(
            isActive: currentStep >= 4,
            title: Text(appLocalization.labelEmail),
            content: Form(
              key: _formEmailReg,
              autovalidateMode: AutovalidateMode.disabled,
              child: LabeledTextFormField(
                controller: emailController,
                labelText: appLocalization.labelEmail,
                inputType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (ref.watch(emailsInUseProvider).contains(value)) {
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
            )),
        FxStep(
            isActive: currentStep >= 5,
            title: Text(appLocalization.labelPassword),
            content: Form(
              key: _formPassReg,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                children: [
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
                ],
              ),
            )),
      ];
  List<FxStep> getSteps(AppLocalizations appLocalization, DateTime selectedDate,
          Gender? selectedGender) =>
      [
        FxStep(
          isActive: currentStep >= 0,
          title: Text(appLocalization.labelBirthdate),
          content: Form(
            key: _formKeyBirth,
            autovalidateMode: AutovalidateMode.disabled,
            child: AlcanciaDatePicker(
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
          ),
        ),
        FxStep(
          isActive: currentStep >= 1,
          title: Text(appLocalization.labelGender),
          content: Form(
            key: _formKeyGender,
            autovalidateMode: AutovalidateMode.disabled,
            child: GenderPicker(
              selectedGenderProvider: selectedGenderProvider,
              validator: (Gender? gender) {
                if (selectedGender == null) {
                  return appLocalization.errorSelectGender;
                }
                return null;
              },
            ),
          ),
        ),
        FxStep(
          isActive: currentStep >= 2,
          title: Text(appLocalization.labelPassword),
          content: Form(
            key: _formKeyPass,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              children: [
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
              ],
            ),
          ),
        ),
      ];

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
