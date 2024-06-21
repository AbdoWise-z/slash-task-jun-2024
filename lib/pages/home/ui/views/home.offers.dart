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
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    if (controller == null) {
      controller ??= PageController(
          viewportFraction: 1 - AppDimen.GLOBAL_PADDING * 2 / width
      );

      controller?.addListener(() {
        setState(() {});
      });
    }


    return Column(
      children: [
        SizedBox(
          height: height / 6,
          child: PageView(
            pageSnapping: true,
            padEnds: true,
            controller: controller,
            onPageChanged: (p) {
              currentPage = p;
            },
            physics: widget.loading ? const NeverScrollableScrollPhysics() : null,
            children: [
              for (var (i , offer) in widget.offers.indexed)
                ShimmerLoading(
                  isLoading: widget.loading,
                  child: OfferCard(
                    index: i,
                    page: (controller!.positions.isEmpty ? 0 :  controller!.page!),
                    offer: offer,
                    maxWidth: controller!.viewportFraction * width,
                    maxHeight: height / 6,
                    loading: widget.loading,
                    onClicked: widget.onOfferClicked,
                  ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8,),
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
  }

  @override
  void dispose() {
    super.dispose();
    controller!.dispose();
  }
}


class OfferCard extends StatelessWidget {
  const OfferCard({
    super.key,
    required this.index,
    required this.page,
    required this.offer,
    required this.maxWidth,
    required this.maxHeight,
    required this.loading,
    required this.onClicked
  });

  final int index;
  final double page;
  final double maxWidth;
  final double maxHeight;
  final bool loading;
  final OfferModel offer;
  final void Function(OfferModel) onClicked;

  @override
  Widget build(BuildContext context) {
    double scale = 0.95 + 0.05 * (1 - (index - page).abs().clamp(0, 1));

    if (loading){
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: (1 - scale) * maxWidth,
          horizontal: (1 - scale) * maxHeight,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(AppDimen.ROUNDED_CORNERS_RADIUS),
          ),
        ),
      );
    }

    return Transform.scale(
      scale: scale,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimen.ROUNDED_CORNERS_RADIUS),
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
                borderRadius: BorderRadius.circular(AppDimen.ROUNDED_CORNERS_RADIUS),
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
