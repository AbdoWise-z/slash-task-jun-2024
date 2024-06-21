import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<ChangeActiveTabEvent>((event, emit) {
      emit(state.copyWith(activeTab: event.tabIndex));
    });

    on<FiltersVisibilityChanged>((event, emit) {
      print("Changing to : ${event.visible}");
      emit(state.copyWith(filtersDisplayed: event.visible));
    });

    on<LocationChanged>((event, emit) {
      emit(state.copyWith(currentCity: event.city , currentLocation: event.location));
    });
  }
}
