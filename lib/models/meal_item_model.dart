class MealItemModel {
  final String id;
  final String title;
  final String imageUrl;

  MealItemModel({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  factory MealItemModel.fromJson(Map<String, dynamic> json) {
    return MealItemModel(
      id: json['idMeal'] ?? '',
      title: json['strMeal'] ?? '',
      imageUrl: json['strMealThumb'] ?? '',
    );
  }
}
