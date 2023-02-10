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
  final CompletePasswordInput _completeForgotPasswordInput = CompletePasswordInput();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final StopWatchTimer timer = StopWatchTimer(mode: StopWatchMode.countDown, presetMillisecond: 60000);

  String? _email;
  String _phoneNumEnding = "";
  String _newPassword = '';
  String _verificationCode = '';
  bool _isButtonEnabled = true;
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
      print(response.data);
      _phoneNumEnding = (response.data?['forgotPassword'] as String).substring(6);
    }

    setState(() {
      _state.loading = false;
    });
  }

  void completeForgotPassword() async {
    if (!_formKey.currentState!.validate()) return null;
    if (!validatePassword()) return null;
    print(_email);
    final forgotPasswordInput = CompletePasswordInput(email: _email, newPassword: _newPassword, verificationCode: _verificationCode);
    var response = await _authService.completeForgotPassword(forgotPasswordInput);
    print(response);
    if (response.hasException) {
      _completePassState.error = _exceptionService.handleException(response.exception);
    } else {
      context.go('/login');
      Fluttertoast.showToast(msg: "Contraseña cambiada exitosamente");
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

    if (_state.loading) return const Scaffold(body: SafeArea(child: Center(child: CircularProgressIndicator())));
    if (_state.error != null) return Scaffold(body: SafeArea(child: Text(_state.error as String)));

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Form(
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
              const AlcanciaToolbar(state: StateToolbar.logoLetters, logoHeight: 60),
              AlcanciaContainer(top: 40, child: Text('¡Hola!', style: txtTheme.headline1)),
              AlcanciaContainer(top: 8, child: Text('Vamos a recuperar tu contraseña', style: txtTheme.headline2)),
              AlcanciaContainer(
                top: 16,
                child: Text(
                  'Ingresa el código que enviamos a tu celular que termina en $_phoneNumEnding',
                  style: txtTheme.bodyText1,
                ),
              ),
              AlcanciaContainer(
                top: 16,
                child: LabeledTextFormField(
                  controller: _verificationCodeControler,
                  labelText: "Codigo secreto",
                  validator: (value) => value == null || value == "" ? 'Field cannot be empty' : null,
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
                              const Text("¿No recibiste el código?"),
                              TextButton(
                                onPressed: value <= 0
                                    ? () async {
                                        await forgotPassword();
                                        timer.onResetTimer();
                                        timer.onStartTimer();
                                      }
                                    : null,
                                style: TextButton.styleFrom(foregroundColor: alcanciaLightBlue),
                                child: const Text(
                                  "Reenviar",
                                  style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
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
                  labelText: "Nueva contraseña",
                  obscure: obscurePassword,
                  validator: (value) => value == null || value == "" ? 'Field cannot be empty' : null,
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
                  labelText: "Confirma tu nueva contraseña",
                  obscure: obscureConfirmPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Field should not empty';
                    if (value != _newPassword) return 'Password do not match';
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
                    Text('Tu contraseña debe tener al menos:\n', style: txtTheme.bodyText1),
                    Row(
                      children: [
                        _newPassword.hasUpperCase()
                            ? SvgPicture.asset('lib/src/resources/images/icon_check.svg', height: 20)
                            : SvgPicture.asset('lib/src/resources/images/icon_cross.svg', height: 20),
                        const Padding(padding: EdgeInsets.only(left: 10), child: Text('Una letra mayúscula'))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          _newPassword.hasLowerCase()
                              ? SvgPicture.asset('lib/src/resources/images/icon_check.svg', height: 20)
                              : SvgPicture.asset('lib/src/resources/images/icon_cross.svg', height: 20),
                          const Padding(padding: EdgeInsets.only(left: 10), child: Text('Una letra minuscula'))
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
                          const Padding(padding: EdgeInsets.only(left: 10), child: Text('Un número'))
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
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text('Un caracter especial [!@#\$%^&*(),.?":{}|<>]'),
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
                  buttonText: "Siguiente",
                  onPressed: completeForgotPassword,
                ),
              ),
              if (_state.loading) const Scaffold(body: SafeArea(child: Center(child: CircularProgressIndicator()))),
              if (_completePassState.error != null) AlcanciaContainer(top: 16, child: Text(_completePassState.error as String, style: TextStyle(color: Colors.red),))
            ],
          ),
        ),
      ),
    );
  }
}
