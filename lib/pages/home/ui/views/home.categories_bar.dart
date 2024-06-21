import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:slash_task/pages/home/models/category.model.dart';
import 'package:slash_task/shared/values.dart';

/// a widget that shows a bar that contains a list of the categories
/// [categories] the list of the categories to be displayed
/// [onCategorySelected] a callback function when the user clicked on
///   a category option
class HomeCategoriesBar extends StatefulWidget {
  final List<CategoryModel> categories;
  final void Function (CategoryModel) onCategorySelected;

  const HomeCategoriesBar({super.key, required this.categories, required this.onCategorySelected});

  @override
  State<HomeCategoriesBar> createState() => _HomeCategoriesBarState();
}

class _HomeCategoriesBarState extends State<HomeCategoriesBar> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget catBar = SingleChildScrollView(
      primary: true,
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: AppDimen.GLOBAL_PADDING,),
          for (var cat in widget.categories)
            Container(
              alignment: Alignment.center,
              //color: Colors.blue,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CategoryView(
                    name: cat.name,
                    icon: cat.icon,
                    onClick: () {
                        widget.onCategorySelected(cat);
                    },
                  ),
                  const SizedBox(
                    width: AppDimen.CATEGORY_TO_CATEGORY_PADDING,
                  ),
                ],
              ),
            ),

          const SizedBox(width: AppDimen.GLOBAL_PADDING - AppDimen.CATEGORY_TO_CATEGORY_PADDING,),

        ],
      ),
    );

    return catBar;
  }
}

/// a widget that resembles one category option, simply an colum that contains
/// an image and text beneath it
/// [name] the of the category
/// [icon] the icon of the category
class CategoryView extends StatelessWidget {
  final String name;
  final String icon;
  final void Function() onClick;
  const CategoryView({super.key, required this.name, required this.icon, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      borderRadius: BorderRadius.circular(AppDimen.ROUNDED_CORNERS_RADIUS),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: AppDimen.CATEGORY_AVATAR_SIZE,
              backgroundColor: AppTheme.categoriesAvatarColor,
              child: Image.asset(
                icon,
                width: AppDimen.CATEGORY_ICON_SIZE,
                height: AppDimen.CATEGORY_ICON_SIZE,
              ),
            ),

            const SizedBox(height: 4,),

            Text(name , style: AppTheme.mediumTextStyle,),
          ],
        ),
      ),
    );
  }
}



