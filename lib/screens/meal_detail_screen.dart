import 'package:flutter/material.dart';
import '../services/api.dart';
import 'rating_screen.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;
  final String mealTitle;

  const MealDetailScreen({
    super.key,
    required this.mealId,
    required this.mealTitle,
  });

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

bool _isFavorite = false;

class _MealDetailScreenState extends State<MealDetailScreen> {
  final Api api = Api();
  late Future<Map<String, dynamic>> mealFuture;

  @override
  void initState() {
    super.initState();
    mealFuture = api.getMealDetails(widget.mealId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFF9F5),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.white : Colors.white70,
              size: 26,
            ),
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });

              // رسالة تنبيه سريعة أسفل الشاشة
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isFavorite
                        ? 'Added to your favorites! ❤️'
                        : 'Removed from favorites',
                  ),
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: const Color(0xFF2D2D2D),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
        backgroundColor: const Color(0xFFF5D9D7),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.mealTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: mealFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFF5D9D7)),
            );
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading recipe details'));
          }

          if (snapshot.hasData) {
            final meal = snapshot.data!;
            final String instructions =
                meal['strInstructions'] ?? 'No instructions available.';
            final String imageUrl = meal['strMealThumb'] ?? '';

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      imageUrl,
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Instructions & Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF5D9D7),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      instructions,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RatingScreen(mealTitle: widget.mealTitle),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.star_rate_rounded,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Rate this Recipe',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD96C75),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
