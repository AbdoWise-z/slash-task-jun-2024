part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

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



