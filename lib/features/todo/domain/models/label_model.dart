import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LabelModel {
  final String id;
  final String name;
  final Color color;
  final int labelCounts;
  final String userId;
  final DateTime? createdAt;

  LabelModel({
    required this.id,
    required this.name,
    required this.color,
    required this.userId,
    required this.labelCounts,
    this.createdAt,
  });

  factory LabelModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LabelModel(
      id: doc.id,
      name: data['name'] ?? '',
      color: _colorFromString(data['color']),
      labelCounts: data['labelCounts'] ?? 0,
      userId: data['userId'] ?? '',
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'color': _colorToString(color),
      'labelCounts': labelCounts,
      'userId': userId,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  static Color _colorFromString(String colorString) {
    switch (colorString) {
      case "Colors.blue":
        return Colors.blue;
      case "Colors.orange":
        return Colors.orange;
      case "Colors.red":
        return Colors.red;
      case "Colors.yellow":
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  static String _colorToString(Color color) {
    if (color == Colors.blue) return "Colors.blue";
    if (color == Colors.orange) return "Colors.orange";
    if (color == Colors.red) return "Colors.red";
    if (color == Colors.yellow) return "Colors.yellow";
    return "Colors.grey";
  }
}
