import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/notifications/data/models/notification_model.dart';
import 'package:careplan/features/notifications/presentation/state/notification_provider.dart';
import 'package:careplan/features/notifications/presentation/widgets/notification_center_states.dart';
import 'package:careplan/features/notifications/presentation/widgets/notification_list_item.dart';
import 'package:careplan/features/notifications/presentation/widgets/notification_time_helpers.dart';
import 'package:flutter/material.dart';
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

  List<Widget> _buildGroupedList(List<NotificationModel> notifications) {
    final List<Widget> widgets = [];
    String? lastGroup;

    for (final notification in notifications) {
      final group = notificationDateGroupLabel(notification.timestamp);
      if (group != lastGroup) {
        lastGroup = group;
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(
                left: 20, right: 20, top: 20, bottom: 8),
            child: TextHolder(
              title: group,
              color: CarePlanColor.grey_3,
              fontWeight: FontWeight.w600,
              size: 13,
            ),
          ),
        );
      }
      widgets.add(NotificationListItem(notification: notification));
    }

    return widgets;
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
                children: const [NotificationLoadingShimmer()],
              );
            }

            if (provider.hasError && provider.notifications.isEmpty) {
              return NotificationErrorState(
                message: provider.errorMessage,
                onRetry: () => provider.fetchNotifications(),
              );
            }

            if (provider.notifications.isEmpty) {
              return const NotificationEmptyState();
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
}
