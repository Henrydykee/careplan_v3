import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/loading_shimmers/base_shimmer.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/notifications/data/models/notification_model.dart';
import 'package:careplan/features/notifications/presentation/state/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotificationCenterScreen extends StatefulWidget {
  const NotificationCenterScreen({Key? key}) : super(key: key);

  @override
  State<NotificationCenterScreen> createState() =>
      _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends State<NotificationCenterScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().fetchNotifications();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<NotificationProvider>().loadMore();
    }
  }

  String _formatTimestamp(String? timestamp) {
    if (timestamp == null) return '';
    try {
      final date = DateTime.parse(timestamp).toLocal();
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays == 1) return 'Yesterday';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (_) {
      return '';
    }
  }

  String _dateGroupLabel(String? timestamp) {
    if (timestamp == null) return '';
    try {
      final date = DateTime.parse(timestamp).toLocal();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final dateOnly = DateTime(date.year, date.month, date.day);

      if (dateOnly == today) return 'Today';
      if (dateOnly == today.subtract(const Duration(days: 1))) {
        return 'Yesterday';
      }
      if (now.difference(date).inDays < 7) return 'This Week';
      return DateFormat('MMMM yyyy').format(date);
    } catch (_) {
      return '';
    }
  }

  /// Builds a grouped list of notifications with section headers.
  List<Widget> _buildGroupedList(List<NotificationModel> notifications) {
    final List<Widget> widgets = [];
    String? lastGroup;

    for (final notification in notifications) {
      final group = _dateGroupLabel(notification.timestamp);
      if (group != lastGroup) {
        lastGroup = group;
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 8),
            child: TextHolder(
              title: group,
              color: CarePlanColor.grey_3,
              fontWeight: FontWeight.w600,
              size: 13,
            ),
          ),
        );
      }
      widgets.add(_buildNotificationItem(notification));
    }

    return widgets;
  }

  Widget _buildNotificationItem(NotificationModel notification) {
    final isUnread = notification.isRead == false;
    final hasTitle = notification.title != null && notification.title!.isNotEmpty;
    final hasMessage =
        notification.message != null && notification.message!.isNotEmpty;

    return Dismissible(
      key: Key(notification.id ?? UniqueKey().toString()),
      direction: isUnread
          ? DismissDirection.endToStart
          : DismissDirection.none,
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
        if (notification.id != null) {
          await context
              .read<NotificationProvider>()
              .markAsRead(notificationIds: [notification.id!]);
        }
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
            if (isUnread && notification.id != null) {
              context
                  .read<NotificationProvider>()
                  .markAsRead(notificationIds: [notification.id!]);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
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
                    color: isUnread ? CarePlanColor.orange : CarePlanColor.grey_3,
                    size: 20,
                  ),
                ),
                const Gap(12),
                // Content
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
                            title: _formatTimestamp(notification.timestamp),
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
                                color:
                                    CarePlanColor.orange.withValues(alpha: 0.15),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CarePlanColor.app_bar_color,
      appBar: CustomAppBar(
        title: "Notifications",
        showBackIcon: true,
        widget: Consumer<NotificationProvider>(
          builder: (context, provider, _) {
            if (provider.unreadCount == 0) return const SizedBox.shrink();
            return GestureDetector(
              onTap: () => provider.markAllAsRead(),
              child: TextHolder(
                title: "Mark all read",
                color: CarePlanColor.brown,
                fontWeight: FontWeight.w600,
                size: 12,
              ),
            );
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            context.read<NotificationProvider>().fetchNotifications(),
        color: CarePlanColor.brown,
        child: Consumer<NotificationProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading && provider.notifications.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [_buildLoadingShimmer()],
              );
            }

            if (provider.hasError && provider.notifications.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 60),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.wifi_off_rounded,
                            color: Colors.red,
                            size: 32,
                          ),
                        ),
                        const Gap(20),
                        TextHolder(
                          title: "Couldn't load notifications",
                          color: CarePlanColor.grey,
                          size: 16,
                          fontWeight: FontWeight.w600,
                          align: TextAlign.center,
                        ),
                        const Gap(8),
                        TextHolder(
                          title: provider.errorMessage,
                          color: CarePlanColor.grey_3,
                          size: 13,
                          align: TextAlign.center,
                        ),
                        const Gap(24),
                        GestureDetector(
                          onTap: () => provider.fetchNotifications(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              color: CarePlanColor.brown,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: TextHolder(
                              title: "Try again",
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            if (provider.notifications.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 80),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: CarePlanColor.light_orange,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Icon(
                            Icons.notifications_none_rounded,
                            color: CarePlanColor.orange,
                            size: 40,
                          ),
                        ),
                        const Gap(20),
                        TextHolder(
                          title: "No notifications yet",
                          color: CarePlanColor.grey,
                          size: 18,
                          fontWeight: FontWeight.w700,
                          align: TextAlign.center,
                        ),
                        const Gap(8),
                        TextHolder(
                          title: "You're all caught up!",
                          color: CarePlanColor.grey_3,
                          size: 14,
                          align: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            final groupedWidgets = _buildGroupedList(provider.notifications);

            return ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 24),
              itemCount:
                  groupedWidgets.length + (provider.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == groupedWidgets.length) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: CarePlanColor.brown,
                        ),
                      ),
                    ),
                  );
                }
                return groupedWidgets[index];
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return BaseShimmer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ShimmerBox(
              height: 16,
              width: 60,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            const Gap(12),
            ...List.generate(
              6,
              (_) => const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: ShimmerBox(
                  height: 88,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
