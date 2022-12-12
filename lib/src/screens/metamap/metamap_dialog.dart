import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:flutter/material.dart';

import '../../shared/components/alcancia_components.dart';

enum UserStatus { resident, citizen }

class UserStatusDialog extends StatefulWidget {
  const UserStatusDialog({Key? key}) : super(key: key);

  @override
  State<UserStatusDialog> createState() => _UserStatusDialogState();
}

class _UserStatusDialogState extends State<UserStatusDialog> {
  UserStatus status = UserStatus.resident;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      insetPadding: const EdgeInsets.all(15),
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          minHeight: size.height * 0.3,
          maxHeight: size.height * 0.5,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).inputDecorationTheme.fillColor,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Selecciona una opción",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Radio(
                          value: UserStatus.resident,
                          groupValue: status,
                          onChanged: (UserStatus? value) {
                            setState(() {
                              if (value != null) {
                                status = value;
                              }
                            });
                          }),
                      Text(
                        "Residente",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                          value: UserStatus.citizen,
                          groupValue: status,
                          onChanged: (UserStatus? value) {
                            setState(() {
                              if (value != null) {
                                status = value;
                              }
                            });
                          }),
                      Text(
                        "Ciudadano",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
              AlcanciaButton(
                buttonText: "Aceptar",
                color: alcanciaLightBlue,
                width: 308,
                height: 64,
                onPressed: () {
                  Navigator.pop(context, status);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
