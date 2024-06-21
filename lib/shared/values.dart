import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// a static class that hold the entire app theme-related values
class AppTheme {
  AppTheme._();

  static TextTheme textTheme = GoogleFonts.urbanistTextTheme();

  static const shimmerGradient = LinearGradient(
    colors: [
      Color(0xFFEBEBF4),
      Color(0xFFF4F4F4),
      Color(0xFFEBEBF4),
    ],
    stops: [
      0.1,
      0.3,
      0.4,
    ],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
  );

  static const TextStyle headerTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle mediumTextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16,
  );

  static const TextStyle shopItemTextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 18,
  );

  static const TextStyle shopItemCurrencyTextStyle = TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 18,
  );

  static const Color categoriesAvatarColor = Color.fromRGBO(41, 41, 41, 1);
}

/// a static class that hold the entire app dimensions-related values
class AppDimen {
  AppDimen._();


  /// global padding for page content
  static const double GLOBAL_PADDING            = 25;

  /// app bar to the search bar spacing
  static const double APPBAR_TO_CONTENT_PADDING = 16;

  /// app bar to the screen top spacing
  static const double APPBAR_TO_TOP_PADDING     = 40;

  /// in-between content spacing
  static const double CONTENT_SPACING           = 16;

  /// the default rounded corners radius for the widgets
  static const double ROUNDED_CORNERS_RADIUS    = 12;

  /// the default title to content spacing for widgets that has a title
  static const double TITLE_TO_CONTENT_PADDING  = 8;

  static const double CATEGORY_TO_CATEGORY_PADDING  = 2;
  static const double CATEGORY_AVATAR_SIZE      = 38;
  static const double CATEGORY_ICON_SIZE        = 32;

  static const double SHOPITEM_TO_SHOPITEM_PADDING  = 8;

}

class AppValues {
  AppValues._();

  /// target width for shop items for mobile version
  static const double ITEMS_WIDTH_MOBILE      = 150;

  /// target width for shop items for web version
  static const double ITEMS_WIDTH_WEB         = 150;

  /// aspect ratio for shop items for mobile version
  static const double SHOP_ITEM_ASPECT_RATIO_MOBILE = 2.1 / 3;

  /// aspect ratio for shop items for web version
  static const double SHOP_ITEM_ASPECT_RATIO_WEB    = 2 / 3;

  /// offers height to width ratio in mobile version
  static const double OFFERS_ASPECT_RATIO_MOBILE = 0.4;

  /// offers height to width ratio in web version
  static const double OFFERS_ASPECT_RATIO_WEB    = 0.2;


}