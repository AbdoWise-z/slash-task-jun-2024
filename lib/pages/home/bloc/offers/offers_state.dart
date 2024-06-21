part of 'offers_bloc.dart';

@immutable
sealed class OffersState {}

final class OffersInitial extends OffersState {}
final class OffersLoaded extends OffersState {
  final List<OfferModel>? data;

  OffersLoaded({required this.data});
}
