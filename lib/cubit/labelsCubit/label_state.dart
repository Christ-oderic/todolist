import 'package:todolist/features/todo/domain/models/label_model.dart';

abstract class LabelState {}

class LabelInitial extends LabelState {}

class LabelLoading extends LabelState {}

class LabelLoaded extends LabelState {
  final List<LabelModel> labels;
  LabelLoaded({required this.labels});
}

class LabelError extends LabelState {
  final String message;
  LabelError({required this.message});
}
