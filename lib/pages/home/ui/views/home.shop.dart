import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slash_task/pages/home/bloc/home/home_bloc.dart';
import 'package:slash_task/pages/home/bloc/shop_items/shop_items_bloc.dart';
import 'package:slash_task/pages/home/models/shop_item.model.dart';
import 'package:slash_task/pages/home/repo/home.repo.dart';
import 'package:slash_task/shared/ui/debug_snake_bar.dart';
import 'package:slash_task/shared/values.dart';

import 'home.header.dart';
import 'home.items_bar.dart';

/// mock data for loading display
final List<ShopItemModel> mockShopItems = [
  ShopItemModel(
    liked: true,
    id: 0,
    name: "Botatos",
    image: "assets/images/best_seller_1.png",
    price: 12,
  ),
  ShopItemModel(
    liked: true,
    id: 0,
    name: "So That worked",
    image: "assets/images/best_seller_1.png",
    price: 12,
  ),
  ShopItemModel(
    liked: true,
    id: 0,
    name: "Heh",
    image: "assets/images/best_seller_1.png",
    price: 12,
  ),
  ShopItemModel(
    liked: true,
    id: 0,
    name: "Lesgooo",
    image: "assets/images/best_seller_1.png",
    price: 12,
  ),
];

Widget HomeShop<T extends ShopType>({
  required BuildContext context,
  required String name,
}){
  return Column(
    children: [
      /// Header
      Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimen.GLOBAL_PADDING),
        child: HomeHeader(
            text: name,
            moreOptionText: "See all",
            moreIcon:
            const Icon(Icons.keyboard_arrow_right_rounded),
            onSeeMore: () {
              showSnakeBar(context, "See all : $name");
            }),
      ),
      const SizedBox(
        height: AppDimen.TITLE_TO_CONTENT_PADDING,
      ),
      /// Content
      BlocConsumer<
          ShopItemsBloc<T>,
          ShopItemsState>(
        listener: (context, state) {},
        builder: (context, shopState) {
          print("Rebuild Shop: $name");
          if (shopState is ShopItemsStateLoadError){
            BlocProvider.of<HomeBloc>(context).add(HomeErrorEvent());
            return const SizedBox();
          }

          return HomeShopItemsBar(
            items: (shopState is ShopStateLoaded)
                ? shopState.items
                : mockShopItems,
            onAddedToCart: (item) {
              BlocProvider.of<HomeBloc>(
                  context)
                  .add(
                AddToCartEvent(item),
              );

              showSnakeBar(context,
                  "Item Added to cart : {id: ${item
                      .id} , name: ${item.name}}");
            },
            onLiked: (item, liked) {
              if (liked) {
                BlocProvider.of<
                    ShopItemsBloc<T>>(context)
                    .add(
                  LikeItemEvent<T>(item),
                );
                showSnakeBar(context, "Liked Item: {id: ${item
                    .id} , name: ${item.name}}");
              } else {
                BlocProvider.of<
                    ShopItemsBloc<
                        T>>(context)
                    .add(
                  UnLikeItemEvent<T>(item),
                );
                showSnakeBar(context,
                    "UnLiked Item: {id: ${item
                        .id} , name: ${item.name}}");
              }
            },
            loadMore: () async {
              BlocProvider.of<
                  ShopItemsBloc<T>>(
                  context)
                  .add(LoadMoreShopItemsEvent<
                  T>());
            },
            onClicked: (item) {
              showSnakeBar(context, "Item Clicked: {id: ${item
                  .id} , name: ${item.name}}");
            },
            loading: shopState is! ShopStateLoaded,
            loadingMore: (shopState is ShopStateLoaded) &&
                shopState.loadingMore,
          );
        },
      ),

      const SizedBox(
        height: AppDimen.CONTENT_SPACING,
      ),
    ],
  );
}