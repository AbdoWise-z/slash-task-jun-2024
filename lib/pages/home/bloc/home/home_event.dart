part of 'home_bloc.dart';

/// a file that contains all of the events definitions
/// see home_bloc.dart for their explanation
@immutable
sealed class HomeEvent {}

class HomeErrorEvent extends HomeEvent{}

class HomeLoadEvent extends HomeEvent{}

class ChangeActiveTabEvent extends HomeEvent {
  final int tabIndex;

  ChangeActiveTabEvent({required this.tabIndex});
}

class FiltersVisibilityChanged extends HomeEvent {
  final bool visible;
  FiltersVisibilityChanged({required this.visible});
}

class LocationChanged extends HomeEvent {
  final String location;
  final String city;

  LocationChanged({required this.location, required this.city});
}



