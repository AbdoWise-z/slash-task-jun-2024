import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:slash_task/pages/home/bloc/home/home_bloc.dart';
import 'package:slash_task/pages/home/bloc/notifications/notifications_bloc.dart';
import 'package:slash_task/pages/home/bloc/offers/offers_bloc.dart';
import 'package:slash_task/pages/home/bloc/shop_items/shop_items_bloc.dart';
import 'package:slash_task/pages/home/models/category.model.dart';
import 'package:slash_task/pages/home/models/offers.model.dart';
import 'package:slash_task/pages/home/models/shop_item.model.dart';
import 'package:slash_task/pages/home/ui/views/city_select_dialog.dart';
import 'package:slash_task/pages/home/ui/views/home.action_bar.dart';
import 'package:slash_task/pages/home/ui/views/home.categories_bar.dart';
import 'package:slash_task/pages/home/ui/views/home.header.dart';
import 'package:slash_task/pages/home/ui/views/home.items_bar.dart';
import 'package:slash_task/pages/home/ui/views/home.offers.dart';
import 'package:slash_task/pages/home/ui/views/home.search_bar.dart';
import 'package:slash_task/shared/ui/shimmer_indicator.dart';
import 'package:slash_task/shared/values.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class HomeMainUI extends StatefulWidget {
  const HomeMainUI({super.key});

  @override
  State<HomeMainUI> createState() => _HomeMainUIState();
}

class _HomeMainUIState extends State<HomeMainUI> {
  final TextEditingController controller = TextEditingController();
  PageController? pageController = null;

  final List<ShopItemModel> mockShopItems =  [
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
  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _tabController = DefaultTabController.of(context);
        _tabController!.addListener(_handleTabSelection);
      });
    });

    //initialize API
    BlocProvider.of<NotificationsBloc>(context).add(InitNotificationsEvent());
    BlocProvider.of<OffersBloc>(context).add(LoadOffersEvent());

    BlocProvider.of<ShopItemsBloc<BestSellingShopItems>>(context).add(LoadShopItemsEvent<BestSellingShopItems>());
    BlocProvider.of<ShopItemsBloc<NewArrivalsShopItems>>(context).add(LoadShopItemsEvent<NewArrivalsShopItems>());
    BlocProvider.of<ShopItemsBloc<RecommendedShopItems>>(context).add(LoadShopItemsEvent<RecommendedShopItems>());
  }

  void _handleTabSelection() {
    setState(() {
      // Update the state to reflect the new selected tab index
    });
  }

  @override
  void dispose() {
    _tabController!.removeListener(_handleTabSelection);
    pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: TabBarView(
        clipBehavior: Clip.antiAlias,
        children: [
          // Page "Home" content
          Shimmer(
            linearGradient: AppTheme.shimmerGradient,
            child: BlocConsumer<HomeBloc, HomeState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, homeState) {

                var widget = SingleChildScrollView(
                  child: Column(
                    children: [
                      //action bar
                      Container(
                        padding: const EdgeInsets.all(AppDimen.GLOBAL_PADDING)
                            .copyWith(
                                top: AppDimen.APPBAR_TO_TOP_PADDING, bottom: 0),
                        child: BlocConsumer<NotificationsBloc, NotificationsState>(
                          listener: (context, state) {
                            // TODO: implement listener
                          },
                          builder: (context, notificationState) {
                            return getHomeAppBar(
                                hasNotification:
                                    notificationState is NotificationsLoaded
                                        ? notificationState.notifyUser
                                        : false,
                                city: homeState.currentCity,
                                location: homeState.currentLocation,
                                onNotificationClicked: () {
                                  //TODO: implement a notifications view
                                },
                                onSelectCity: () {
                                  //TODO: change with actual city selection magnetism
                                  showCitySelectDialog(context, [
                                    "Cairo: Naser City",
                                    "Giza: 7th Oct",
                                    "Something else idk"
                                  ], (item) {
                                    print(item);
                                    switch (item) {
                                      case 0:
                                        BlocProvider.of<HomeBloc>(context)
                                            .add(LocationChanged(
                                          city: "Cairo",
                                          location: "Naser City",
                                        ));
                                        break;
                                      case 1:
                                        BlocProvider.of<HomeBloc>(context)
                                            .add(LocationChanged(
                                          city: "Giza",
                                          location: "7th Oct",
                                        ));
                                        break;
                                      case 2:
                                        BlocProvider.of<HomeBloc>(context)
                                            .add(LocationChanged(
                                          city: "Something",
                                          location: "idk",
                                        ));
                                        break;
                                    }
                                  });
                                });
                          },
                        ),
                      ),

                      const SizedBox(
                        height: AppDimen.APPBAR_TO_CONTENT_PADDING,
                      ),

                      //search area
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppDimen.GLOBAL_PADDING),
                        child: getHomeSearchBar(
                            context: context,
                            controller: controller,
                            filtersEnabled: homeState.filtersDisplayed,
                            onFiltersClicked: () {
                              //TODO: implement actual filters and add them to the state
                              BlocProvider.of<HomeBloc>(context).add(
                                  FiltersVisibilityChanged(
                                      visible: !homeState.filtersDisplayed));
                            },
                            onSearchSubmit: (str) {
                              //TODO: implement a search page
                              print("Should search for : $str");
                            }),
                      ),

                      const SizedBox(
                        height: AppDimen.CONTENT_SPACING,
                      ),

                      //offers area
                      BlocConsumer<OffersBloc, OffersState>(
                        listener: (context, state) {},
                        builder: (context, offersState) {
                          return OffersView(
                              loading: offersState is OffersInitial,
                              offers: offersState is OffersLoaded
                                  ? offersState.data!
                                  : [
                                      OfferModel(),
                                      OfferModel(),
                                      OfferModel(),
                                      OfferModel(),
                                    ],
                              onOfferClicked: (offer) {
                                //TODO: implement when a user selects an offer
                                print("User selected Offer with ID: ${offer.id}");
                              });
                        },
                      ),

                      const SizedBox(
                        height: AppDimen.CONTENT_SPACING,
                      ),

                      //Categories area
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppDimen.GLOBAL_PADDING),
                        child: HomeHeader(
                            text: "Categories",
                            moreOptionText: "See all",
                            moreIcon:
                                const Icon(Icons.keyboard_arrow_right_rounded),
                            onSeeMore: () {}),
                      ),
                      const SizedBox(
                        height: AppDimen.TITLE_TO_CONTENT_PADDING,
                      ),
                      HomeCategoriesBar(
                        categories: [
                          CategoryModel(
                              name: "Fashion",
                              icon: "assets/icons/icon_tshirt.png"),
                          CategoryModel(
                              name: "Games", icon: "assets/icons/icon_dice.png"),
                          CategoryModel(
                              name: "Accessories",
                              icon: "assets/icons/icon_glasses.png"),
                          CategoryModel(
                              name: "Books", icon: "assets/icons/icon_book.png"),
                          CategoryModel(
                              name: "Fashion",
                              icon: "assets/icons/icon_tshirt.png"),
                          CategoryModel(
                              name: "Games", icon: "assets/icons/icon_dice.png"),
                          CategoryModel(
                              name: "Accessories",
                              icon: "assets/icons/icon_glasses.png"),
                          CategoryModel(
                              name: "Books", icon: "assets/icons/icon_book.png"),
                        ],
                        onCategorySelected: (c) {
                          //TODO: implement action when a user selects a category
                          print("User selected Category: ${c.name}");
                        },
                      ),

                      const SizedBox(
                        height: AppDimen.CONTENT_SPACING,
                      ),

                      //Best selling area
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppDimen.GLOBAL_PADDING),
                        child: HomeHeader(
                            text: "Best Selling",
                            moreOptionText: "See all",
                            moreIcon:
                                const Icon(Icons.keyboard_arrow_right_rounded),
                            onSeeMore: () {}),
                      ),
                      const SizedBox(
                        height: AppDimen.TITLE_TO_CONTENT_PADDING,
                      ),
                      BlocConsumer<ShopItemsBloc<BestSellingShopItems>, ShopItemsState>(
                        listener: (context, state) {
                        },
                        builder: (context, shopState) {
                          print("Rebuild Shop: Best Selling");
                          return HomeShopItemsBar(
                            items: (shopState is ShopStateLoaded) ? shopState.items : mockShopItems,
                            onAddedToCart: (item) {
                              BlocProvider.of<ShopItemsBloc<BestSellingShopItems>>(context).add(
                                AddToCartEvent<BestSellingShopItems>(
                                    item
                                ),
                              );
                            },
                            onLiked: (item , liked) {
                              if (liked) {
                                BlocProvider.of<ShopItemsBloc<BestSellingShopItems>>(context).add(
                                  LikeItemEvent<BestSellingShopItems>(
                                      item
                                  ),
                                );
                              } else {
                                BlocProvider.of<ShopItemsBloc<BestSellingShopItems>>(context).add(
                                  UnLikeItemEvent<BestSellingShopItems>(
                                      item
                                  ),
                                );
                              }
                            },
                            loadMore: () async {
                              BlocProvider.of<ShopItemsBloc<BestSellingShopItems>>(context).add(LoadMoreShopItemsEvent<BestSellingShopItems>());
                            },
                            onClicked: (c) {
                            },
                            loading: shopState is! ShopStateLoaded,
                            loadingMore: (shopState is ShopStateLoaded) && shopState.loadingMore,

                          );
                        },
                      ),

                      const SizedBox(
                        height: AppDimen.CONTENT_SPACING,
                      ),

                      //New Arrivals area
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppDimen.GLOBAL_PADDING),
                        child: HomeHeader(
                            text: "New Arrival",
                            moreOptionText: "See all",
                            moreIcon:
                                const Icon(Icons.keyboard_arrow_right_rounded),
                            onSeeMore: () {}),
                      ),
                      const SizedBox(
                        height: AppDimen.TITLE_TO_CONTENT_PADDING,
                      ),
                      BlocConsumer<ShopItemsBloc<NewArrivalsShopItems>, ShopItemsState>(
                        listener: (context, state) {
                        },
                        builder: (context, shopState) {
                          print("Rebuild Shop: New Arrivals");
                          return HomeShopItemsBar(
                            items: (shopState is ShopStateLoaded) ? shopState.items : mockShopItems,
                            onAddedToCart: (item) {
                              BlocProvider.of<ShopItemsBloc<NewArrivalsShopItems>>(context).add(
                                AddToCartEvent<NewArrivalsShopItems>(
                                    item
                                ),
                              );
                            },
                            onLiked: (item , liked) {
                              if (liked) {
                                BlocProvider.of<ShopItemsBloc<NewArrivalsShopItems>>(context).add(
                                  LikeItemEvent<NewArrivalsShopItems>(
                                      item
                                  ),
                                );
                              } else {
                                BlocProvider.of<ShopItemsBloc<NewArrivalsShopItems>>(context).add(
                                  UnLikeItemEvent<NewArrivalsShopItems>(
                                      item
                                  ),
                                );
                              }
                            },
                            loadMore: () async {
                              BlocProvider.of<ShopItemsBloc<NewArrivalsShopItems>>(context).add(LoadMoreShopItemsEvent<NewArrivalsShopItems>());
                            },
                            onClicked: (item) {
                              //TODO: implement when a user clicks on an item
                            },
                            loading: shopState is! ShopStateLoaded,
                            loadingMore: (shopState is ShopStateLoaded) && shopState.loadingMore,

                          );
                        },
                      ),

                      const SizedBox(
                        height: AppDimen.CONTENT_SPACING,
                      ),

                      //Recommended area
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppDimen.GLOBAL_PADDING),
                        child: HomeHeader(
                            text: "Recommended For You",
                            moreOptionText: "See all",
                            moreIcon:
                                const Icon(Icons.keyboard_arrow_right_rounded),
                            onSeeMore: () {}),
                      ),
                      const SizedBox(
                        height: AppDimen.TITLE_TO_CONTENT_PADDING,
                      ),
                      BlocConsumer<ShopItemsBloc<RecommendedShopItems>, ShopItemsState>(
                        listener: (context, state) {
                        },
                        builder: (context, shopState) {
                          print("Rebuild Shop: Recommended");
                          return HomeShopItemsBar(
                            items: (shopState is ShopStateLoaded) ? shopState.items : mockShopItems,
                            onAddedToCart: (item) {
                              BlocProvider.of<ShopItemsBloc<RecommendedShopItems>>(context).add(
                                AddToCartEvent<RecommendedShopItems>(
                                    item
                                ),
                              );
                            },
                            onLiked: (item , liked) {
                              if (liked) {
                                BlocProvider.of<ShopItemsBloc<RecommendedShopItems>>(context).add(
                                  LikeItemEvent<RecommendedShopItems>(
                                      item
                                  ),
                                );
                              } else {
                                BlocProvider.of<ShopItemsBloc<RecommendedShopItems>>(context).add(
                                  UnLikeItemEvent<RecommendedShopItems>(
                                      item
                                  ),
                                );
                              }
                            },
                            loadMore: () async {
                              BlocProvider.of<ShopItemsBloc<RecommendedShopItems>>(context).add(LoadMoreShopItemsEvent<RecommendedShopItems>());
                            },
                            onClicked: (c) {
                            },
                            loading: shopState is! ShopStateLoaded,
                            loadingMore: (shopState is ShopStateLoaded) && shopState.loadingMore,

                          );
                        },
                      ),

                    ],
                  ),
                );

                return widget;
              },
            ),
          ),

          //Page "Favorites" content
          const Center(
            child: Text("Favorites: Was not requested"),
          ),

          //Page "My Cart" content
          const Center(
            child: Text("My Cart: Was not requested"),
          ),

          //Page "Profile" content
          const Center(
            child: Text("Profile: Was not requested"),
          ),
        ],
      ),
      bottomNavigationBar: TabBar(
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black.withOpacity(0.2);
            }
            if (states.contains(MaterialState.hovered)) {
              return Colors.white.withOpacity(0.2);
            }
            return null;
          },
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: [
          Tab(
            icon: Icon(
              _tabController != null && _tabController!.index == 0 ? CupertinoIcons.house_fill : CupertinoIcons.house,
              color: Colors.black,
            ),
            iconMargin: const EdgeInsets.only(bottom: 0),
            text: "Home",
          ),

          Tab(
            icon: Icon(
              _tabController != null && _tabController!.index == 1 ? CupertinoIcons.heart_fill : CupertinoIcons.heart ,
              color: Colors.black,
            ),
            iconMargin: const EdgeInsets.only(bottom: 0),
            text: "Favorites",
          ),

          Tab(
            icon: Icon(
              _tabController != null && _tabController!.index == 2 ? CupertinoIcons.cart_fill : CupertinoIcons.cart ,
              color: Colors.black,
            ),
            iconMargin: const EdgeInsets.only(bottom: 0),
            text: "My Cart",
          ),

          Tab(
            icon: Icon(
              _tabController != null && _tabController!.index == 3 ? CupertinoIcons.person_crop_circle_fill : CupertinoIcons.person_crop_circle ,
              color: Colors.black,
            ),
            iconMargin: const EdgeInsets.only(bottom: 0),
            text: "Profile",
          ),
        ],
        indicator: MaterialIndicator(
          tabPosition: TabPosition.top,
          topLeftRadius: 0,
          topRightRadius: 0,
          bottomLeftRadius: 8,
          bottomRightRadius: 8,
          height: 6,
          horizontalPadding: 2
        ),
      ),
    );
  }
}
