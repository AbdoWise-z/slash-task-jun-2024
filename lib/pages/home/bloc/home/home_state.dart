part of 'home_bloc.dart';

/// base class for all home states in the app
sealed class HomeState extends Equatable {}

/// the initial state for home
class InitialHomeState extends HomeState {
  @override
  List<Object?> get props => [];
}

/// state when an error happens
class ErrorHomeState extends HomeState {
  @override
  List<Object?> get props => [];
}

/// state that represents when the home is ready
///
/// [activeTab] the current active tab
/// [filtersDisplayed] weather or not the filters section is active
/// [currentLocation] the currently selected location
/// [currentCity] the currently selected city
class LoadedHomeState extends HomeState {
  final int activeTab;
  final bool filtersDisplayed;
  final String currentLocation;
  final String currentCity;
  final List<ShopItemModel> cart;

  LoadedHomeState({
    this.cart = const [],
    this.activeTab = 0,
    this.filtersDisplayed = false,
    this.currentLocation = "Naser City",
    this.currentCity = "Cairo",
  });

  LoadedHomeState copyWith({
    int? activeTab,
    bool? filtersDisplayed,
    String? currentLocation,
    String? currentCity,
    List<ShopItemModel>? cart,
  }) {
    return LoadedHomeState(
      activeTab: activeTab ?? this.activeTab,
      filtersDisplayed: filtersDisplayed ?? this.filtersDisplayed,
      currentLocation: currentLocation ?? this.currentLocation,
      currentCity: currentCity ?? this.currentCity,
      cart: cart ?? this.cart,
    );
  }

  @override
  List<Object?> get props => [activeTab, filtersDisplayed, currentLocation, currentCity];
}


