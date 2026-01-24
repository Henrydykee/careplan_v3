import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/assets.dart';
import 'package:careplan/core/resources/color.dart';
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
      appBar: CustomAppBar(showBackIcon: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SvgPicture.asset(Assets.info_icon),
              const Gap(10),
              TextHolder(
                title: 'DISCLAIMER',
                fontWeight: FontWeight.w800,
                color: CarePlanColor.brown,
                size: 18,
              ),
              const Gap(10),
              TextHolder(
                title: _disclaimerText,
                size: 14,
                fontWeight: FontWeight.w500,
                color: CarePlanColor.black_3,
              ),
              const Gap(30),
              CustomButtom(
                title: 'Continue',
                btnColor: CarePlanColor.brown,
                onTap: () => Navigator.of(context).pop(),
              ),
              const Gap(30),
            ],
          ),
        ),
      ),
    );
  }
}
