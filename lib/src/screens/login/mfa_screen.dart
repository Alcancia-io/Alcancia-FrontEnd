import 'package:alcancia/src/features/registration/provider/timer_provider.dart';
import 'package:alcancia/src/screens/login/login_controller.dart';
import 'package:alcancia/src/shared/models/alcancia_models.dart';
import 'package:alcancia/src/shared/models/login_data_model.dart';
import 'package:flutter/material.dart';
import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../shared/models/storage_item.dart';
import '../../shared/services/storage_service.dart';

class MFAScreen extends ConsumerStatefulWidget {
  const MFAScreen({Key? key, required this.data}) : super(key: key);
  final LoginDataModel data;

  @override
  ConsumerState<MFAScreen> createState() => _MFAScreenState();
}

class _MFAScreenState extends ConsumerState<MFAScreen> {
  final loginController = LoginController();
  final codeController = TextEditingController();
  String error = "";
  bool _loading = false;
  final StorageService _storageService = StorageService();

  saveToken(String token) async {
    final StorageItem storageItem = StorageItem("token", token);
    await _storageService.writeSecureData(storageItem);
  }

  @override
  Widget build(BuildContext context) {
    final timer = ref.watch(timerProvider);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: AlcanciaLogo(),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Text(
                          "Comprobemos \ntu identidad,",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 35),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                            "Ingresa el código de 6 dígitos que enviamos a tu celular que termina en ${widget.data.phoneNumber.substring(widget.data.phoneNumber.length - 4)}"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LabeledTextFormField(
                            controller: codeController,
                            inputType: TextInputType.number,
                            autofillHints: [AutofillHints.oneTimeCode],
                            labelText: "Código"),
                      ),
                      StreamBuilder<int>(
                        stream: timer.rawTime,
                        initialData: 0,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
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
                                          borderRadius: BorderRadius.circular(100),
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
                                          style:
                                              TextStyle(color: alcanciaLightBlue),
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
                                    onPressed: value <= 0 ? () async {
                                      final token = await loginController
                                          .login(widget.data.email, widget.data.password);
                                      print(token);
                                      saveToken(token);
                                      timer.onResetTimer();
                                      timer.onStartTimer();
                                    } : null,
                                    style: TextButton.styleFrom(
                                        foregroundColor: alcanciaLightBlue
                                    ),
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
                        },
                      ),
                      Center(
                        child: Column(
                          children: [
                            if (_loading) ...[
                              const CircularProgressIndicator(),
                            ] else ...[
                              AlcanciaButton(
                                color: alcanciaLightBlue,
                                width: 308,
                                height: 64,
                                buttonText: "Iniciar sesión",
                                onPressed: () async {
                                  _setLoading(true);
                                  try {
                                    final completed = await loginController
                                        .completeSignIn(codeController.text);
                                    if (completed) context.go("/homescreen/0");
                                  } catch (err) {
                                    setState(() {
                                      error = err.toString();
                                    });
                                  }
                                  _setLoading(false);
                                },
                              ),
                              Text(
                                error,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
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
    codeController.dispose();
    super.dispose();
  }

  void _setLoading(bool loading) {
    setState(() {
      _loading = loading;
    });
  }
}
