import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/features/todo/data/datasources/models/projects_model.dart';
import 'project_state.dart';
import 'package:flutter/material.dart';

class ProjectCubit extends Cubit<ProjectState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ProjectCubit() : super(ProjectInitial()) {
    loadProjects();
  }

  void loadProjects() {
    emit(ProjectLoading());
    try {
      _firestore
          .collection('projects')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen((snapshot) {
            final projects = snapshot.docs
                .map((doc) => ProjectModel.fromDocument(doc))
                .toList();
            emit(ProjectLoaded(projects: projects));
          });
    } catch (e) {
      emit(ProjectError(message: e.toString()));
    }
  }

  Future<void> addProject({required String name, required Color color}) async {
    try {
      final project = ProjectModel(
        id: '',
        name: name,
        color: color,
        taskCount: 0,
      );
      await _firestore.collection('projects').add(project.toMap());
    } catch (e) {
      emit(ProjectError(message: e.toString()));
    }
  }
}
