part of 'shop_items_bloc.dart';

/// a class that all shop states originates from
@immutable
sealed class ShopItemsState extends Equatable {}

/// shop's first state, it represents a shop that needs its data
/// to be loaded
final class ShopStateInitial        extends ShopItemsState {
  @override
  List<Object?> get props => [];
}

/// a shop state that represents that their was an error while
/// loading the shop data
final class ShopItemsStateLoadError extends ShopItemsState {
  @override
  List<Object?> get props => [];
}

/// a state that represents a shop that is loaded from the server
/// [items] the items inside the shop
/// [loadingMore] weather or not this shop is trying to load more data from the server
final class ShopStateLoaded         extends ShopItemsState {
  final List<ShopItemModel> items;
  final bool loadingMore;
  ShopStateLoaded({required this.items, required this.loadingMore});

  @override
  List<Object?> get props => [...items , loadingMore];

  ShopStateLoaded copyWith({
    List<ShopItemModel>? items,
    bool? loadingMore,
  }) {
    return ShopStateLoaded(
      items: items ?? this.items,
      loadingMore: loadingMore ?? this.loadingMore,
    );
  }
}