import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/auth/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AccountHeader extends StatelessWidget {
  final double width;
  final UserModel? user;

  const AccountHeader({super.key, required this.width, this.user});

  String get _displayName {
    if (user?.firstName != null || user?.lastName != null) {
      return "${user?.firstName ?? ''} ${user?.lastName ?? ''}".trim();
    }
    return "User";
  }

  String get _displayEmail => user?.email ?? "";

  String get _initials {
    final first = user?.firstName?.isNotEmpty == true ? user!.firstName![0] : '';
    final last = user?.lastName?.isNotEmpty == true ? user!.lastName![0] : '';
    if (first.isNotEmpty || last.isNotEmpty) return "$first$last".toUpperCase();
    return "?";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: CarePlanColor.light_orange,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              width: 100,
              height: 100,
              color: CarePlanColor.light_orange,
              child: Center(
                child: TextHolder(
                  title: _initials,
                  fontWeight: FontWeight.w800,
                  color: CarePlanColor.brown,
                  size: 32,
                ),
              ),
            ),
          ),
        ),
        const Gap(15),
        TextHolder(
          title: _displayName,
          fontWeight: FontWeight.w800,
          color: CarePlanColor.brown,
          size: 20,
        ),
        const Gap(5),
        TextHolder(
          title: _displayEmail,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF666666),
          size: 14,
        ),
      ],
    );
  }
}
