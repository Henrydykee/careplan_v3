import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/assets.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/core/resources/string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class SelectStressAreasScreen extends StatelessWidget {
  const SelectStressAreasScreen({super.key});

  static const _mockWork = true;
  static const _mockRelationship = false;
  static const _mockFinances = true;
  static const _mockPhysicalHealth = false;
  static const _mockAlcohol = false;
  static const _mockTrauma = false;
  static const _mockHousing = false;
  static const _mockSchool = false;
  static const _mockCopeRating = '5';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackIcon: true,
        color: CarePlanColor.brown,
        backButtonColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: TextHolder(
                        title: "Identify your stressors",
                        size: 20,
                        fontWeight: FontWeight.w800,
                        color: CarePlanColor.grey,
                      ),
                    ),
                    Gap(5),
                    TextHolder(
                      title: "Please select areas that apply",
                      size: 15,
                    ),
                    Gap(12),
                    SvgPicture.asset(Assets.stress_image),
                    Gap(5),
                    _StressArea(title: "Work", color: CarePlanColor.light_orange, value: _mockWork),
                    Gap(5),
                    _StressArea(title: "Relationship", value: _mockRelationship),
                    Gap(5),
                    _StressArea(title: "Finances", color: CarePlanColor.light_orange, value: _mockFinances),
                    Gap(5),
                    _StressArea(title: "Physical health or pain", value: _mockPhysicalHealth),
                    Gap(5),
                    _StressArea(title: "Alcohol or drugs", color: CarePlanColor.light_orange, value: _mockAlcohol),
                    Gap(5),
                    _StressArea(title: "Trauma", value: _mockTrauma),
                    Gap(5),
                    _StressArea(title: "Housing", color: CarePlanColor.light_orange, value: _mockHousing),
                    Gap(5),
                    _StressArea(title: "School", value: _mockSchool),
                    Gap(20),
                    TextHolder(
                      title: "Rate your ability to cope with your stressors:",
                      color: CarePlanColor.grey,
                      fontWeight: FontWeight.w800,
                      size: 15,
                    ),
                    Gap(10),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: CarePlanColor.orange),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: DropdownButton<String>(
                          value: _mockCopeRating,
                          isExpanded: true,
                          underline: const SizedBox(),
                          style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                          iconEnabledColor: Colors.black,
                          items: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10']
                              .map<DropdownMenuItem<String>>(
                                (v) => DropdownMenuItem(value: v, child: Text(v)),
                              )
                              .toList(),
                          onChanged: (_) {},
                        ),
                      ),
                    ),
                    Gap(40),
                  ],
                ),
              ),
            ),
            CustomButtom(
              title: Strings.cotinue,
              onTap: () {},
            ),
            Gap(30),
          ],
        ),
      ),
    );
  }
}

class _StressArea extends StatelessWidget {
  final String title;
  final Color? color;
  final bool value;

  const _StressArea({required this.title, this.color, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: color ?? CarePlanColor.app_bar_color,
      ),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: (_) {},
            activeColor: CarePlanColor.green,
          ),
          TextHolder(
            title: title,
            color: CarePlanColor.grey,
            size: 15,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
