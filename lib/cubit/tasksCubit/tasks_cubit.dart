import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/core/utils/enum.dart';
import 'package:todolist/features/todo/domain/models/task_model.dart';

part 'tasks_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  // Stream<List<TaskModel>>? _subscription;

  TaskCubit({required this.userId}) : super(TaskInitial()) {
    _listenToTasks();
  }

  void _listenToTasks() {
    emit(TaskLoading());

    _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .orderBy('date')
        .snapshots()
        .listen(
          (snapshot) {
            final tasks = snapshot.docs
                .map((doc) => TaskModel.fromDocument(doc))
                .toList();

            emit(TaskLoaded(tasks));
          },
          onError: (e) {
            emit(TaskError(message: e.toString()));
          },
        );
  }

  Future<void> addTask(TaskModel task) async {
    try {
      final batch = _firestore.batch();

      // 1️⃣ Création de la tâche
      final taskRef = _firestore.collection('tasks').doc();
      batch.set(taskRef, {
        ...task.toMap(),
        'userId': userId,
        'createdAt': DateTime.now(),
      });

      // 2️⃣ Incrément des labels
      for (final labelId in task.labelIds ?? []) {
        final labelRef = _firestore.collection('labels').doc(labelId);
        batch.update(labelRef, {'count': FieldValue.increment(1)});
      }

      // 3️⃣ Incrément du projet
      if (task.projectId != null) {
        final projectRef = _firestore
            .collection('projects')
            .doc(task.projectId);
        batch.update(projectRef, {'count': FieldValue.increment(1)});
      }

      // 4️⃣ Commit atomique
      await batch.commit();
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }

  Future<void> updateTasksStatus(String taskId, TaskStatus status) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update({
        'statut': taskStatusToString(status),
      });
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }
}
