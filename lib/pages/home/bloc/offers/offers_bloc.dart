import 'dart:async';


import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:slash_task/pages/home/models/offers.model.dart';
import 'package:slash_task/pages/home/repo/home.repo.dart';

part 'offers_event.dart';
part 'offers_state.dart';

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
