import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/core/utils/enum.dart';
import 'package:todolist/features/todo/domain/models/task_model.dart';

part 'tasks_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TaskCubit() : super(TaskInitial());

  Stream<List<TaskModel>> taskStream(String userId) {
    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => TaskModel.fromDocument(doc)).toList(),
        );
  }

  Future<void> addTask(TaskModel task, String userId) async {
    emit(TaskLoading());
    try {
      await _firestore.collection('tasks').add({
        ...task.toMap(),
        'userId': userId,
      });
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }

  Future<void> deleteTask(String taskId) async {
    emit(TaskLoading());
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
      emit(TaskSuccess());
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }

  Future<void> updateTasksStatus(String taskId, TaskStatus statut) async {
    emit(TaskLoading());
    try {
      await _firestore.collection('tsks').doc(taskId).update({
        'statut': taskStatusToString(statut),
      });
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }
}
