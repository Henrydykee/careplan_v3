import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/notifications/data/models/notification_model.dart';
import 'package:careplan/features/notifications/presentation/state/notification_provider.dart';
import 'package:careplan/features/notifications/presentation/widgets/notification_time_helpers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class NotificationListItem extends StatelessWidget {
  final NotificationModel notification;

  const NotificationListItem({super.key, required this.notification});

  void _markRead(BuildContext context) {
    if (notification.id != null) {
      context
          .read<NotificationProvider>()
          .markAsRead(notificationIds: [notification.id!]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUnread = notification.isRead == false;
    final hasTitle =
        notification.title != null && notification.title!.isNotEmpty;
    final hasMessage =
        notification.message != null && notification.message!.isNotEmpty;

    return Dismissible(
      key: Key(notification.id ?? UniqueKey().toString()),
      direction:
          isUnread ? DismissDirection.endToStart : DismissDirection.none,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(
          color: CarePlanColor.green,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.done_all_rounded, color: Colors.white, size: 22),
      ),
      confirmDismiss: (_) async {
        _markRead(context);
        return false;
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(
          color: isUnread ? CarePlanColor.light_orange : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUnread
                ? CarePlanColor.orange.withValues(alpha: 0.25)
                : CarePlanColor.grey_5,
            width: 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            if (isUnread) _markRead(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isUnread
                        ? CarePlanColor.orange.withValues(alpha: 0.15)
                        : CarePlanColor.grey_5.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.notifications_outlined,
                    color: isUnread
                        ? CarePlanColor.orange
                        : CarePlanColor.grey_3,
                    size: 20,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hasTitle)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: TextHolder(
                            title: notification.title!,
                            color: CarePlanColor.grey,
                            fontWeight:
                                isUnread ? FontWeight.w800 : FontWeight.w600,
                            size: 14,
                            maxLines: 2,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                        ),
                      if (hasMessage)
                        TextHolder(
                          title: notification.message!,
                          color: isUnread
                              ? CarePlanColor.grey_2
                              : CarePlanColor.grey_3,
                          fontWeight:
                              isUnread ? FontWeight.w500 : FontWeight.w400,
                          size: 13,
                          maxLines: 3,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      const Gap(8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 13,
                            color: CarePlanColor.grey_3,
                          ),
                          const Gap(4),
                          TextHolder(
                            title: formatNotificationTimestamp(
                                notification.timestamp),
                            color: CarePlanColor.grey_3,
                            fontWeight: FontWeight.w400,
                            size: 12,
                          ),
                          const Spacer(),
                          if (isUnread)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: CarePlanColor.orange
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextHolder(
                                title: "New",
                                color: CarePlanColor.orange,
                                fontWeight: FontWeight.w700,
                                size: 10,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
