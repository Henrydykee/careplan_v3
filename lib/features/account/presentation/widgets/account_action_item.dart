import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AccountActionItems extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final String? subTitle;
  final Color? color;
  final Function? onTap;
  final Widget? trailing;

  const AccountActionItems({
    super.key,
    this.icon,
    this.title,
    this.subTitle,
    this.color,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            if (icon != null)
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: CarePlanColor.light_orange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: CarePlanColor.brown),
              ),
            if (icon != null) const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextHolder(
                    title: title ?? "",
                    fontWeight: FontWeight.w700,
                    color: CarePlanColor.brown,
                    size: 15,
                  ),
                  const Gap(3),
                  TextHolder(
                    title: subTitle ?? "",
                    fontWeight: FontWeight.w400,
                    size: 13,
                    color: CarePlanColor.grey_3,
                  ),
                ],
              ),
            ),
            trailing ??
                Icon(Icons.chevron_right_rounded,
                    color: CarePlanColor.grey_3, size: 22),
          ],
        ),
      ),
    );
  }
}
