part of 'notifications_bloc.dart';

/// see notifications_bloc.dart for more information
sealed class NotificationsState {}

final class NotificationsInitialState extends NotificationsState {}

final class LoadedNotificationsState extends NotificationsState {
  List<NotificationModel> notifications = [];
  bool notifyUser = true;
}
