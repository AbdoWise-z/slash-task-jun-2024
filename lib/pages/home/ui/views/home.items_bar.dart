import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:slash_task/pages/home/models/shop_item.model.dart';
import 'package:slash_task/shared/ui/animated_appear.dart';
import 'package:slash_task/shared/ui/shimmer_indicator.dart';
import 'package:slash_task/shared/values.dart';

/// a class that holds a shop list / grid
/// [items] the items to be displayed on the shop
/// [onAddedToCart] a function that is called when the added to cart button is clicked
/// [onLiked] a function that will be called when like/unlike button is pressed
/// [onClicked] a function to be called when an item is clicked
/// [loadMore] a function to be called when this widget wants to request the load
///   of more data, if the value is null, then it means we cannot load anymore data
/// [loading] weather or not to show a loading placeholders for the items
/// [loadingMore] weather or not to show the loading indicator at the end of the list/grid
class HomeShopItemsBar extends StatelessWidget {
  final List<ShopItemModel> items;
  final void Function(ShopItemModel) onAddedToCart;
  final void Function(ShopItemModel , bool) onLiked;
  final void Function(ShopItemModel) onClicked;
  final Future<void> Function()? loadMore;
  final bool loading;
  final bool loadingMore;

  const HomeShopItemsBar({super.key, required this.items, required this.onAddedToCart, required this.onLiked, required this.loading, this.loadMore, required this.loadingMore, required this.onClicked});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb){
      return _ShopItemsWeb(
        container: this,
      );
    } else {
      return _ShopItemsMobile(
        container: this,
      );
    }
  }
}

/// a shop grid specifically optimized for web view
/// growable grid view
class _ShopItemsWeb extends StatelessWidget {
  const _ShopItemsWeb({required this.container});

  final HomeShopItemsBar container;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimen.GLOBAL_PADDING),
      child: LayoutBuilder(
          builder: (context , constrains) {
            double width = constrains.maxWidth;
            int itemsCount = (width / AppValues.ITEMS_WIDTH_WEB).ceil();
            double itemWidth = width / itemsCount;
            double itemHeight = 1 / AppValues.SHOP_ITEM_ASPECT_RATIO_WEB * itemWidth;

            bool addLoadMoreButton = !container.loadingMore && !container.loading && container.loadMore != null;
            bool addLoadingIndicator = container.loadingMore;

            int gridItemsCount = container.items.length + ((addLoadingIndicator || addLoadMoreButton) ? 1 : 0);
            int rows =  ( gridItemsCount / itemsCount).ceil();

            return SizedBox(
              width: width,
              height: itemHeight * rows,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: itemsCount,
                  childAspectRatio: AppValues.SHOP_ITEM_ASPECT_RATIO_WEB
                ),
                itemCount: gridItemsCount,
                padding: EdgeInsets.zero,
                itemBuilder: (BuildContext context, int index) {

                  int startIndex = 0;
                  int endIndex = gridItemsCount - 1;

                  if (index == endIndex && addLoadingIndicator){
                    return Container(
                      width: double.infinity,
                      height: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(AppValues.ITEMS_WIDTH_WEB * 0.2),
                      child: const CircularProgressIndicator(),
                    );
                  }

                  if (index == endIndex && addLoadMoreButton) {
                    return Container(
                      width: double.infinity,
                      height: double.infinity,
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          container.loadMore!();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("More"),
                                  Text("Offers"),
                                ],
                              ),
                            ],
                          ),
                        ),

                      ),
                    );
                  }

                  var item = ShimmerLoading(
                    isLoading: container.loading,
                    child: AnimatedAppear(
                      duration: const Duration(milliseconds: 500),
                      animate: !container.loading,
                      child: ShopItem(
                        item: container.items[index],
                        onAddedToCart: () {
                          container.onAddedToCart(container.items[index]);
                        },
                        onLiked: (liked) {
                          container.onLiked(container.items[index] , liked);
                        },
                        onClicked: () {
                          container.onClicked(container.items[index]);
                        },
                        loading: container.loading,
                      ),
                    ),
                  );

                  return item;
                },

              ),
            );
          },
      ),
    );
  }
}

/// a shop items specifically optimized for mobile version of the app
/// horizontal scrollable list
class _ShopItemsMobile extends StatefulWidget {
  const _ShopItemsMobile({
    required this.container,
  });

  final HomeShopItemsBar container;

  @override
  State<_ShopItemsMobile> createState() => _ShopItemsMobileState();
}

class _ShopItemsMobileState extends State<_ShopItemsMobile> {

  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      double width = MediaQuery.of(context).size.width;
      double itemWidth = AppValues.ITEMS_WIDTH_MOBILE;
      if (controller.position.pixels >= controller.position.maxScrollExtent - itemWidth){ //last item is visible
        if (widget.container.loadMore != null && ! widget.container.loadingMore){
          widget.container.loadMore!(); //request to load more
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context , box) {
        double width        = box.maxWidth;
        double itemsCount   = width / AppValues.ITEMS_WIDTH_MOBILE;
        double itemWidth    = AppValues.ITEMS_WIDTH_MOBILE;
        double itemHeight   = 1 / AppValues.SHOP_ITEM_ASPECT_RATIO_MOBILE * itemWidth;

        bool shouldAskForMore =
        !widget.container.loading &
        !widget.container.loadingMore &
        (widget.container.loadMore != null) &
        (width - itemWidth * widget.container.items.length > 0) //didn't fill the screen
            ;

        if (shouldAskForMore){
          widget.container.loadMore!();
        }

        return SizedBox(
          height: itemHeight,
          child: ListView.separated(
            controller: controller,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {

              int startIndex = 0;
              int endIndex = widget.container.items.length + (widget.container.loadingMore ? 1 : 0) - 1;

              if (index == endIndex && widget.container.loadingMore){
                return Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0).copyWith(left: 16),
                        child: const CircularProgressIndicator(),
                      ),
                    ),
                    const SizedBox(width: AppDimen.GLOBAL_PADDING,),
                  ],
                );
              }

              var item = ShimmerLoading(
                isLoading: widget.container.loading,
                child: SizedBox(
                  width: AppValues.ITEMS_WIDTH_MOBILE,
                  child: AnimatedAppear(
                    duration: const Duration(milliseconds: 500),
                    animate: !widget.container.loading,
                    child: ShopItem(
                      item: widget.container.items[index],
                      onAddedToCart: () {
                        widget.container.onAddedToCart(widget.container.items[index]);
                      },
                      onLiked: (liked) {
                        widget.container.onLiked(widget.container.items[index] , liked);
                      },
                      onClicked: () {
                        widget.container.onClicked(widget.container.items[index]);
                      },
                      loading: widget.container.loading,
                    ),
                  ),
                ),
              );



              if (index == startIndex){
                return Row(
                  children: [
                    const SizedBox(width: AppDimen.GLOBAL_PADDING,),
                    item,
                  ],
                );
              } else if (index == endIndex){
                return Row(
                  children: [
                    item,
                    const SizedBox(width: AppDimen.GLOBAL_PADDING,),
                  ],
                );
              }
              return item;
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(width: AppDimen.SHOPITEM_TO_SHOPITEM_PADDING,);
            },
            itemCount: widget.container.items.length + (widget.container.loadingMore ? 1 : 0),
          ),
        );
      }
    );
  }
}

class ShopItem extends StatelessWidget {
  final ShopItemModel item;
  final bool loading;
  final void Function() onAddedToCart;
  final void Function(bool) onLiked;
  final void Function() onClicked;

  const ShopItem({
    super.key,
    required this.item,
    required this.onAddedToCart,
    required this.onLiked,
    required this.loading,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: loading ? null : onClicked,
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimen.ROUNDED_CORNERS_RADIUS),
      ),
      child: Container(
        padding: const EdgeInsets.all(2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppDimen.ROUNDED_CORNERS_RADIUS),
                      // color: Colors.blue,
                    ),
                    clipBehavior: Clip.antiAlias,
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      item.image!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Row(
                      children: [
                        const Expanded(flex: 4, child: SizedBox(),),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FittedBox(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10000),
                              ),
                              child: LikeButton(
                                isLiked: item.liked,
                                countPostion: CountPostion.bottom,
                                onTap: loading ? null : (clicked) async {
                                  onLiked(!clicked);
                                  return !clicked;
                                },
                                padding: const EdgeInsets.all(4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(flex: 1,child: SizedBox() ,),
            Container(
              decoration: loading ? BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimen.ROUNDED_CORNERS_RADIUS),
                color: Colors.black,
              ) : null,
              child: Text(
                item.name!,
                style: AppTheme.shopItemTextStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Container(
                      decoration: loading ? BoxDecoration(
                        borderRadius: BorderRadius.circular(AppDimen.ROUNDED_CORNERS_RADIUS),
                        color: Colors.black,
                      ) : null,
                      child: Text(
                        "EGP ${item.price!.toInt() == item.price ? item.price!.toInt() : item.price}",
                        style: AppTheme.shopItemCurrencyTextStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  AspectRatio(
                    aspectRatio: 1,
                    child: FittedBox(
                      alignment: Alignment.centerRight,
                      fit: BoxFit.fitHeight,
                      child: InkWell(
                        onTap: loading ? null : onAddedToCart,
                        borderRadius: BorderRadius.circular(100000),
                        child: const Icon(
                          Icons.add_circle_outlined,
                          color: Colors.black,
                          opticalSize: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
