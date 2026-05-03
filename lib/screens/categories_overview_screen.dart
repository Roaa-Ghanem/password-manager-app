// lib/screens/categories_overview_screen.dart
import 'package:flutter/material.dart';
import '../models/password_item.dart';
import 'category_screen.dart';

class CategoriesOverviewScreen extends StatelessWidget {
  const CategoriesOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text(
          'التصنيفات',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromARGB(255, 98, 154, 181),
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.9,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: PasswordCategory.values.length,
        itemBuilder: (context, index) {
          final category = PasswordCategory.values[index];
          return _buildCategoryCard(context, category);
        },
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, PasswordCategory category) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryScreen(category: category),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // لون أبيض موحد
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 98, 154, 181).withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 98, 154, 181).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                category.icon,
                size: 35,
                color: const Color.fromARGB(255, 98, 154, 181), // لون موحد
              ),
            ),
            const SizedBox(height: 16),
            Text(
              category.displayName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 98, 154, 181), // لون موحد
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
      ),
    );
  }
}