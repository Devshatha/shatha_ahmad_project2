import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
import '../models/meal_item_model.dart';

class Api {
  Future<List<CategoryModel>> getCategories() async {
    final url = Uri.parse(
      'https://www.themealdb.com/api/json/v1/1/categories.php',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List categoriesJson = data['categories'];
      return categoriesJson
          .map((item) => CategoryModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<MealItemModel>> getMealsByCategory(String categoryName) async {
    final url = Uri.parse(
      'https://www.themealdb.com/api/json/v1/1/filter.php?c=$categoryName',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List mealsJson = data['meals'];
      return mealsJson.map((item) => MealItemModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load meals for $categoryName');
    }
  }

  Future<Map<String, dynamic>> getMealDetails(String mealId) async {
    final url = Uri.parse(
      'https://www.themealdb.com/api/json/v1/1/lookup.php?i=$mealId',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['meals'][0];
    } else {
      throw Exception('Failed to load meal details');
    }
  }
}
