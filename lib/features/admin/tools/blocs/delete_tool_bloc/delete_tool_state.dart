part of 'delete_tool_bloc.dart';

sealed class DeleteToolState extends Equatable {
  const DeleteToolState();
  
  @override
  List<Object> get props => [];
}

final class DeleteToolInitial extends DeleteToolState {}
