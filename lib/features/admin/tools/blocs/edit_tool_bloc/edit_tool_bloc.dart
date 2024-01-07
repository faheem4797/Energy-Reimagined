import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tools_repository/tools_repository.dart';

part 'edit_tool_event.dart';
part 'edit_tool_state.dart';

class EditToolBloc extends Bloc<EditToolEvent, EditToolState> {
  final ToolsRepository _toolsRepository;
  final ToolModel oldToolModel;
  EditToolBloc(
      {required ToolsRepository toolsRepository, required this.oldToolModel})
      : _toolsRepository = toolsRepository,
        super(EditToolState(tool: oldToolModel)) {
    on<EditToolWithUpdatedToolModel>(_editToolWithUpdatedToolModel);
    on<NameChanged>(_nameChanged);
    on<CategoryChanged>(_categoryChanged);
    on<QuantityChanged>(_quantityChanged);
  }
  RegExp numberOnlyRegex = RegExp(r'^\d+$');

  FutureOr<void> _editToolWithUpdatedToolModel(
      EditToolWithUpdatedToolModel event, Emitter<EditToolState> emit) async {
    emit(state.copyWith(
      isValid: _validate(
        name: state.tool.name,
        category: state.tool.category,
        quantity: state.tool.quantity.toString(),
      ),
    ));
    if (!state.isValid) {
      emit(state.copyWith(
          status: EditToolStatus.failure, errorMessage: 'Invalid Form Data'));
      emit(state.copyWith(status: EditToolStatus.initial));
      return;
    }
    emit(state.copyWith(status: EditToolStatus.inProgress));
    try {
      emit(state.copyWith(
          tool: state.tool
              .copyWith(lastUpdated: DateTime.now().microsecondsSinceEpoch)));

      await _toolsRepository.setToolData(state.tool);

      emit(state.copyWith(status: EditToolStatus.success));
    } on SetFirebaseDataFailure catch (e) {
      emit(state.copyWith(
          status: EditToolStatus.failure, errorMessage: e.message));
      emit(state.copyWith(status: EditToolStatus.initial));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: EditToolStatus.failure));
      emit(state.copyWith(status: EditToolStatus.initial));
    }
  }

  FutureOr<void> _nameChanged(NameChanged event, Emitter<EditToolState> emit) {
    final NameValidationStatus nameValidationStatus = _validateName(event.name);
    emit(
      state.copyWith(
        tool: state.tool.copyWith(name: event.name),
        isValid: _validate(
          name: event.name,
          category: state.tool.category,
          quantity: state.tool.quantity.toString(),
        ),
        displayError: nameValidationStatus == NameValidationStatus.empty
            ? 'Please enter a name'
            : null,
      ),
    );
  }

  FutureOr<void> _quantityChanged(
      QuantityChanged event, Emitter<EditToolState> emit) {
    final QuantityValidationStatus quantityValidationStatus =
        _validateQuantity(event.quantity);
    emit(
      state.copyWith(
        tool: state.tool.copyWith(quantity: int.tryParse(event.quantity) ?? 0),
        isValid: _validate(
          name: state.tool.name,
          category: state.tool.category,
          quantity: event.quantity,
        ),
        displayError: quantityValidationStatus == QuantityValidationStatus.empty
            ? 'Please enter a quantity'
            : quantityValidationStatus == QuantityValidationStatus.invalid
                ? 'Please enter a valid number'
                : null,
      ),
    );
  }

  FutureOr<void> _categoryChanged(
      CategoryChanged event, Emitter<EditToolState> emit) {
    final CategoryValidationStatus categoryValidationStatus =
        _validateCategory(event.category);
    emit(
      state.copyWith(
        tool: state.tool.copyWith(category: event.category),
        isValid: _validate(
          name: state.tool.name,
          category: event.category,
          quantity: state.tool.quantity.toString(),
        ),
        displayError: categoryValidationStatus == CategoryValidationStatus.empty
            ? 'Please enter a category'
            : null,
      ),
    );
  }

  bool _validate({
    required String name,
    required String category,
    required String quantity,
  }) {
    final NameValidationStatus nameValidationStatus = _validateName(name);

    final CategoryValidationStatus categoryValidationStatus =
        _validateCategory(category);
    final QuantityValidationStatus quantityValidationStatus =
        _validateQuantity(quantity);

    return nameValidationStatus == NameValidationStatus.valid &&
        categoryValidationStatus == CategoryValidationStatus.valid &&
        quantityValidationStatus == QuantityValidationStatus.valid;
  }

  NameValidationStatus _validateName(String name) {
    if (name.isEmpty) {
      return NameValidationStatus.empty;
    } else {
      return NameValidationStatus.valid;
    }
  }

  CategoryValidationStatus _validateCategory(String category) {
    if (category.isEmpty) {
      return CategoryValidationStatus.empty;
    } else {
      return CategoryValidationStatus.valid;
    }
  }

  QuantityValidationStatus _validateQuantity(String quantity) {
    if (quantity.isEmpty) {
      return QuantityValidationStatus.empty;
    } else if (!numberOnlyRegex.hasMatch(quantity)) {
      return QuantityValidationStatus.invalid;
    } else {
      return QuantityValidationStatus.valid;
    }
  }
}

enum NameValidationStatus { empty, valid }

enum CategoryValidationStatus { empty, valid }

enum QuantityValidationStatus { empty, invalid, valid }
