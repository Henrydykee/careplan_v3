import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../core/presentation/widgets/app_bar.dart';
import '../../../../../core/presentation/widgets/button.dart';
import '../../../../../core/presentation/widgets/loader_wrapper.dart';
import '../../../../../core/presentation/widgets/text_holder.dart';
import '../../../../../core/resources/color.dart';
import '../../../../../core/resources/string.dart';
import 'kyc_step_indicator.dart';

/// Shared chrome for every KYC step: progress, title, section heading and the
/// pinned primary action. Screens only supply their own fields.
class KycStepScaffold extends StatefulWidget {
  const KycStepScaffold({
    super.key,
    required this.step,
    required this.heading,
    required this.fields,
    required this.onContinue,
    this.subheading,
    this.totalSteps = 4,
    this.buttonTitle,
    this.isLoading = false,
    this.footnote =
        'Your details are encrypted and only shared with your care team.',
    this.numericFocusNodes = const [],
  });

  final int step;
  final int totalSteps;

  /// Section heading, e.g. "Home address".
  final String heading;

  /// One short line explaining why the details are needed.
  final String? subheading;

  final List<Widget> fields;
  final VoidCallback onContinue;
  final String? buttonTitle;
  final bool isLoading;

  /// Reassurance line shown just above the primary action.
  final String? footnote;

  /// Focus nodes of fields that open a number pad. iOS number pads have no
  /// return key, so while one of these holds focus the scaffold shows its own
  /// "Done" bar above the keyboard.
  final List<FocusNode> numericFocusNodes;

  @override
  State<KycStepScaffold> createState() => _KycStepScaffoldState();
}

class _KycStepScaffoldState extends State<KycStepScaffold> {
  @override
  void initState() {
    super.initState();
    for (final node in widget.numericFocusNodes) {
      node.addListener(_onFocusChanged);
    }
  }

  @override
  void dispose() {
    for (final node in widget.numericFocusNodes) {
      node.removeListener(_onFocusChanged);
    }
    super.dispose();
  }

  void _onFocusChanged() {
    if (mounted) setState(() {});
  }

  bool get _numericFieldFocused =>
      widget.numericFocusNodes.any((node) => node.hasFocus);

  @override
  Widget build(BuildContext context) {
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return LoaderWrapper(
      isLoading: widget.isLoading,
      view: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(showBackIcon: true, color: Colors.white),
        body: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(14),
                KycStepIndicator(step: widget.step, total: widget.totalSteps),
                const Gap(20),
                TextHolder(
                  title: Strings.user_verification,
                  size: 22,
                  fontWeight: FontWeight.w800,
                  color: CarePlanColor.brown,
                ),
                const Gap(24),
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextHolder(
                          title: widget.heading,
                          size: 17,
                          fontWeight: FontWeight.w800,
                          color: CarePlanColor.brown,
                        ),
                        if (widget.subheading != null) ...[
                          const Gap(6),
                          TextHolder(
                            title: widget.subheading!,
                            size: 13.5,
                            fontHeight: 1.45,
                            color: CarePlanColor.grey_3,
                          ),
                        ],
                        const Gap(18),
                        ...widget.fields,
                        const Gap(30),
                      ],
                    ),
                  ),
                ),
                _buildBottom(keyboardOpen),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// While the keyboard is up the primary action stays out of the way — the
  /// user moves between fields with the keyboard's own next/done key. Number
  /// pads get a Done bar instead, since they have no return key.
  Widget _buildBottom(bool keyboardOpen) {
    if (keyboardOpen) {
      if (!_numericFieldFocused) return const SizedBox.shrink();
      return Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: TextHolder(
                title: 'Done',
                size: 16,
                fontWeight: FontWeight.w800,
                color: CarePlanColor.orange,
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.footnote != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  size: 15,
                  color: CarePlanColor.grey_3,
                ),
                const Gap(8),
                Expanded(
                  child: TextHolder(
                    title: widget.footnote!,
                    size: 12,
                    fontHeight: 1.4,
                    color: CarePlanColor.grey_3,
                  ),
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: CustomButtom(
            title: widget.buttonTitle ?? Strings.cotinue,
            onTap: widget.onContinue,
          ),
        ),
      ],
    );
  }
}

/// A labelled block inside a KYC step — used for inputs that are not a
/// [CustomTextField], so they still line up with the rest of the form.
class KycFieldLabel extends StatelessWidget {
  const KycFieldLabel({super.key, required this.title, this.error});

  final String title;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextHolder(
          title: title,
          size: 15,
          fontWeight: FontWeight.w500,
          color: CarePlanColor.grey_2,
        ),
        if (error != null) ...[
          const Gap(2),
          TextHolder(
            title: error!,
            size: 12,
            color: const Color(0xFFC0392B),
          ),
        ],
      ],
    );
  }
}
