// lib/widgets/category_selector.dart
import 'package:flutter/material.dart';
import '../models/password_item.dart';

class CategorySelector extends StatefulWidget {
  final PasswordCategory selectedCategory;
  final Function(PasswordCategory) onCategorySelected;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: PasswordCategory.values.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final category = PasswordCategory.values[index];
          final isSelected = widget.selectedCategory == category;

          return GestureDetector(
            onTap: () => widget.onCategorySelected(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isSelected
                      ? [category.color, category.color.withOpacity(0.8)]
                      : [Colors.white, Colors.white],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: category.color.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ]
                    : [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.grey.shade200,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    category.icon,
                    size: 32,
                    color: isSelected ? Colors.white : category.color,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.displayName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                      fontFamily: 'Tajawal',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}