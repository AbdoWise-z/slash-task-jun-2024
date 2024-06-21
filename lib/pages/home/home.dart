import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slash_task/pages/home/bloc/home/home_bloc.dart';
import 'package:slash_task/pages/home/bloc/notifications/notifications_bloc.dart';
import 'package:slash_task/pages/home/bloc/offers/offers_bloc.dart';
import 'package:slash_task/pages/home/bloc/shop_items/shop_items_bloc.dart';
import 'package:slash_task/pages/home/ui/home_main_ui.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return
      MultiBlocProvider(
        providers: [
          BlocProvider<HomeBloc>(
            create: (BuildContext context) => HomeBloc(),
          ),
          BlocProvider<NotificationsBloc>(
            create: (BuildContext context) => NotificationsBloc(),
          ),
          BlocProvider<OffersBloc>(
            create: (BuildContext context) => OffersBloc(),
          ),
          BlocProvider<ShopItemsBloc<BestSellingShop>>(
            create: (BuildContext context) => ShopItemsBloc<BestSellingShop>(),
          ),
          BlocProvider<ShopItemsBloc<NewArrivalsShop>>(
            create: (BuildContext context) => ShopItemsBloc<NewArrivalsShop>(),
          ),
          BlocProvider<ShopItemsBloc<RecommendedShop>>(
            create: (BuildContext context) => ShopItemsBloc<RecommendedShop>(),
          ),
        ],
        child: const DefaultTabController(
            length: 4,
            child: HomeMainUI(),
        ),
      );
  }
}
