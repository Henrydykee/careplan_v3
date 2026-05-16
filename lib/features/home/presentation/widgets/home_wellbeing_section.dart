import 'package:careplan/core/presentation/widgets/home_screen_widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomeWellbeingSection extends StatelessWidget {
  final bool visible;
  final String question;
  final Future<void> Function(String mood) onMoodSelected;

  const HomeWellbeingSection({
    super.key,
    required this.visible,
    required this.question,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: visible
            ? Column(
                key: const ValueKey('wellbeing-visible'),
                children: [
                  const Gap(20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: WellbeingCheckIn(
                      question: question,
                      onMoodSelected: onMoodSelected,
                    ),
                  ),
                  const Gap(24),
                ],
              )
            : const SizedBox(
                key: ValueKey('wellbeing-hidden'),
                width: double.infinity,
                height: 20,
              ),
      ),
    );
  }
}
