import 'dart:async';


import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:slash_task/pages/home/models/offers.model.dart';
import 'package:slash_task/pages/home/repo/home.repo.dart';

part 'offers_event.dart';
part 'offers_state.dart';

class OffersBloc extends Bloc<OffersEvent, OffersState> {
  OffersBloc() : super(OffersInitial()) {
    on<LoadOffersEvent>((event, emit) => _loadOffers(event, emit));
  }

  FutureOr<void> _loadOffers(OffersEvent event, Emitter<OffersState> emit) async {
    var res = await HomeRepo.loadOffers();
    emit(OffersLoaded(data: res.data));
  }
}
