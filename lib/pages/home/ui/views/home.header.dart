import 'package:flutter/material.dart';
import 'package:slash_task/shared/values.dart';

/// a class that represents a header, for example:
/// Best Selling                      See all >
///
/// [text] the text to be displayed on the left "Best Selling"
/// [moreOptionText] the text to be displayed on the right "See all"
/// [moreIcon] a widget that will be displayed next to the text on the right
/// [onSeeMore] when the right section of the header is clicked, this
///   callback is invoked
class HomeHeader extends StatelessWidget {
  final String text;
  final String moreOptionText;
  final Widget moreIcon;
  final void Function() onSeeMore;

  const HomeHeader(
      {super.key,
      required this.text,
      required this.moreOptionText,
      required this.moreIcon,
      required this.onSeeMore});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          text,
          style: AppTheme.headerTextStyle,
        ),
        const Expanded(child: SizedBox()),
        InkWell(
          onTap: onSeeMore,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              children: [
                Text(
                  moreOptionText,
                  style: AppTheme.mediumTextStyle,
                ),
                const SizedBox(
                  width: 12,
                ),
                Container(
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.black.withOpacity(0.1),
                  ),
                  child: moreIcon,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
