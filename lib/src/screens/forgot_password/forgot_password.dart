import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/extensions/string_extensions.dart';
import 'package:alcancia/src/shared/components/alcancia_container.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:alcancia/src/shared/models/alcancia_models.dart';
import 'package:alcancia/src/shared/services/auth_service.dart';
import 'package:alcancia/src/shared/services/exception_service.dart';
import 'package:alcancia/src/shared/services/storage_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPassword extends ConsumerStatefulWidget {
  const ForgotPassword({super.key});

  @override
  ConsumerState<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends ConsumerState<ForgotPassword> {
  final AuthService _authService = AuthService();
  final ExceptionService _exceptionService = ExceptionService();
  final StorageService _storageService = StorageService();
  final TextEditingController _verificationCodeControler = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FetchState _state = FetchState();
  final FetchState _completePassState = FetchState();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final StopWatchTimer timer = StopWatchTimer(mode: StopWatchMode.countDown, presetMillisecond: 60000);

  String? _email;
  String _phoneNumEnding = "";
  String _newPassword = '';
  String _verificationCode = '';
  bool _isButtonEnabled = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  Future<void> readEmail() async {
    _email = await _storageService.readSecureData("userEmail");
  }

  bool validatePassword() {
    return _newPassword.hasLowerCase() &&
        _newPassword.hasUpperCase() &&
        _newPassword.hasDigits() &&
        _newPassword.hasSpecialChar();
  }

  bool emptyFields() {
    var result = _verificationCodeControler.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty;
    return result;
  }

  Future<void> forgotPassword() async {
    setState(() {
      _state.loading = true;
    });
    if (_email == null) {
      _state.error = "No user email";
      return;
    }
    var response = await _authService.forgotPassword(_email!);
    if (response.hasException) {
      _state.error = _exceptionService.handleException(response.exception);
    } else {
      _phoneNumEnding = (response.data?['forgotPassword'] as String).substring(6);
    }

    setState(() {
      _state.loading = false;
    });
  }

  completeForgotPassword(AppLocalizations appLoc) async {
    if (!_formKey.currentState!.validate()) return null;
    if (!validatePassword()) return null;

    final forgotPasswordInput = CompletePasswordInput(
      email: _email,
      newPassword: _newPassword,
      verificationCode: _verificationCode,
    );
    var response = await _authService.completeForgotPassword(forgotPasswordInput);

    if (response.hasException) {
      _completePassState.error = _exceptionService.handleException(response.exception);
    } else {
      await _storageService.deleteSecureData("userName");
      await _storageService.deleteSecureData("userEmail");
      context.go('/login');
      Fluttertoast.showToast(msg: appLoc.alertPasswordChanged);
    }
  }

  void wrapper() async {
    await readEmail();
    forgotPassword();
  }

  @override
  void initState() {
    super.initState();
    wrapper();
    timer.onStartTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _verificationCodeControler.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;
    final appLoc = AppLocalizations.of(context)!;

    if (_state.loading) return const Scaffold(body: SafeArea(child: Center(child: CircularProgressIndicator())));
    if (_state.error != null) return Scaffold(body: SafeArea(child: Text(_state.error as String)));

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: const AlcanciaToolbar(state: StateToolbar.logoLetters, logoHeight: 60, toolbarHeight: 70,),
        body: SafeArea(
          bottom: false,
          child: Form(
            onChanged: () => setState(() => _isButtonEnabled = _formKey.currentState!.validate()),
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: const EdgeInsets.only(
                top: 20,
                left: 38,
                right: 38,
                bottom: 28,
              ),
              children: [
                AlcanciaContainer(child: Text(appLoc.labelHello, style: txtTheme.headline1)),
                AlcanciaContainer(top: 8, child: Text(appLoc.labelRecoverPassword, style: txtTheme.headline2)),
                AlcanciaContainer(
                  top: 16,
                  child: Text(
                    appLoc.labelEnterCodePhone(_phoneNumEnding),
                    style: txtTheme.bodyText1,
                  ),
                ),
                AlcanciaContainer(
                  top: 16,
                  child: LabeledTextFormField(
                    controller: _verificationCodeControler,
                    labelText: appLoc.labelCode,
                    validator: (value) => value == null || value == "" ? appLoc.errorRequiredField : null,
                    onChanged: (value) {
                      setState(() {
                        _verificationCode = value;
                      });
                    },
                  ),
                ),
                AlcanciaContainer(
                  top: 16,
                  child: StreamBuilder<int>(
                      //TODO: Hacer reusable
                      stream: timer.rawTime,
                      initialData: 0,
                      builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                        final value = snapshot.data;
                        final displayTime = StopWatchTimer.getDisplayTime(value, hours: false, milliSecond: false);
                        return Column(
                          children: [
                            Center(
                              child: Container(
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                    side: const BorderSide(color: alcanciaLightBlue),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.timer_sharp,
                                        color: alcanciaLightBlue,
                                      ),
                                      Text(
                                        displayTime,
                                        style: const TextStyle(color: alcanciaLightBlue),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(appLoc.labelDidNotReceiveCode),
                                TextButton(
                                  onPressed: value <= 0
                                      ? () async {
                                          await forgotPassword();
                                          timer.onResetTimer();
                                          timer.onStartTimer();
                                        }
                                      : null,
                                  style: TextButton.styleFrom(foregroundColor: alcanciaLightBlue),
                                  child: Text(
                                    appLoc.buttonResend,
                                    style: const TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                ),
                AlcanciaContainer(
                  top: 16,
                  child: LabeledTextFormField(
                    controller: _newPasswordController,
                    labelText: appLoc.labelNewPassword,
                    obscure: obscurePassword,
                    validator: (value) => value == null || value == "" ? appLoc.errorRequiredField : null,
                    onChanged: (value) => setState(() {
                      _newPassword = value;
                    }),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                      child: Icon(obscurePassword ? CupertinoIcons.eye : CupertinoIcons.eye_fill),
                    ),
                  ),
                ),
                AlcanciaContainer(
                  top: 16,
                  child: LabeledTextFormField(
                    controller: _confirmPasswordController,
                    labelText: appLoc.labelConfirmNewPassword,
                    obscure: obscureConfirmPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) return appLoc.errorRequiredField;
                      if (value != _newPassword) return appLoc.errorPasswordMatch;
                      return null;
                    },
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          obscureConfirmPassword = !obscureConfirmPassword;
                        });
                      },
                      child: Icon(obscureConfirmPassword ? CupertinoIcons.eye : CupertinoIcons.eye_fill),
                    ),
                  ),
                ),
                AlcanciaContainer(
                  top: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appLoc.labelPasswordRequirements, style: txtTheme.bodyText1),
                      Row(
                        children: [
                          _newPassword.hasUpperCase()
                              ? SvgPicture.asset('lib/src/resources/images/icon_check.svg', height: 20)
                              : SvgPicture.asset('lib/src/resources/images/icon_cross.svg', height: 20),
                          Padding(padding: const EdgeInsets.only(left: 10), child: Text(appLoc.labelRequirementUppercase))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            _newPassword.hasLowerCase()
                                ? SvgPicture.asset('lib/src/resources/images/icon_check.svg', height: 20)
                                : SvgPicture.asset('lib/src/resources/images/icon_cross.svg', height: 20),
                            Padding(padding: const EdgeInsets.only(left: 10), child: Text(appLoc.labelRequirementLowercase))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            _newPassword.hasDigits()
                                ? SvgPicture.asset('lib/src/resources/images/icon_check.svg', height: 20)
                                : SvgPicture.asset('lib/src/resources/images/icon_cross.svg', height: 20),
                            Padding(padding: const EdgeInsets.only(left: 10), child: Text(appLoc.labelRequirementNumber))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            _newPassword.hasSpecialChar()
                                ? SvgPicture.asset('lib/src/resources/images/icon_check.svg', height: 20)
                                : SvgPicture.asset('lib/src/resources/images/icon_cross.svg', height: 20),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(appLoc.labelRequirementSpecialCharacter),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                AlcanciaContainer(
                  top: 50,
                  child: AlcanciaButton(
                    width: double.infinity,
                    height: 64,
                    buttonText: appLoc.buttonNext,
                    onPressed: _isButtonEnabled ? completeForgotPassword(appLoc) : null,
                  ),
                ),
                if (_state.loading) const Scaffold(body: SafeArea(child: Center(child: CircularProgressIndicator()))),
                if (_completePassState.error != null)
                  AlcanciaContainer(
                    top: 16,
                    child: Text(_completePassState.error as String, style: const TextStyle(color: Colors.red)),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
