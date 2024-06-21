import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:slash_task/pages/home/models/offers.model.dart';
import 'package:slash_task/shared/ui/shimmer_indicator.dart';
import 'package:slash_task/shared/values.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OffersView extends StatefulWidget {
  final List<OfferModel> offers;
  final bool loading;
  final void Function(OfferModel) onOfferClicked;

  const OffersView({
    super.key,
    required this.offers,
    required this.onOfferClicked,
    required this.loading,
  });

  @override
  State<OffersView> createState() => _OffersViewState();
}

class _OffersViewState extends State<OffersView> {
  PageController? controller;
  int currentPage = 0;
  double lastWidth = -1;

  void _update(){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, box) {
      double width = box.maxWidth;

      if (lastWidth != width) {
        lastWidth = width;

        int startPage = 0;
        if (controller !=  null){
          startPage = (controller!.positions.isNotEmpty && controller!.page != null) ? controller!.page!.toInt() : 0;
          controller!.removeListener(_update);
          controller!.dispose();
        }

        controller = PageController(
          viewportFraction: 1 - AppDimen.GLOBAL_PADDING * 2 / width,
          initialPage: startPage,
        );

        controller?.addListener(_update);

        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {});
        });
      }

      double offerHeight = width *
          (kIsWeb
              ? AppValues.OFFERS_ASPECT_RATIO_WEB
              : AppValues.OFFERS_ASPECT_RATIO_MOBILE);

      Widget pageView = PageView(
        pageSnapping: true,
        padEnds: true,
        controller: controller,
        onPageChanged: (p) {
          currentPage = p;
        },
        physics: widget.loading ? const NeverScrollableScrollPhysics() : null,
        children: [
          for (var (i, offer) in widget.offers.indexed)
            ShimmerLoading(
              isLoading: widget.loading,
              child: OfferCard(
                index: i,
                page: (controller!.positions.isEmpty ? 0 : controller!.page!),
                offer: offer,
                maxWidth: controller!.viewportFraction * width,
                maxHeight: offerHeight,
                loading: widget.loading,
                onClicked: widget.onOfferClicked,
              ),
            ),
        ],
      );

      if (kIsWeb) {
        pageView = Stack(
          children: [
            pageView,
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimen.GLOBAL_PADDING),
                child: Row(
                  children: [
                    SizedBox(
                      height: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          if (controller == null || controller!.page == null) return;

                          if (controller!.page!.toInt() > 0){
                            controller!.animateToPage(
                                controller!.page!.toInt() - 1,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut
                            );
                          }
                        },
                        style: const ButtonStyle(
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(AppDimen.ROUNDED_CORNERS_RADIUS),
                                bottomLeft: Radius.circular(AppDimen.ROUNDED_CORNERS_RADIUS),
                              )
                            )
                          )
                        ),
                        child: const Icon(CupertinoIcons.left_chevron),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    SizedBox(
                      height: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          if (controller == null || controller!.page == null) return;

                          if (controller!.page!.toInt() < widget.offers.length - 1){
                            controller!.animateToPage(
                                controller!.page!.toInt() + 1,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut
                            );
                          }
                        },
                        style: const ButtonStyle(
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(AppDimen.ROUNDED_CORNERS_RADIUS),
                                      bottomRight: Radius.circular(AppDimen.ROUNDED_CORNERS_RADIUS),
                                    )
                                )
                            )
                        ),
                        child: const Icon(CupertinoIcons.right_chevron),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      }

      return Column(
        children: [
          SizedBox(
            height: offerHeight,
            child: pageView,
          ),
          const SizedBox(
            height: 8,
          ),
          AnimatedSmoothIndicator(
            count: widget.offers.length,
            activeIndex: currentPage,
            effect: const ExpandingDotsEffect(
              dotHeight: 8,
              dotWidth: 8,
              expansionFactor: 2,
              activeDotColor: Colors.black,
            ),
          ),
        ],
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller!.dispose();
  }
}

class OfferCard extends StatelessWidget {
  const OfferCard(
      {super.key,
      required this.index,
      required this.page,
      required this.offer,
      required this.maxWidth,
      required this.maxHeight,
      required this.loading,
      required this.onClicked});

  final int index;
  final double page;
  final double maxWidth;
  final double maxHeight;
  final bool loading;
  final OfferModel offer;
  final void Function(OfferModel) onClicked;

  @override
  Widget build(BuildContext context) {
    double off = AppDimen.GLOBAL_PADDING / maxWidth;
    double scaleX = (1 - off) + off * (1 - (index - page).abs().clamp(0, 1));
    double scaleY = (1 - off * 2) + off * 2 * (1 - (index - page).abs().clamp(0, 1));


    if (loading) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        child: Container(
          width: maxWidth * scaleX,
          height: maxHeight * scaleY,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius:
            BorderRadius.circular(AppDimen.ROUNDED_CORNERS_RADIUS),
          ),
        ),
      );
    }

    return Transform.scale(
      scaleX: scaleX,
      scaleY: scaleY,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius:
                BorderRadius.circular(AppDimen.ROUNDED_CORNERS_RADIUS),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                offer.image!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Material(
            type: MaterialType.transparency,
            child: InkWell(
              splashColor: Colors.white.withOpacity(0.01),
              onTap: () {
                onClicked(offer);
              },
              customBorder: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppDimen.ROUNDED_CORNERS_RADIUS),
              ),
              child: const SizedBox(
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
