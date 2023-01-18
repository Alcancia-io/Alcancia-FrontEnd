import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/screens/metamap/metamap_controller.dart';
import 'package:alcancia/src/shared/components/alcancia_dropdown.dart';
import 'package:alcancia/src/shared/models/alcancia_models.dart';
import 'package:alcancia/src/shared/provider/alcancia_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/components/alcancia_components.dart';

enum UserStatus { resident, citizen }

class UserStatusDialog extends ConsumerStatefulWidget {
  const UserStatusDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<UserStatusDialog> createState() => _UserStatusDialogState();
}

class _UserStatusDialogState extends ConsumerState<UserStatusDialog> {
  UserStatus status = UserStatus.resident;
  TextEditingController professionTextController = TextEditingController();
  final MetaMapController metaMapController = MetaMapController();

  late String selectedProfession = metaMapController.professions[0]["name"]!;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = ref.watch(userProvider);
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
                "Necesitamos saber más,",
                style: Theme.of(context).textTheme.headline2,
              ),
              Text(
                "¿Cuál es tu estatus migratorio en México?",
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
              Text(
                "¿Cuál es tu profesión?",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              AlcanciaDropdown(
                dropdownItems: metaMapController.professions,
                itemsFontSize: 15,
                onChanged: (newValue) {
                  print(newValue);
                  setState(() {
                    selectedProfession = newValue;
                  });
                },
              ),
              AlcanciaButton(
                buttonText: "Aceptar",
                color: alcanciaLightBlue,
                width: 308,
                height: 64,
                onPressed: () async {
                  final User newUser = user!;
                  newUser.profession = selectedProfession;
                  ref.read(userProvider.notifier).setUser(newUser);
                  await metaMapController.updateUser(user: newUser);
                  Navigator.pop(context, status);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    professionTextController.dispose();
    super.dispose();
  }
}
