import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/gender.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GenderPicker extends ConsumerWidget {
  const GenderPicker({
    Key? key,
    required this.selectedGenderProvider,
    this.validator
  }) : super(key: key);

  final AutoDisposeStateProvider<Gender?> selectedGenderProvider;
  final String? Function(Gender?)? validator;


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGender = ref.watch(selectedGenderProvider);
    final appLocalization = AppLocalizations.of(context)!;
    return FormField(
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Text(appLocalization.labelGenderIdentification),
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).inputDecorationTheme.fillColor,
                border: state.hasError ? Border.all(color: Colors.red) : null,
                borderRadius: BorderRadius.circular(7),
              ),
              child: CupertinoButton(
                child: Row(
                  children: [
                    Text(
                      selectedGender.string(appLocalization),
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .subtitle2
                              ?.color
                              ?.withOpacity(0.6)),
                    ),
                    const Spacer(),
                    Icon(
                      CupertinoIcons.chevron_down,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ],
                ),
                onPressed: () async {
                  // Show custom pop-up menu
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlcanciaListPickerDialog(
                          list: Gender.values,
                          itemBuilder: (context, index) {
                            final gender = Gender.values[index];
                            return GestureDetector(
                              onTap: () => ref
                                  .read(selectedGenderProvider.notifier)
                                  .state = gender,
                              child: AlcanciaListTile(
                                title: gender.string(appLocalization),
                                value: gender,
                                groupValueProvider: selectedGenderProvider,
                                onChanged: (newValue) {
                                  ref
                                      .read(selectedGenderProvider.notifier)
                                      .state = newValue;
                                },
                              ),
                            );
                          },
                        );
                      });
                  Form.of(context).validate();
                },
              ),
            ),
            if (state.hasError) Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(state.errorText!, style: const TextStyle(color: Colors.red, fontSize: 10),),
            ),
          ],
        );
      },
      validator: validator,
    );
  }
}
