part of 'edit_tool_bloc.dart';

sealed class EditToolEvent extends Equatable {
  const EditToolEvent();

  @override
  List<Object> get props => [];
}

final class EditToolWithUpdatedToolModel extends EditToolEvent {}

final class NameChanged extends EditToolEvent {
  final String name;
  const NameChanged({required this.name});

  @override
  List<Object> get props => [name];
}

final class CategoryChanged extends EditToolEvent {
  final String category;
  const CategoryChanged({required this.category});

  @override
  List<Object> get props => [category];
}

final class QuantityChanged extends EditToolEvent {
  final String quantity;
  const QuantityChanged({required this.quantity});

  @override
  List<Object> get props => [quantity];
}

final class ImageChanged extends EditToolEvent {
  const ImageChanged();

  @override
  List<Object> get props => [];
}
