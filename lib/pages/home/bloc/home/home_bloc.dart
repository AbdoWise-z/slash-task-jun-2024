import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, BaseHomeState> {
  HomeBloc() : super(InitialHomeState()) {
    on<HomeErrorEvent>((event , emit){
      emit(ErrorHomeState());
    });

    on<HomeLoadEvent>((event , emit){
      emit(HomeState());
    });

    on<ChangeActiveTabEvent>((event, emit) {
      emit((state as HomeState).copyWith(activeTab: event.tabIndex));
    });

    on<FiltersVisibilityChanged>((event, emit) {
      print("Changing to : ${event.visible}");
      emit((state as HomeState).copyWith(filtersDisplayed: event.visible));
    });

    on<LocationChanged>((event, emit) {
      emit((state as HomeState).copyWith(currentCity: event.city , currentLocation: event.location));
    });
  }
}
