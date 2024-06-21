part of 'notifications_bloc.dart';

sealed class NotificationsState {}

final class NotificationsInitial extends NotificationsState {}


final class NotificationsLoaded extends NotificationsState {
  List<NotificationModel> notifications = [];
  bool notifyUser = true;
}
