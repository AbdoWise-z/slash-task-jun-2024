part of 'offers_bloc.dart';

/// a base class that all Offers related states originate from
@immutable
sealed class OffersState {}

/// a class that represents the initial state for offers
final class OffersInitialState extends OffersState {}

/// a class that represents a state where an error happened
/// while loading the offers
final class OffersErrorState extends OffersState {}

/// a class that represents a state where the offers has been
/// loaded successfully
/// [data] the offers' data that were loaded from the server
final class OffersLoadedState extends OffersState {
  final List<OfferModel>? data;

  OffersLoadedState({required this.data});
}
