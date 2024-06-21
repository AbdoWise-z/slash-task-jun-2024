part of 'offers_bloc.dart';

/// a base class for all offers related events
@immutable
sealed class OffersEvent {}

/// a class that represents an event that triggers the action of
/// loading the offers from the server
final class LoadOffersEvent extends OffersEvent {}
