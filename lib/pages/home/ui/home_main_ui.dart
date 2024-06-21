import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:slash_task/pages/home/ui/views/home.error_page.dart';
import 'package:slash_task/pages/home/ui/views/home.header.dart';
import 'package:slash_task/pages/home/ui/views/home.items_bar.dart';
import 'package:slash_task/pages/home/ui/views/home.offers.dart';
import 'package:slash_task/pages/home/ui/views/home.search_bar.dart';
import 'package:slash_task/pages/home/ui/views/home.shop.dart';
import 'package:slash_task/shared/ui/debug_snake_bar.dart';
import 'package:slash_task/shared/ui/shimmer_indicator.dart';
import 'package:slash_task/shared/values.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

/// manages an controls the man Home widget
/// doesn't take any input, its just a wrapper around
/// widgets inside /views
class HomeMainUI extends StatefulWidget {
  const HomeMainUI({super.key});
  @override
  State<HomeMainUI> createState() => _HomeMainUIState();
}

class _HomeMainUIState extends State<HomeMainUI> {
  final TextEditingController controller = TextEditingController();
  PageController? pageController;


  TabController? _tabController;

  /// reloads the home resetting its state and loading all data from server
  void _reloadHome(){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _tabController = DefaultTabController.of(context);
        _tabController!.addListener(_handleTabSelection);
      });
    });

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
  }

  @override
  void initState() {
    super.initState();
    _reloadHome();
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
          /// Page "Home" content
          Shimmer(
            linearGradient: AppTheme.shimmerGradient,

            child: BlocConsumer<HomeBloc, HomeState>(
              listener: (context, state) {

              },
              builder: (context, homeState) {

                /// home Error page
                if (homeState is ErrorHomeState){
                  return const HomeErrorPage();
                }

                /// Home Main Page
                if (homeState is LoadedHomeState) {
                  var widget = SingleChildScrollView(
                    child: Column(
                      children: [
                        /// action bar
                        Container(
                          padding: const EdgeInsets.all(AppDimen.GLOBAL_PADDING)
                              .copyWith(
                              top: AppDimen.APPBAR_TO_TOP_PADDING, bottom: 0),

                          child: BlocConsumer<
                              NotificationsBloc,
                              NotificationsState>(
                            listener: (context, state) {},
                            builder: (context, notificationState) {
                              return getHomeAppBar(
                                  hasNotification:
                                  notificationState is LoadedNotificationsState
                                      ? notificationState.notifyUser
                                      : false,
                                  city: homeState.currentCity,
                                  location: homeState.currentLocation,
                                  onNotificationClicked: () {
                                    //TODO: implement a notifications view
                                    showSnakeBar(
                                        context, "Notifications Clicked");
                                  },
                                  onSelectCity: () {
                                    //TODO: change with actual city selection magnetism
                                    showSnakeBar(context, "Selecting City");
                                    showCitySelectDialog(
                                      context,
                                      [
                                        "Cairo: Naser City",
                                        "Giza: 7th Oct",
                                        "Something else idk"
                                      ],
                                          (item) {
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
                                      },
                                    );
                                  });
                            },
                          ),
                        ),

                        const SizedBox(
                          height: AppDimen.APPBAR_TO_CONTENT_PADDING,
                        ),

                        /// search bar area
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

                                showSnakeBar(
                                    context, "Filter menu button  clicked");
                              },
                              onSearchSubmit: (str) {
                                //TODO: implement a search page
                                print("Should search for : $str");
                                showSnakeBar(context, "Searching for : $str");
                              }),
                        ),

                        const SizedBox(
                          height: AppDimen.CONTENT_SPACING,
                        ),

                        /// offers area
                        BlocConsumer<OffersBloc, OffersState>(
                          listener: (context, state) {},
                          builder: (context, offersState) {
                            if (offersState is OffersErrorState){
                              BlocProvider.of<HomeBloc>(context).add(HomeErrorEvent());
                              return const SizedBox();
                            }
                            return OffersView(
                                loading: offersState is OffersInitialState,
                                offers: offersState is OffersLoadedState
                                    ? offersState.data ?? []
                                    : [
                                  OfferModel(),
                                  OfferModel(),
                                  OfferModel(),
                                  OfferModel(),
                                ],
                                onOfferClicked: (offer) {
                                  //TODO: implement when a user selects an offer
                                  print("User selected Offer with ID: ${offer
                                      .id}");
                                  showSnakeBar(context,
                                      "Selected Offer with ID: ${offer.id}");
                                });
                          },
                        ),

                        const SizedBox(
                          height: AppDimen.CONTENT_SPACING,
                        ),

                        /// Categories area
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppDimen.GLOBAL_PADDING),
                          child: HomeHeader(
                              text: "Categories",
                              moreOptionText: "See all",
                              moreIcon:
                              const Icon(Icons.keyboard_arrow_right_rounded),
                              onSeeMore: () {
                                showSnakeBar(context, "See all : categories");
                              }),
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
                                name: "Games",
                                icon: "assets/icons/icon_dice.png"),
                            CategoryModel(
                                name: "Accessories",
                                icon: "assets/icons/icon_glasses.png"),
                            CategoryModel(
                                name: "Books",
                                icon: "assets/icons/icon_book.png"),
                            CategoryModel(
                                name: "Fashion",
                                icon: "assets/icons/icon_tshirt.png"),
                            CategoryModel(
                                name: "Games",
                                icon: "assets/icons/icon_dice.png"),
                            CategoryModel(
                                name: "Accessories",
                                icon: "assets/icons/icon_glasses.png"),
                            CategoryModel(
                                name: "Books",
                                icon: "assets/icons/icon_book.png"),
                          ],
                          onCategorySelected: (c) {
                            //TODO: implement action when a user selects a category
                            print("User selected Category: ${c.name}");
                            showSnakeBar(
                                context, "User selected Category: ${c.name}");
                          },
                        ),

                        const SizedBox(
                          height: AppDimen.CONTENT_SPACING,
                        ),

                        /// Best selling area
                        HomeShop<BestSellingShop>(context: context, name: "Best Selling"),
                        const SizedBox(
                          height: AppDimen.CONTENT_SPACING,
                        ),

                        /// New Arrival area
                        HomeShop<NewArrivalsShop>(context: context, name: "New Arrival"),
                        const SizedBox(
                          height: AppDimen.CONTENT_SPACING,
                        ),

                        /// Recommended For You area
                        HomeShop<RecommendedShop>(context: context, name: "Recommended For You"),
                      ],
                    ),
                  );

                  return widget;
                }
                return const SizedBox(); //unknown state
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
              _tabController != null && _tabController!.index == 0
                  ? CupertinoIcons.house_fill
                  : CupertinoIcons.house,
              color: Colors.black,
            ),
            iconMargin: const EdgeInsets.only(bottom: 0),
            text: "Home",
          ),
          Tab(
            icon: Icon(
              _tabController != null && _tabController!.index == 1
                  ? CupertinoIcons.heart_fill
                  : CupertinoIcons.heart,
              color: Colors.black,
            ),
            iconMargin: const EdgeInsets.only(bottom: 0),
            text: "Favorites",
          ),
          Tab(
            icon: Icon(
              _tabController != null && _tabController!.index == 2
                  ? CupertinoIcons.cart_fill
                  : CupertinoIcons.cart,
              color: Colors.black,
            ),
            iconMargin: const EdgeInsets.only(bottom: 0),
            text: "My Cart",
          ),
          Tab(
            icon: Icon(
              _tabController != null && _tabController!.index == 3
                  ? CupertinoIcons.person_crop_circle_fill
                  : CupertinoIcons.person_crop_circle,
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
            horizontalPadding: 2),
      ),
    );
  }
}
