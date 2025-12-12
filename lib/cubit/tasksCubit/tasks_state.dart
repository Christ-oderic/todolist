part of 'tasks_cubit.dart';

abstract class TaskState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskSuccess extends TaskState {}

class TaskError extends TaskState {
  final String message;
  TaskError({required this.message});

  @override
  List<Object?> get props => [message];
}
