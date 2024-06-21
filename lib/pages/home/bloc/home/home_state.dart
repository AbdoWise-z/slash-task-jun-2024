part of 'home_bloc.dart';

sealed class BaseHomeState extends Equatable {}

class InitialHomeState extends BaseHomeState {
  @override
  List<Object?> get props => [];
}

class ErrorHomeState extends BaseHomeState {
  @override
  List<Object?> get props => [];
}

class HomeState extends BaseHomeState {
  final int activeTab;
  final bool filtersDisplayed;
  final String currentLocation;
  final String currentCity;

  HomeState({
    this.activeTab = 0,
    this.filtersDisplayed = false,
    this.currentLocation = "Naser City",
    this.currentCity = "Cairo",
  });

  HomeState copyWith({
    int? activeTab,
    bool? filtersDisplayed,
    String? currentLocation,
    String? currentCity,
  }) {
    return HomeState(
      activeTab: activeTab ?? this.activeTab,
      filtersDisplayed: filtersDisplayed ?? this.filtersDisplayed,
      currentLocation: currentLocation ?? this.currentLocation,
      currentCity: currentCity ?? this.currentCity,
    );
  }

  @override
  List<Object?> get props => [activeTab, filtersDisplayed, currentLocation, currentCity];
}


