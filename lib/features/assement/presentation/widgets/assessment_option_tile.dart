import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AssessmentOptionTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const AssessmentOptionTile({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? CarePlanColor.light_orange : Colors.white,
          border: Border.all(
            color:
                isSelected ? CarePlanColor.orange : const Color(0xFFE0E0E0),
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? CarePlanColor.orange
                      : CarePlanColor.grey,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: CarePlanColor.orange,
                        ),
                      ),
                    )
                  : null,
            ),
            const Gap(12),
            Expanded(
              child: TextHolder(
                title: label,
                size: 14,
                fontWeight: FontWeight.w500,
                color: CarePlanColor.black_3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
