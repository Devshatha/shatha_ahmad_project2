import 'dart:convert';

class MealModel {
  final String id;
  final String title;
  final String category;
  final String imageUrl;
  final String instructions;

  MealModel({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.instructions,
  });

  factory MealModel.fromJson(Map<String, dynamic> josn) {
    return MealModel(
      id: josn['idMeal'] ?? '',
      title: josn['strMeal'] ?? '',
      category: josn['Vegetarian'] ?? '',
      imageUrl: josn['strMealThumb'] ?? '',
      instructions: josn['strInstructions'] ?? '',
    );
  }
}
