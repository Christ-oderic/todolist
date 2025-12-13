import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todolist/core/utils/enum.dart';

class TaskModel {
  final String id;
  final String libelle;
  final String? projectId;
  final List<String>? labelIds;
  final TaskStatus statut;
  final TaskPriority priorite;
  final DateTime createdAt;
  final DateTime date;
  final String userId;

  TaskModel({
    required this.id,
    required this.libelle,
    this.projectId,
    this.labelIds,
    this.statut = TaskStatus.todo,
    this.priorite = TaskPriority.normal,
    required this.createdAt,
    required this.date,
    required this.userId,
  });

  factory TaskModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return TaskModel(
      id: doc.id,
      libelle: data['libelle'] ?? '',
      projectId: data['project'],
      labelIds: List<String>.from(data['labels'] ?? []),
      statut: stringToTaskStatus(data['statut'] ?? 'todo'),
      priorite: stringToTaskPriority(data['priorite'] ?? 'normal'),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      userId: data['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'libelle': libelle,
      'project': projectId,
      'labels': labelIds ?? [],
      'statut': taskStatusToString(statut),
      'priorite': taskPriorityToString(priorite),
      'createdAt': createdAt,
      'date': date,
      'userId': userId,
    };
  }

  TaskModel copyWith({
    String? libelle,
    String? projectId,
    List<String>? labelIds,
    TaskStatus? statut,
  }) {
    return TaskModel(
      id: id,
      libelle: libelle ?? this.libelle,
      projectId: projectId ?? this.projectId,
      labelIds: labelIds ?? this.labelIds,
      statut: statut ?? this.statut,
      priorite: priorite,
      createdAt: createdAt,
      date: date,
      userId: userId,
    );
  }
}
