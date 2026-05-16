import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CopeRatingPicker extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const CopeRatingPicker({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6E6E6)),
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextHolder(
            title: "Ability to cope (1-10)",
            color: CarePlanColor.grey,
            fontWeight: FontWeight.w700,
            size: 14,
          ),
          const Gap(8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: CarePlanColor.orange),
              borderRadius: BorderRadius.circular(8),
              color: CarePlanColor.light_orange.withValues(alpha: 0.25),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              underline: const SizedBox(),
              style: const TextStyle(
                color: CarePlanColor.brown,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              iconEnabledColor: CarePlanColor.brown,
              items: const ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10']
                  .map<DropdownMenuItem<String>>(
                    (v) => DropdownMenuItem(value: v, child: Text(v)),
                  )
                  .toList(),
              onChanged: (newValue) {
                if (newValue == null) return;
                onChanged(newValue);
              },
            ),
          ),
        ],
      ),
    );
  }
}
