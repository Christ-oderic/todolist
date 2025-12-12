import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/cubit/labelsCubit/label_state.dart';
import 'package:todolist/features/todo/domain/models/label_model.dart';

class LabelCubit extends Cubit<LabelState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  LabelCubit() : super(LabelInitial()) {
    loadLabels();
  }

  void loadLabels() {
    emit(LabelLoading());
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      emit(LabelError(message: "Aucun utilisateur connecté."));
      return;
    }
    try {
      _firestore
          .collection('labels')
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen((snapshot) {
            final labels = snapshot.docs
                .map((doc) => LabelModel.fromDocument(doc))
                .toList();
            emit(LabelLoaded(labels: labels));
          });
    } catch (e) {
      emit(LabelError(message: e.toString()));
    }
  }

  Future<void> addLabel({required String name, required Color color}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(LabelError(message: "Utilisateur non connecté."));
        return;
      }
      final label = LabelModel(
        id: '',
        userId: user.uid,
        name: name,
        color: color,
        labelCounts: 0,
      );
      await _firestore.collection('labels').add(label.toMap());
    } catch (e) {
      emit(LabelError(message: e.toString()));
    }
  }
}
