part of 'offers_bloc.dart';

@immutable
sealed class OffersState {}

final class OffersInitialState extends OffersState {}

final class OffersErrorState extends OffersState {}

final class OffersLoadedState extends OffersState {
  final List<OfferModel>? data;

  OffersLoadedState({required this.data});
}
