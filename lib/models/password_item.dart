// lib/models/password_item.dart
import 'package:flutter/material.dart';

enum PasswordCategory {
  social,
  work,
  banking,
  personal,
  entertainment,
  other;

  String get displayName {
    switch (this) {
      case PasswordCategory.social:
        return 'وسائل التواصل';
      case PasswordCategory.work:
        return 'العمل';
      case PasswordCategory.banking:
        return 'البنوك';
      case PasswordCategory.personal:
        return 'شخصي';
      case PasswordCategory.entertainment:
        return 'ترفيه';
      case PasswordCategory.other:
        return 'أخرى';
    }
  }

  IconData get icon {
    switch (this) {
      case PasswordCategory.social:
        return Icons.people_alt;
      case PasswordCategory.work:
        return Icons.work_outline;
      case PasswordCategory.banking:
        return Icons.credit_card;
      case PasswordCategory.personal:
        return Icons.face;
      case PasswordCategory.entertainment:
        return Icons.music_note;
      case PasswordCategory.other:
        return Icons.grid_view;
    }
  }

  Color get color {
    return const Color.fromARGB(255, 98, 154, 181);
  }

  Color get lightColor {
    return color.withOpacity(0.1);
  }
}

class PasswordItem {
  int? id;
  String accountName;
  String password;
  DateTime createdAt;
  PasswordCategory category;
  String? notes;
  String? website;
  // int usageCount;
  // bool isFavorite;

  PasswordItem({
    this.id,
    required this.accountName,
    required this.password,
    DateTime? createdAt,
    this.category = PasswordCategory.other,
    this.notes,
    this.website,
    // this.usageCount = 0,
    // this.isFavorite = false,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'accountName': accountName,
      'password': password,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'category': category.index,
      'notes': notes,
      'website': website,
      // 'usageCount': usageCount,
      // 'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory PasswordItem.fromMap(Map<String, dynamic> map) {
    return PasswordItem(
      id: map['id'],
      accountName: map['accountName'],
      password: map['password'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      category: PasswordCategory.values[map['category'] ?? 5],
      notes: map['notes'],
      website: map['website'],
      // usageCount: map['usageCount'] ?? 0,
      // isFavorite: (map['isFavorite'] ?? 0) == 1,
    );
  }

  PasswordItem copyWith({
    int? id,
    String? accountName,
    String? password,
    DateTime? createdAt,
    PasswordCategory? category,
    String? notes,
    String? website,
    // int? usageCount,
    // bool? isFavorite,
  }) {
    return PasswordItem(
      id: id ?? this.id,
      accountName: accountName ?? this.accountName,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
      notes: notes ?? this.notes,
      website: website ?? this.website,
      // usageCount: usageCount ?? this.usageCount,
      // isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}