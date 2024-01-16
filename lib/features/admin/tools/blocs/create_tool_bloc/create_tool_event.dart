part of 'create_tool_bloc.dart';

sealed class CreateToolEvent extends Equatable {
  const CreateToolEvent();

  @override
  List<Object> get props => [];
}

final class CreateToolWithDataModel extends CreateToolEvent {}

final class NameChanged extends CreateToolEvent {
  final String name;
  const NameChanged({required this.name});

  @override
  List<Object> get props => [name];
}

final class CategoryChanged extends CreateToolEvent {
  final String category;
  const CategoryChanged({required this.category});

  @override
  List<Object> get props => [category];
}

final class QuantityChanged extends CreateToolEvent {
  final String quantity;
  const QuantityChanged({required this.quantity});

  @override
  List<Object> get props => [quantity];
}

//TODO: ADD AN EVENT FOR TOOL IMAGE CHANGED