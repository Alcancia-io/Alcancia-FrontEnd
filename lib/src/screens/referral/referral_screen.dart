import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/screens/error/error_screen.dart';
import 'package:alcancia/src/screens/referral/referral_controller.dart';
import 'package:alcancia/src/shared/components/alcancia_action_dialog.dart';
import 'package:alcancia/src/shared/components/alcancia_button.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';

import '../../shared/provider/user_provider.dart';

class ReferralScreen extends ConsumerStatefulWidget {
  const ReferralScreen({super.key});

  @override
  ConsumerState<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends ConsumerState<ReferralScreen> {
  final _referralController = ReferralController();

  @override
  Widget build(BuildContext context) {
    final userValue = ref.watch(alcanciaUserProvider);
    final appLoc = AppLocalizations.of(context)!;
    return userValue.when(data: (user) {
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AlcanciaToolbar(
            state: StateToolbar.logoLetters,
            logoHeight: 38,
          ),
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const ReferralInstructions(),
                      const SizedBox(height: 16),
                      if (user.referralCode != null) ...[
                        ReferralCodeCard(
                            referralCode: user.referralCode!,
                            onPressed: () {
                              Share.share(appLoc.referralTextShare(user.referralCode!));
                            }),
                      ] else ...[
                        ExternalReferralCard(
                          onPressed: (referralCode) async {
                            // Show confirmation dialog
                            final confirm = await showDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                                return AlcanciaActionDialog(
                                    acceptText: appLoc.buttonConfirm,
                                    cancelText: appLoc.buttonCancel,
                                    acceptColor: alcanciaMidBlue,
                                    cancelColor: Colors.red,
                                    acceptAction: () {
                                      Navigator.of(ctx).pop(true);
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                          appLoc.labelConfirmReferralCode,
                                          style: Theme.of(context).textTheme.titleLarge,
                                        ),
                                        const SizedBox(height: 16),
                                        if (referralCode != null) ...[
                                          Text(
                                            appLoc.labelConfirmReferralCodeDescription(referralCode),
                                            style: Theme.of(context).textTheme.bodyText1,
                                          ),
                                        ] else ...[
                                          Text(
                                            appLoc.labelConfirmReferralCodeDescriptionNoCode,
                                            style: Theme.of(context).textTheme.bodyText1,
                                          ),
                                        ]
                                      ],
                                    ));
                              },
                            );
                            if (confirm == true) {
                              await _referralController.subscribeToCampaign(code: referralCode);
                              ref.invalidate(alcanciaUserProvider);
                            }
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }, error: (error, _) {
      return ErrorScreen(error: error.toString());
    }, loading: () {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    });
  }
}

class ReferralInstructions extends StatelessWidget {
  const ReferralInstructions({super.key});

  @override
  Widget build(BuildContext context) {
    final ctx = Theme.of(context);
    final appLoc = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
      decoration: BoxDecoration(
        color: ctx.brightness == Brightness.dark ? alcanciaCardDark2 : alcanciaCardLight2,
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
                child: SvgPicture.asset(
              'lib/src/resources/images/referral_image.svg',
              width: 150,
              height: 150,
            )),
          ),
          Text(appLoc.labelWinFiveDollars,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 28)),
          const SizedBox(height: 24),
          Text(appLoc.labelHowItWorks, textAlign: TextAlign.start, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(appLoc.labelReferralStepOne, style: Theme.of(context).textTheme.bodyText1),
              const SizedBox(height: 8),
              Text(appLoc.labelReferralStepTwo, style: Theme.of(context).textTheme.bodyText1),
              const SizedBox(height: 8),
              Text(appLoc.labelReferralStepThree, style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ],
      ),
    );
  }
}

class ReferralCodeCard extends StatelessWidget {
  const ReferralCodeCard({super.key, required this.referralCode, required this.onPressed});

  final String referralCode;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final ctx = Theme.of(context);
    final appLoc = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: ctx.brightness == Brightness.dark ? alcanciaCardDark2 : alcanciaCardLight2,
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              appLoc.labelShareThisCode,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 6,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                  decoration: BoxDecoration(
                      border: Border.all(color: alcanciaMidBlue, width: 3), borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    referralCode,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Spacer(
                flex: 1,
              ),
              AlcanciaButton(buttonText: appLoc.buttonShare, onPressed: () => onPressed()),
            ],
          )
        ],
      ),
    );
  }
}

class ExternalReferralCard extends StatefulWidget {
  const ExternalReferralCard({super.key, required this.onPressed});

  final void Function(String?) onPressed;

  @override
  State<ExternalReferralCard> createState() => _ExternalReferralCardState();
}

class _ExternalReferralCardState extends State<ExternalReferralCard> {
  final TextEditingController _controller = TextEditingController();
  bool _enableButton = false;

  @override
  Widget build(BuildContext context) {
    final ctx = Theme.of(context);
    final appLoc = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: ctx.brightness == Brightness.dark ? alcanciaCardDark2 : alcanciaCardLight2,
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(appLoc.labelHaveAFriendsCode,
                textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 50,
            child: TextField(
                onChanged: (value) => setState(() => _enableButton = value.isNotEmpty),
                controller: _controller,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: appLoc.labelFriendsCode,
                  hintStyle: Theme.of(context).textTheme.bodyText1,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: alcanciaMidBlue, width: 3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: alcanciaMidBlue, width: 3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                )),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    child: AlcanciaButton(
                        buttonText: appLoc.buttonDontHaveOne,
                        onPressed: () => widget.onPressed(null),
                        color: Colors.red)),
                const SizedBox(width: 16),
                Expanded(
                    child: AlcanciaButton(
                  buttonText: appLoc.buttonConfirm,
                  onPressed: _enableButton ? () => widget.onPressed(_controller.text) : null,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
