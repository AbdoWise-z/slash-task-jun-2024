///
/// to be honest this should be loaded from an API,
/// but the dummy data didn't include any information
/// about it, so I'm going to assume the app has the
/// list of available categories by default.
///
/// [name] the name of the category
/// [icon] the icon of the category
class CategoryModel {
  final String name;
  final String icon;

  CategoryModel({required this.name, required this.icon});
}