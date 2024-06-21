part of 'shop_items_bloc.dart';

/// a base class that all Shop events originates from
@immutable
sealed class ShopItemsEvent<T extends ShopType> {}

/// an event that is triggered when we want to initially load the shop data
final class LoadShopItemsEvent<T extends ShopType> extends ShopItemsEvent<T> {
  LoadShopItemsEvent();
}

/// an event that is triggered when we want to load more shop data from the server
final class LoadMoreShopItemsEvent<T extends ShopType> extends ShopItemsEvent<T> {
  LoadMoreShopItemsEvent();
}

/// an event that is triggered when an item was liked from the user
/// [item] the item that was liked
final class LikeItemEvent<T extends ShopType> extends ShopItemsEvent<T> {
  final ShopItemModel item;
  LikeItemEvent(this.item);
}

/// an event that is triggered when an item was unliked from the user
/// [item] the item that was unliked
final class UnLikeItemEvent<T extends ShopType> extends ShopItemsEvent<T> {
  final ShopItemModel item;
  UnLikeItemEvent(this.item);
}


