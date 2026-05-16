import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/assets.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/auth/data/model/user_model.dart';
import 'package:careplan/features/notifications/presentation/pages/notification_center_screen.dart';
import 'package:careplan/features/notifications/presentation/state/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class HomeGreetingHeader extends StatelessWidget {
  final UserModel? user;

  const HomeGreetingHeader({super.key, required this.user});

  String _firstName() {
    final first = user?.firstName?.trim();
    if (first != null && first.isNotEmpty) return first;
    return "there";
  }

  String _initials() {
    final first =
        (user?.firstName?.isNotEmpty ?? false) ? user!.firstName![0] : '';
    final last =
        (user?.lastName?.isNotEmpty ?? false) ? user!.lastName![0] : '';
    final initials = "$first$last".toUpperCase();
    return initials.isEmpty ? "?" : initials;
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good morning";
    if (hour < 17) return "Good afternoon";
    return "Good evening";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: CarePlanColor.light_orange,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: TextHolder(
              title: _initials(),
              color: CarePlanColor.brown,
              size: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextHolder(
                  title: _greeting(),
                  color: CarePlanColor.grey_3,
                  size: 12,
                  fontWeight: FontWeight.w600,
                ),
                const Gap(2),
                TextHolder(
                  title: "${_firstName()} 👋",
                  size: 20,
                  fontWeight: FontWeight.w800,
                  color: CarePlanColor.brown,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Gap(8),
          const _NotificationBellButton(),
        ],
      ),
    );
  }
}

class _NotificationBellButton extends StatelessWidget {
  const _NotificationBellButton();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => router.push(const NotificationCenterScreen()),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Consumer<NotificationProvider>(
            builder: (context, notifProvider, child) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  SvgPicture.asset(
                    Assets.notification_icon,
                    color: CarePlanColor.grey,
                  ),
                  if (notifProvider.unreadCount > 0)
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        decoration: const BoxDecoration(
                          color: CarePlanColor.orange,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            notifProvider.unreadCount > 99
                                ? '99+'
                                : '${notifProvider.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'avenir',
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
