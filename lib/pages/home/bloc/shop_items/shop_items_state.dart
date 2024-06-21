part of 'shop_items_bloc.dart';

@immutable
sealed class ShopItemsState extends Equatable {}

final class ShopStateInitial        extends ShopItemsState {
  @override
  List<Object?> get props => [];
}

final class ShopItemsStateLoadError extends ShopItemsState {
  @override
  List<Object?> get props => [];
}

final class ShopStateLoaded         extends ShopItemsState {
  final List<ShopItemModel> items;
  final List<ShopItemModel> cart;
  final bool loadingMore;
  ShopStateLoaded({required this.cart, required this.items, required this.loadingMore});

  @override
  List<Object?> get props => [...items , loadingMore];

  ShopStateLoaded copyWith({
    List<ShopItemModel>? items,
    List<ShopItemModel>? cart,
    bool? loadingMore,
  }) {
    return ShopStateLoaded(
      items: items ?? this.items,
      loadingMore: loadingMore ?? this.loadingMore,
      cart: cart ?? this.cart
    );
  }
}