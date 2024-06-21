import 'dart:async';


import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:slash_task/pages/home/models/offers.model.dart';
import 'package:slash_task/pages/home/repo/home.repo.dart';

part 'offers_event.dart';
part 'offers_state.dart';


/// a BloC class that manages the state of the offers section inside the home page
/// it only features 3 states:
/// * [OffersInitialState]
///   when the offers is to be loaded
/// * [OffersLoadedState]
///   when the offers has been loaded successfully
/// * [OffersErrorState]
///   when there was an error while loading the offers from the server
///
/// there is only one event for this BloC, which is [LoadOffersEvent]
/// which triggers an action that tries to load the offers from the
/// server and change the state into either [OffersErrorState] or
/// [OffersLoadedState] depending on its outcome.
///
class OffersBloc extends Bloc<OffersEvent, OffersState> {
  OffersBloc() : super(OffersInitialState()) {
    on<LoadOffersEvent>((event, emit) => _loadOffers(event, emit));
  }

  FutureOr<void> _loadOffers(OffersEvent event, Emitter<OffersState> emit) async {
    emit(OffersInitialState());
    var res = await HomeRepo.loadOffers();
    if (res.data == null){
      emit(OffersErrorState());
    } else {
      emit(OffersLoadedState(data: res.data));
    }
  }
}
