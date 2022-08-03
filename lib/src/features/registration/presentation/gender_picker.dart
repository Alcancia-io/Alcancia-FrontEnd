import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/gender.dart';

class GenderPicker extends ConsumerWidget {
  const GenderPicker({
    Key? key,
    required this.selectedGenderProvider,
  }) : super(key: key);

  final AutoDisposeStateProvider<Gender?> selectedGenderProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGender = ref.watch(selectedGenderProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("¿Con cúal género te sientes identificado?"),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).inputDecorationTheme.fillColor,
            borderRadius: BorderRadius.circular(7),
          ),
          child: CupertinoButton(
            child: Row(
              children: [
                Text(
                  selectedGender.string,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(
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
                          onTap: () => ref.read(selectedGenderProvider.notifier).state = gender,
                          child: AlcanciaListTile(title: gender.string, value: gender, groupValueProvider: selectedGenderProvider, onChanged: (newValue) {
                            ref.read(selectedGenderProvider.notifier).state = newValue;
                          },),
                        );
                      },
                    );
                  });
            },
          ),
        )
      ],
    );
  }
}