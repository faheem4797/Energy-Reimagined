import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tools_repository/tools_repository.dart';
import 'package:uuid/uuid.dart';

part 'create_tool_event.dart';
part 'create_tool_state.dart';

class CreateToolBloc extends Bloc<CreateToolEvent, CreateToolState> {
  final ToolsRepository _toolsRepository;
  CreateToolBloc({required ToolsRepository toolsRepository})
      : _toolsRepository = toolsRepository,
        super(const CreateToolState()) {
    on<CreateToolWithDataModel>(_createToolWithDataModel);
    on<NameChanged>(_nameChanged);
    on<CategoryChanged>(_categoryChanged);
    on<QuantityChanged>(_quantityChanged);
    on<ImageChanged>(_imageChanged);
  }

  RegExp numberOnlyRegex = RegExp(r'^\d+$');

  FutureOr<void> _createToolWithDataModel(
      CreateToolWithDataModel event, Emitter<CreateToolState> emit) async {
    if (!state.isValid) {
      emit(state.copyWith(
          status: CreateToolStatus.failure, errorMessage: 'Invalid Form Data'));
      emit(state.copyWith(status: CreateToolStatus.initial));
      return;
    }
    emit(state.copyWith(status: CreateToolStatus.inProgress));
    try {
      emit(state.copyWith(
          tool: state.tool.copyWith(
              id: const Uuid().v1(),
              lastUpdated: DateTime.now().microsecondsSinceEpoch)));

      await _toolsRepository.setToolData(state.tool, state.imageToolFile,
          state.imageToolFileNameFromFilePicker);

      emit(state.copyWith(status: CreateToolStatus.success));
    } on SetFirebaseDataFailure catch (e) {
      emit(state.copyWith(
          status: CreateToolStatus.failure, errorMessage: e.message));
      emit(state.copyWith(status: CreateToolStatus.initial));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: CreateToolStatus.failure));
      emit(state.copyWith(status: CreateToolStatus.initial));
    }
  }

  FutureOr<void> _nameChanged(
      NameChanged event, Emitter<CreateToolState> emit) {
    final NameValidationStatus nameValidationStatus = _validateName(event.name);
    emit(
      state.copyWith(
        tool: state.tool.copyWith(name: event.name),
        isValid: _validate(
          name: event.name,
          category: state.tool.category,
          quantity: state.tool.quantity.toString(),
          toolImageFile: state.imageToolFile,
          toolImageNameFromImagePicker: state.imageToolFileNameFromFilePicker,
        ),
        displayError: nameValidationStatus == NameValidationStatus.empty
            ? 'Please enter a name'
            : null,
      ),
    );
  }

  FutureOr<void> _categoryChanged(
      CategoryChanged event, Emitter<CreateToolState> emit) {
    final CategoryValidationStatus categoryValidationStatus =
        _validateCategory(event.category);
    emit(
      state.copyWith(
        tool: state.tool.copyWith(category: event.category),
        isValid: _validate(
          name: state.tool.name,
          category: event.category,
          quantity: state.tool.quantity.toString(),
          toolImageFile: state.imageToolFile,
          toolImageNameFromImagePicker: state.imageToolFileNameFromFilePicker,
        ),
        displayError: categoryValidationStatus == CategoryValidationStatus.empty
            ? 'Please enter a category'
            : null,
      ),
    );
  }

  FutureOr<void> _quantityChanged(
      QuantityChanged event, Emitter<CreateToolState> emit) {
    final QuantityValidationStatus quantityValidationStatus =
        _validateQuantity(event.quantity);

    emit(
      state.copyWith(
        tool: state.tool.copyWith(quantity: int.tryParse(event.quantity) ?? 0),
        isValid: _validate(
          name: state.tool.name,
          category: state.tool.category,
          quantity: event.quantity,
          toolImageFile: state.imageToolFile,
          toolImageNameFromImagePicker: state.imageToolFileNameFromFilePicker,
        ),
        displayError: quantityValidationStatus == QuantityValidationStatus.empty
            ? 'Please enter a quantity'
            : quantityValidationStatus == QuantityValidationStatus.invalid
                ? 'Please enter a valid number'
                : null,
      ),
    );
  }

  FutureOr<void> _imageChanged(
      ImageChanged event, Emitter<CreateToolState> emit) {
    final ImageValidationStatus imageValidationStatus = _validateToolImage(
        event.toolImageFile, event.toolImageFileNameFromImagePicker);
    emit(
      state.copyWith(
        tool: state.tool,
        isValid: _validate(
          name: state.tool.name,
          category: state.tool.category,
          quantity: state.tool.quantity.toString(),
          toolImageFile: event.toolImageFile,
          toolImageNameFromImagePicker: event.toolImageFileNameFromImagePicker,
        ),
        displayError: imageValidationStatus == ImageValidationStatus.empty
            ? 'Please select an image'
            : null,
      ),
    );
  }

  bool _validate({
    required String name,
    required String category,
    required String quantity,
    required File? toolImageFile,
    required String? toolImageNameFromImagePicker,
  }) {
    final NameValidationStatus nameValidationStatus = _validateName(name);

    final CategoryValidationStatus categoryValidationStatus =
        _validateCategory(category);
    final QuantityValidationStatus quantityValidationStatus =
        _validateQuantity(quantity);
    final ImageValidationStatus imageValidationStatus =
        _validateToolImage(toolImageFile, toolImageNameFromImagePicker);

    return nameValidationStatus == NameValidationStatus.valid &&
        categoryValidationStatus == CategoryValidationStatus.valid &&
        quantityValidationStatus == QuantityValidationStatus.valid &&
        imageValidationStatus == ImageValidationStatus.valid;
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

  ImageValidationStatus _validateToolImage(
      File? toolImageFile, String? toolImageFileNameFromImagePicker) {
    if (toolImageFileNameFromImagePicker == null || toolImageFile == null) {
      return ImageValidationStatus.empty;
    } else {
      return ImageValidationStatus.valid;
    }
  }
}

enum NameValidationStatus { empty, valid }

enum CategoryValidationStatus { empty, valid }

enum QuantityValidationStatus { empty, invalid, valid }

enum ImageValidationStatus { empty, valid }
