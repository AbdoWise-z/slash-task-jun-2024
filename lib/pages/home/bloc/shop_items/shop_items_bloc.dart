import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:slash_task/pages/home/models/shop_item.model.dart';
import 'package:slash_task/pages/home/repo/home.repo.dart';

part 'shop_items_event.dart';
part 'shop_items_state.dart';

/// a base class for the shop types
sealed class ShopType {}

/// a class that represents the Best selling shop
class BestSellingShop extends ShopType {}

/// a class that represents the new arrivals shop
class NewArrivalsShop extends ShopType {}

/// a class that represents the recommended shop
class RecommendedShop extends ShopType {}

/// a BloC class that manages the state of one shop, the generic class [T]
/// is just to determine the end point that this BloC will use to load the
/// data from the server
///
/// it manages the following states:
/// * [ShopStateInitial] the initial state for the shop
/// * [ShopItemsStateLoadError] state that happens if error was encountered while
///   loading the data
/// * [ShopStateLoaded] state that represents when the shop was successfully loaded
///   from the web server
///
/// it deals with the following events:
/// * [LoadShopItemsEvent] when this event happens, the first shop load action is triggered
///   to load the shop content from the web server
/// * [LoadMoreShopItemsEvent] loads more shop content into the currently loaded content
/// * [LikeItemEvent] when an item is liked this event is triggered
/// * [UnLikeItemEvent] when an item is un-liked this event is triggered
/// * [AddToCartEvent] when an item is added to cart, this event is triggered
class ShopItemsBloc<T extends ShopType> extends Bloc<ShopItemsEvent<T>, ShopItemsState> {
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


  }

  /// loads the initial shop data then updates the shop state
  FutureOr<void> _loadShopInitial(LoadShopItemsEvent<T> event, Emitter<ShopItemsState> emit) async {
    emit(ShopStateInitial());

    var items = await HomeRepo.loadShopItems(
        (T == BestSellingShop) ? ShopItemType.Best_Selling :
        (T == NewArrivalsShop) ? ShopItemType.New_Arrivals :
        ShopItemType.Recommended
    );

    if (items.data == null){ //failed to load ...
      emit(ShopItemsStateLoadError());
    } else {
      emit(ShopStateLoaded(
        items: items.data!,
        loadingMore: false,
      ));
    }
  }

  /// tires to load more data then updates the state
  FutureOr<void> _loadMoreShopItems(LoadMoreShopItemsEvent<T> event, Emitter<ShopItemsState> emit) async {
    /// there should be another end-point where we can load more items
    /// but I'll work with what I got ig ..
    var items = await HomeRepo.loadShopItems(
        (T == BestSellingShop) ? ShopItemType.Best_Selling :
        (T == NewArrivalsShop) ? ShopItemType.New_Arrivals :
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
