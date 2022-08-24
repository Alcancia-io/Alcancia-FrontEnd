import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/country.dart';

class CountryPicker extends ConsumerWidget {
  const CountryPicker({
    Key? key,
    required this.selectedCountryProvider,
  }) : super(key: key);

  final AutoDisposeStateProvider<Country> selectedCountryProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCountry = ref.watch(selectedCountryProvider);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: CupertinoButton(
        child: Row(
          children: [
            Text(
              "${selectedCountry.flag} +${selectedCountry.dialCode}",
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
                  list: countries,
                  itemBuilder: (context, index) {
                    final country = countries[index];
                    return GestureDetector(
                      onTap: () => ref.read(selectedCountryProvider.notifier).state = country,
                      child: AlcanciaListTile(title: country.displayCC, value: country, groupValueProvider: selectedCountryProvider, onChanged: (newValue) {
                        ref.read(selectedCountryProvider.notifier).state = newValue;
                      },),
                    );
                  },
                );
              });
        },
      ),
    );
  }
}