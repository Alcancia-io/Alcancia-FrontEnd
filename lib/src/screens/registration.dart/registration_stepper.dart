import 'package:alcancia/src/features/registration/model/registration_controller.dart';
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
import '../../features/registration/provider/registration_controller_provider.dart';
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

  final _formBasicInfo = GlobalKey<FormState>();
  final _formBirthReg = GlobalKey<FormState>();
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
    final registrationController = ref.watch(registrationControllerProvider);
    final size = MediaQuery.of(context).size;
    final appLocalization = AppLocalizations.of(context)!;
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedGender = ref.watch(selectedGenderProvider);
    final ResponsiveService responsiveService = ResponsiveService();
    final screenHeight = size.height;
    final screenWidth = size.width;
    var stepCompleteLength = getStepsCompleteRegistration(
            appLocalization, selectedDate, selectedGender, size)
        .length;
    var stepPartialLength =
        getSteps(appLocalization, selectedDate, selectedGender, size).length;
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
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: FxStepper(
              type: FxStepperType.horizontal,
              steps: widget.registrationParam.isCompleteRegistration == true
                  ? getStepsCompleteRegistration(
                      appLocalization, selectedDate, selectedGender, size)
                  : getSteps(
                      appLocalization, selectedDate, selectedGender, size),
              currentStep: currentStep,
              onStepContinue: () async {
                if (widget.registrationParam.isCompleteRegistration != true) {
                  //Condiciones que solo aplican para Stepper Thirdparty signIn
                  if (currentStep == 0) {
                    if (!_formBasicInfo.currentState!.validate()) {
                      return;
                    } else {
                      setState(() => currentStep += 1);
                    }
                  } else if (currentStep == 1) {
                    if (!_formPassReg.currentState!.validate()) {
                      return;
                    } else {
                      if (_formBasicInfo.currentState!.validate() &&
                          _formPassReg.currentState!.validate()) {
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
                    }
                  }
                }
                if (widget.registrationParam.isCompleteRegistration == true) {
                  if (currentStep == 0) {
                    if (!_formEmailReg.currentState!.validate()) {
                      return;
                    } else {
                      //Check if third party registration is valid
                      await registrationController
                          .checkUserExists(emailController.text)
                          .then((value) {
                        if (value) {
                          context.go("/login", extra: emailController.text);
                          return;
                        } else {
                          setState(() => currentStep += 1);
                        }
                      });
                    }
                  } else if (currentStep == 1) {
                    if (!_formBasicInfo.currentState!.validate()) {
                      return;
                    } else {
                      setState(() => currentStep += 1);
                    }
                  } else if (currentStep == 2) {
                    if (!_formPassReg.currentState!.validate()) {
                      return;
                    } else {
                      if (_formBasicInfo.currentState!.validate() &&
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
                                  user: user,
                                  password: passwordController.text));
                        }
                      }
                    }
                  }
                }
              },
              physics: const ScrollPhysics(),
              onStepCancel: () {
                currentStep == 0 ? null : setState(() => currentStep--);
              },
              controlsBuilder: (context, details) {
                var isLastStep = false;
                EdgeInsets.only(top: size.height * 0.55);
                if (widget.registrationParam.isCompleteRegistration != true) {
                  isLastStep = currentStep == stepPartialLength - 1;
                } else {
                  isLastStep = currentStep == stepCompleteLength - 1;
                }
                return Container(
                  child: Row(
                    children: [
                      if (currentStep > 0) ...[
                        Expanded(
                          child: AlcanciaButton(
                            width: screenWidth / 2,
                            height: responsiveService.getHeightPixels(
                                64, screenHeight),
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
                          height: responsiveService.getHeightPixels(
                              64, screenHeight),
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
        ]),
      ),
    );
  }

  List<FxStep> getStepsCompleteRegistration(AppLocalizations appLocalization,
          DateTime selectedDate, Gender? selectedGender, Size size) =>
      [
        FxStep(
            isActive: currentStep >= 0,
            title: Text(appLocalization.labelEmail),
            content: Container(
              height: size.height - (size.height * 0.35),
              child: Form(
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
              ),
            )),
        FxStep(
            isActive: currentStep >= 1,
            title: Text(appLocalization.labelBasicInfo),
            content: Container(
              height: size.height - (size.height * 0.35),
              child: Form(
                key: _formBasicInfo,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(children: [
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
                ]),
              ),
            )),
        FxStep(
            isActive: currentStep >= 2,
            title: Text(appLocalization.labelPassword),
            content: Container(
              height: size.height - (size.height * 0.35),
              child: Form(
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
              ),
            )),
      ];
  List<FxStep> getSteps(AppLocalizations appLocalization, DateTime selectedDate,
          Gender? selectedGender, Size size) =>
      [
        FxStep(
          isActive: currentStep >= 0,
          title: Text(appLocalization.labelBirthdate),
          content: Container(
            height: size.height - (size.height * 0.35),
            child: Form(
              key: _formBasicInfo,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(children: [
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
                    if (selectedGender == null) {
                      return appLocalization.errorSelectGender;
                    }
                    return null;
                  },
                ),
              ]),
            ),
          ),
        ),
        FxStep(
          isActive: currentStep >= 1,
          title: Text(appLocalization.labelPassword),
          content: Container(
            height: size.height - (size.height * 0.35),
            child: Form(
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
            ),
          ),
        ),
      ];

  @override
  void dispose() {
    super.dispose();
  }
}
