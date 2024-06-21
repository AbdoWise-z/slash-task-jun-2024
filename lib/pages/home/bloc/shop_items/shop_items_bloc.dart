import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:slash_task/pages/home/models/shop_item.model.dart';
import 'package:slash_task/pages/home/repo/home.repo.dart';

part 'shop_items_event.dart';
part 'shop_items_state.dart';

sealed class ShopItem {}
class BestSellingShopItems extends ShopItem {}
class NewArrivalsShopItems extends ShopItem {}
class RecommendedShopItems extends ShopItem {}


class ShopItemsBloc<T extends ShopItem> extends Bloc<ShopItemsEvent<T>, ShopItemsState> {
  ShopItemsBloc() : super(ShopStateInitial()) {

    on<LoadShopItemsEvent<T>>(_loadShopInitial);

    on<LoadMoreShopItemsEvent<T>>((event , emit) async {
      emit(
          (state as ShopStateLoaded).copyWith(
              loadingMore: true
          )
      );
      print("Loading more $T");
      await _loadMoreShopItems(event , emit);
    });

    on<LikeItemEvent<T>>((event , emit) async {
      List<ShopItemModel> items = [];
      items.addAll((state as ShopStateLoaded).items);
      int index = items.indexOf(event.item);
      items[index] = items[index].copyWith(liked: true);
      emit((state as ShopStateLoaded).copyWith(items: items));
      print("Liked item $T");

      // simulate an API request here: (I assume it failed so I reset the like btn)
      // await Future.delayed(Duration(milliseconds: 1500));
      // items = [];
      // items.addAll((state as ShopStateLoaded).items);
      // items[index] = items[index].copyWith(liked: false);
      // print("Unliking item");
      // emit((state as ShopStateLoaded).copyWith(items: items));
    });

    on<UnLikeItemEvent<T>>((event , emit) async {
      List<ShopItemModel> items = [];
      items.addAll((state as ShopStateLoaded).items);
      int index = items.indexOf(event.item);
      items[index] = items[index].copyWith(liked: false);
      emit((state as ShopStateLoaded).copyWith(items: items));
      print("UnLiked item $T");

      // simulate an API request here: (I assume it failed so I reset the like btn)
      // await Future.delayed(Duration(milliseconds: 1500));
      // items = [];
      // items.addAll((state as ShopStateLoaded).items);
      // items[index] = items[index].copyWith(liked: true);
      // emit((state as ShopStateLoaded).copyWith(items: items));
    });

    on<AddToCartEvent<T>>((event , emit) async {
      var list = (state as ShopStateLoaded).cart;
      list.add(event.item.copyWith());
      emit((state as ShopStateLoaded).copyWith(cart: list,));
      print("Item added to cart $T");
    });
  }

  FutureOr<void> _loadShopInitial(LoadShopItemsEvent<T> event, Emitter<ShopItemsState> emit) async {
    emit(ShopStateInitial());

    var items = await HomeRepo.loadShopItems(
        (T == BestSellingShopItems) ? ShopItemType.Best_Selling :
        (T == NewArrivalsShopItems) ? ShopItemType.New_Arrivals :
        ShopItemType.Recommended
    );

    if (items.data == null){ //failed to load ...
      emit(ShopItemsStateLoadError());
    } else {
      emit(ShopStateLoaded(
        cart: [],
        items: items.data!,
        loadingMore: false,
      ));
    }
  }

  FutureOr<void> _loadMoreShopItems(LoadMoreShopItemsEvent<T> event, Emitter<ShopItemsState> emit) async {
    /// there should be another end-point where we can load more items
    /// but I'll work with what I got ig ..
    var items = await HomeRepo.loadShopItems(
        (T == BestSellingShopItems) ? ShopItemType.Best_Selling :
        (T == NewArrivalsShopItems) ? ShopItemType.New_Arrivals :
        ShopItemType.Recommended
    );
    var list = (state as ShopStateLoaded).items;

    if (items.data != null) {
      list.addAll(items.data!);
    }

    emit(
        (state as ShopStateLoaded).copyWith(
          items: list,
          loadingMore: false
        )
    );
  }
}
