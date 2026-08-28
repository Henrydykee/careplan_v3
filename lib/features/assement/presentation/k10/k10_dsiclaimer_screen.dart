import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/assets.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/assement/presentation/test_screens/k10_test_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class K10DisclaimerScreen extends StatelessWidget {
  const K10DisclaimerScreen({super.key});

  static const String _disclaimerText =
      'The Kessler Psychological Distress Scale (K10) is a tool designed to '
      'identify clinically significant psychological distress and is widely used '
      'by General Practitioners and other mental health providers in Australia. '
      'The K10 uses a single total score and is a handy self assessment tool to '
      'track symptoms during the course of treatment. '
      'Kessler, R.C., Andrews, G., Colpe, L.J. et al. (2002) Short screening scales '
      'to monitor population prevalences and trends in non-specific psychological '
      'distress. Psychological Medicine, 32, 959–956.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCF8),
      appBar: CustomAppBar(
        title: 'K10 Assessment',
        showBackIcon: true,
        color: const Color(0xFFFFFCF8),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: CarePlanColor.light_orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SvgPicture.asset(Assets.info_icon, width: 42),
                  ),
                  const Gap(22),
                  TextHolder(
                    title: 'Before you begin',
                    size: 28,
                    fontWeight: FontWeight.w700,
                    color: CarePlanColor.deep_green,
                  ),
                  const Gap(8),
                  TextHolder(
                    title:
                        'This short check-in helps you reflect on how you have been feeling recently.',
                    size: 16,
                    fontHeight: 1.45,
                    color: CarePlanColor.black_3,
                  ),
                  const Gap(20),
                  const _AssessmentSummary(),
                  const Gap(24),
                  const _SectionHeading(title: 'About this assessment'),
                  const Gap(10),
                  TextHolder(
                    title:
                        'The Kessler Psychological Distress Scale (K10) is a 10-question screening tool used to identify signs of psychological distress.',
                    size: 14,
                    fontHeight: 1.5,
                    color: CarePlanColor.black_3,
                  ),
                  const Gap(20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF5E8),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF0D3AF)),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.health_and_safety_outlined,
                          color: CarePlanColor.brown,
                          size: 21,
                        ),
                        Gap(12),
                        Expanded(
                          child: _NoticeText(),
                        ),
                      ],
                    ),
                  ),
                  const Gap(24),
                  const _SectionHeading(title: 'How to get the most from it'),
                  const Gap(12),
                  const _GuidanceItem(
                    number: '1',
                    text: 'Answer based on how you have felt over the past four weeks.',
                  ),
                  const Gap(12),
                  const _GuidanceItem(
                    number: '2',
                    text: 'Choose the response that feels most accurate for you today.',
                  ),
                  const Gap(12),
                  const _GuidanceItem(
                    number: '3',
                    text: 'Your result is a conversation starter, not a diagnosis.',
                  ),
                  const Gap(26),
                  const _SourceDetails(),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFECE6DE)),
                ),
              ),
              child: SizedBox(
                height: 54,
                width: double.infinity,
                child: Material(
                  color: CarePlanColor.brown,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => router.push(const K10TestScreen()),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Start K10 assessment',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'avenir',
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          Gap(8),
                          Icon(Icons.arrow_forward_rounded,
                              color: Colors.white, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AssessmentSummary extends StatelessWidget {
  const _AssessmentSummary();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFECE6DE)),
      ),
      child: const Row(
        children: [
          _SummaryItem(icon: Icons.format_list_numbered_rounded, label: '10 questions'),
          SizedBox(height: 34, child: VerticalDivider(color: Color(0xFFECE6DE))),
          _SummaryItem(icon: Icons.schedule_outlined, label: 'About 2 minutes'),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SummaryItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: CarePlanColor.brown, size: 20),
          const Gap(7),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                color: CarePlanColor.deep_green,
                fontFamily: 'avenir',
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String title;

  const _SectionHeading({required this.title});

  @override
  Widget build(BuildContext context) {
    return TextHolder(
      title: title,
      size: 17,
      fontWeight: FontWeight.w700,
      color: CarePlanColor.deep_green,
    );
  }
}

class _NoticeText extends StatelessWidget {
  const _NoticeText();

  @override
  Widget build(BuildContext context) {
    return Text(
      'The K10 is a screening tool, not a clinical diagnosis. If you are worried about your mental health, please speak with a qualified healthcare professional.',
      style: TextStyle(
        color: CarePlanColor.grey_2,
        fontFamily: 'avenir',
        fontSize: 13,
        height: 1.45,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _GuidanceItem extends StatelessWidget {
  final String number;
  final String text;

  const _GuidanceItem({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: CarePlanColor.brown,
            shape: BoxShape.circle,
          ),
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'avenir',
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const Gap(12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: CarePlanColor.black_3,
              fontFamily: 'avenir',
              fontSize: 14,
              height: 1.45,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _SourceDetails extends StatelessWidget {
  const _SourceDetails();

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(bottom: 4),
      iconColor: CarePlanColor.brown,
      collapsedIconColor: CarePlanColor.brown,
      title: const Text(
        'About the K10 scale',
        style: TextStyle(
          color: CarePlanColor.brown,
          fontFamily: 'avenir',
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      children: [
        TextHolder(
          title: K10DisclaimerScreen._disclaimerText,
          size: 12,
          fontHeight: 1.5,
          color: CarePlanColor.black_3,
        ),
      ],
    );
  }
}
