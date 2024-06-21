
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slash_task/pages/home/bloc/home/home_bloc.dart';
import 'package:slash_task/pages/home/bloc/notifications/notifications_bloc.dart';
import 'package:slash_task/pages/home/bloc/offers/offers_bloc.dart';
import 'package:slash_task/pages/home/bloc/shop_items/shop_items_bloc.dart';
import 'package:slash_task/shared/values.dart';

/// a class that represents the error page that will be shown when an error occur
class HomeErrorPage extends StatelessWidget {
  const HomeErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(flex: 3, child: SizedBox()),
          const Padding(
            padding: EdgeInsets.all(AppDimen.GLOBAL_PADDING),
            child: Text(
              "Something went wrong while loading the data.",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600
              ),
            ),
          ),

          TextButton(
            onPressed: () {
              BlocProvider.of<HomeBloc>(context).add(HomeLoadEvent());

              //initialize API
              BlocProvider.of<NotificationsBloc>(context).add(InitNotificationsEvent());
              BlocProvider.of<OffersBloc>(context).add(LoadOffersEvent());

              BlocProvider.of<ShopItemsBloc<BestSellingShop>>(context)
                  .add(LoadShopItemsEvent<BestSellingShop>());
              BlocProvider.of<ShopItemsBloc<NewArrivalsShop>>(context)
                  .add(LoadShopItemsEvent<NewArrivalsShop>());
              BlocProvider.of<ShopItemsBloc<RecommendedShop>>(context)
                  .add(LoadShopItemsEvent<RecommendedShop>());

            },
            child: const Text(
                "Try again",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800
              ),
            ),
          ),

          const Expanded(flex: 2, child: SizedBox()),

        ],
      ),
    );
  }
}
