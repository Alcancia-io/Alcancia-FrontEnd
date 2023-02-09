import 'dart:developer';

import 'package:alcancia/src/features/registration/provider/timer_provider.dart';
import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/extensions/string_extensions.dart';
import 'package:alcancia/src/shared/components/alcancia_container.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:alcancia/src/shared/graphql/queries/me_query.dart';
import 'package:alcancia/src/shared/models/alcancia_models.dart';
import 'package:alcancia/src/shared/services/auth_service.dart';
import 'package:alcancia/src/shared/services/exception_service.dart';
import 'package:alcancia/src/shared/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
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
  final _formKey = GlobalKey<FormState>();

  String? _email;
  String _newPassword = '';
  bool _isButtonEnabled = true;

  readEmail() async {
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

  void forgotPassword() async {
    setState(() {
      _state.loading = true;
    });

    var response = await _authService.forgotPassword("yafte@alcancia.io");
    // print(response);
    // inspect(response);
    // print(response.runtimeType);
    // print(response);
    // if (response.hasException) _state.error = _exceptionService.handleException(response.exception);

    setState(() {
      _state.loading = false;
    });
  }

  void completeForgotPassword() async {
    if (_formKey.currentState!.validate()) return null;
    if (!validatePassword()) return null;

    var response = await _authService.completeForgotPassword(_completeForgotPasswordInput);
    if (response.hasException) {
      _completePassState.error = _exceptionService.handleException(response.exception);
    } else {
      context.pushNamed('success');
    }
  }

  void wrapper() async {
    // await readEmail();
    forgotPassword();
  }

  @override
  void initState() {
    super.initState();
    wrapper();
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
    final timer = ref.watch(timerProvider);
    if (_state.loading) return const Scaffold(body: SafeArea(child: Center(child: CircularProgressIndicator())));
    if (_state.error != null) return Scaffold(body: SafeArea(child: Text(_state.error as String)));

    return Scaffold(
      body: SafeArea(
        child: AlcanciaContainer(
          top: 20,
          left: 38,
          right: 38,
          bottom: 28,
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AlcanciaToolbar(state: StateToolbar.logoLetters, logoHeight: 60),
                AlcanciaContainer(top: 40, child: const Text('Hola!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),)),
                AlcanciaContainer(top: 8, child: const Text('Vamos a recuperar tu contraseña', style: TextStyle(fontSize: 15))),
                AlcanciaContainer(top: 16, child: const Text('Ingresa el código que enviamos a tu celular 1234')),
                LabeledTextFormField(
                  controller: _verificationCodeControler,
                  labelText: "Codigo secreto",
                  validator: (value) => value == null || value == "" ? 'Field cannot be empty' : null,
                ),
                StreamBuilder<int>( //TODO: Hacer reusable
                    stream: timer.rawTime,
                    initialData: 0,
                    builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                      final value = snapshot.data;
                      final displayTime = StopWatchTimer.getDisplayTime(
                          value,
                          hours: false,
                          milliSecond: false);
                      return Column(
                        children: [
                          Center(
                            child: Container(
                              decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(100),
                                      side: BorderSide(
                                          color: alcanciaLightBlue))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.timer_sharp,
                                      color: alcanciaLightBlue,
                                    ),
                                    Text(
                                      displayTime,
                                      style: TextStyle(
                                          color: alcanciaLightBlue),
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
                                  // TODO: Reenviar codigo
                                  timer.onResetTimer();
                                  timer.onStartTimer();
                                }
                                    : null,
                                style: TextButton.styleFrom(
                                    foregroundColor: alcanciaLightBlue),
                                child: const Text(
                                  "Reenviar",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
                AlcanciaContainer(top: 24, child: const Text('no recibiste el codigo ')),
                Column(
                  children: [
                    LabeledTextFormField(
                      controller: _newPasswordController,
                      labelText: "Nueva contraseña",
                      validator: (value) => value == null || value == "" ? 'Field cannot be empty' : null,
                      onChange: (value) => setState(() {
                        _newPassword = value ??= '';
                      }),
                    ),
                    LabeledTextFormField(
                      controller: _confirmPasswordController,
                      labelText: "Confirma tu nueva contraseña",
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Field should not empty';
                        if (value != _newPassword) return 'Password do not match';
                        return null;
                      },
                    ),
                  ],
                ),
                AlcanciaContainer(
                  top: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!_newPassword.hasUpperCase()) const Text('Missing upper'),
                      if (!_newPassword.hasLowerCase()) const Text('Missing lower'),
                      if (!_newPassword.hasDigits()) const Text('Missing number'),
                      if (!_newPassword.hasSpecialChar()) const Text('Missing special char'),
                    ],
                  ),
                ),
                const Spacer(),
                AlcanciaButton(
                  width: double.infinity,
                  height: 64,
                  buttonText: "Siguiente",
                  onPressed: completeForgotPassword,
                ),
                if (_state.loading) const Scaffold(body: SafeArea(child: Center(child: CircularProgressIndicator()))),
                if (_completePassState.error != null) Text(_completePassState.error as String)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
