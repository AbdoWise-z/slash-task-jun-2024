import 'dart:math';

import 'package:flutter/material.dart';
import 'package:slash_task/pages/home/models/category.model.dart';
import 'package:slash_task/shared/values.dart';

class HomeCategoriesBar extends StatefulWidget {
  final List<CategoryModel> categories;
  final void Function (CategoryModel) onCategorySelected;

  const HomeCategoriesBar({super.key, required this.categories, required this.onCategorySelected});

  @override
  State<HomeCategoriesBar> createState() => _HomeCategoriesBarState();
}

class _HomeCategoriesBarState extends State<HomeCategoriesBar> {

  GlobalKey rowKey = GlobalKey();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        key: rowKey,
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
                  CategoryView(name: cat.name, icon: cat.icon),
                  SizedBox(
                    width: AppDimen.CATEGORY_TO_CATEGORY_PADDING,
                  ),
                ],
              ),
            ),

          const SizedBox(width: AppDimen.GLOBAL_PADDING - AppDimen.CATEGORY_TO_CATEGORY_PADDING,),

        ],
      ),
    );
  }
}

class CategoryView extends StatelessWidget {
  final String name;
  final String icon;
  const CategoryView({super.key, required this.name, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}



