import '../utils/app_assets.dart';

class CategoryModel {
  final String id;
  final String title;
  final String image;

  CategoryModel({required this.id, required this.title, required this.image});

  static List<CategoryModel> getCategories() {
    return [
      CategoryModel(
        id: 'general',
        title: 'General',
        image: AppAssets.generalDark,
      ),
      CategoryModel(
        id: 'business',
        title: 'Business',
        image: AppAssets.bussinessDark,
      ),
      CategoryModel(id: 'sports', title: 'Sports', image: AppAssets.sportDark),
      // CategoryModel(
      //   id: 'health',
      //   title: 'Health',
      //   image: AppAssets.healthDark,
      // ),
      // CategoryModel(
      //   id: 'entertainment',
      //   title: 'Entertainment',
      //   image: AppAssets.entertainmentDark,
      // ),
      // CategoryModel(
      //   id: 'technology',
      //   title: 'Technology',
      //   image: AppAssets.technologyDark,
      // ),
      // CategoryModel(
      //   id: 'science',
      //   title: 'Science',
      //   image: AppAssets.scienceDark,
      // ),
    ];
  }
}
