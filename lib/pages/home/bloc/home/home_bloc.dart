import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'home_event.dart';
part 'home_state.dart';

/// a BloC class to manage the different states of home page
/// and how different events trigger different states
/// [HomeState] a base class that all home states originate from
/// [HomeEvent] a base class that all home events originate from
///
/// Event can be one of:
/// * [HomeErrorEvent]
///   When an error happens (due to connection errors for example)
/// * [HomeLoadEvent]
///   When the home is loaded and ready to view its store / offers content
/// * [ChangeActiveTabEvent]
///   When the active tab is changed
/// * [FiltersVisibilityChanged]
///   When the filters inside the Home display changes
///   may add an event in the future for when the values
///   inside them changes.
/// * [LocationChanged]
///   When the location changes, this even will trigger
///
/// Home State can be one of:
/// * [InitialHomeState]
///   First state for the app, only once when its just fired up
/// * [LoadedHomeState]
///   When the home is ready to display the store
/// * [ErrorHomeState]
///   When any error happens will change to this state
///
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(InitialHomeState()) {
    on<HomeErrorEvent>((event , emit){
      emit(ErrorHomeState());
    });

    on<HomeLoadEvent>((event , emit){
      emit(LoadedHomeState());
    });

    on<ChangeActiveTabEvent>((event, emit) {
      emit((state as LoadedHomeState).copyWith(activeTab: event.tabIndex));
    });

    on<FiltersVisibilityChanged>((event, emit) {
      emit((state as LoadedHomeState).copyWith(filtersDisplayed: event.visible));
    });

    on<LocationChanged>((event, emit) {
      emit((state as LoadedHomeState).copyWith(currentCity: event.city , currentLocation: event.location));
    });
  }
}
