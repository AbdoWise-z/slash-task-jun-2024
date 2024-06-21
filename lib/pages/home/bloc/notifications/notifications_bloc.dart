import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:slash_task/pages/home/models/notification.model.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc() : super(NotificationsInitial()) {
    on<InitNotificationsEvent>((event, emit) async {
      // simulate the notifications being loaded from a server
      await Future.delayed(const Duration(milliseconds: 3000));
      emit(NotificationsLoaded());
      print("Loaded and made new state");
      //after this you may want to connect to a websocket to load new notifications when they are ready
    });
  }
}
