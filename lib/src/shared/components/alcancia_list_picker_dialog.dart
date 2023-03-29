import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'alcancia_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AlcanciaListPickerDialog extends StatelessWidget {
  const AlcanciaListPickerDialog({
    Key? key,
    required this.list,
    required this.itemBuilder,
  }) : super(key: key);

  final List<dynamic> list;
  final Widget Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appLoc = AppLocalizations.of(context)!;
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
                appLoc.labelSelectDialogTitle,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: itemBuilder,
                  itemCount: list.length,
                ),
              ),
              AlcanciaButton(
                buttonText: appLoc.buttonAccept,
                color: alcanciaLightBlue,
                width: 308,
                height: 64,
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AlcanciaListTile extends ConsumerWidget {
  const AlcanciaListTile(
      {Key? key,
      required this.title,
      required this.value,
      required this.groupValueProvider,
      required this.onChanged})
      : super(key: key);

  final String title;
  final dynamic value;
  final ProviderBase groupValueProvider;
  final Function(dynamic newValue) onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupValue = ref.watch(groupValueProvider);
    return Row(
      children: [
        Radio<dynamic>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyText1,
        )
      ],
    );
    //return RadioListTile<Gender>(
    //  value: Gender.values[index],
    //  groupValue: selectedGender,
    //  onChanged: (gender) {
    //    ref
    //        .read(selectedGenderProvider
    //        .notifier)
    //        .setGender(gender);
    //  },
    //  title: Text(
    //      Gender.values[index].string, style: Theme.of(context).textTheme.bodyText1,),
    //);
  }
}
