part of 'delete_tool_bloc.dart';

sealed class DeleteToolState extends Equatable {
  const DeleteToolState();

  @override
  List<Object> get props => [];
}

final class DeleteToolInitial extends DeleteToolState {}

final class DeleteToolSuccess extends DeleteToolState {}

final class DeleteToolFailure extends DeleteToolState {
  final String? errorMessage;

  const DeleteToolFailure({required this.errorMessage});
}
