import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:slash_task/pages/home/models/notification.model.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

///
/// this class is created to manage the state of the notifications
/// its not complete due to the fact that the document didn't provide
/// any details about how notifications should be handled, for now, I'm
/// assuming two states [NotificationsInitialState] which is the initial state
/// for notifications and [LoadedNotificationsState] which is when we loaded
/// the notifications from a server for example.
class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc() : super(NotificationsInitialState()) {
    on<InitNotificationsEvent>((event, emit) async {
      // simulate the notifications being loaded from a server
      await Future.delayed(const Duration(milliseconds: 3000));
      emit(LoadedNotificationsState());
      print("Loaded and made new state");
      //after this you may want to connect to a websocket to load new notifications when they are ready
    });
  }
}
