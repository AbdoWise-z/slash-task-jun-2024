part of 'shop_items_bloc.dart';

@immutable
sealed class ShopItemsEvent<T extends ShopItem> {}

final class LoadShopItemsEvent<T extends ShopItem> extends ShopItemsEvent<T> {
  LoadShopItemsEvent();
}

final class LoadMoreShopItemsEvent<T extends ShopItem> extends ShopItemsEvent<T> {
  LoadMoreShopItemsEvent();
}

final class LikeItemEvent<T extends ShopItem> extends ShopItemsEvent<T> {
  final ShopItemModel item;
  LikeItemEvent(this.item);
}

final class UnLikeItemEvent<T extends ShopItem> extends ShopItemsEvent<T> {
  final ShopItemModel item;
  UnLikeItemEvent(this.item);
}

final class AddToCartEvent<T extends ShopItem> extends ShopItemsEvent<T> {
  final ShopItemModel item;
  AddToCartEvent(this.item);
}
