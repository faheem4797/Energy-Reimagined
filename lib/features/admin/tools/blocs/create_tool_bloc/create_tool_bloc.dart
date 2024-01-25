import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
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
    on<DescriptionChanged>(_descriptionChanged);
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

      await _toolsRepository.setToolData(
          state.tool,
          state.imageToolFilePathFromFilePicker,
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
          description: state.tool.description,
          category: state.tool.category,
          quantity: state.tool.quantity.toString(),
          imageToolFileBytes: state.imageToolFileBytes,
          imageToolFileNameFromFilePicker:
              state.imageToolFileNameFromFilePicker,
          imageToolFilePathFromFilePicker:
              state.imageToolFilePathFromFilePicker,
        ),
        displayError: nameValidationStatus == NameValidationStatus.empty
            ? 'Please enter a name'
            : null,
      ),
    );
  }

  FutureOr<void> _descriptionChanged(
      DescriptionChanged event, Emitter<CreateToolState> emit) {
    final DescriptionValidationStatus descriptionValidationStatus =
        _validateDescription(event.description);
    emit(
      state.copyWith(
        tool: state.tool.copyWith(description: event.description),
        isValid: _validate(
          name: state.tool.name,
          description: event.description,
          category: state.tool.category,
          quantity: state.tool.quantity.toString(),
          imageToolFileBytes: state.imageToolFileBytes,
          imageToolFileNameFromFilePicker:
              state.imageToolFileNameFromFilePicker,
          imageToolFilePathFromFilePicker:
              state.imageToolFilePathFromFilePicker,
        ),
        displayError:
            descriptionValidationStatus == DescriptionValidationStatus.empty
                ? 'Please enter a description'
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
          description: state.tool.description,
          category: event.category,
          quantity: state.tool.quantity.toString(),
          imageToolFileBytes: state.imageToolFileBytes,
          imageToolFileNameFromFilePicker:
              state.imageToolFileNameFromFilePicker,
          imageToolFilePathFromFilePicker:
              state.imageToolFilePathFromFilePicker,
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
          description: state.tool.description,
          category: state.tool.category,
          quantity: event.quantity,
          imageToolFileBytes: state.imageToolFileBytes,
          imageToolFileNameFromFilePicker:
              state.imageToolFileNameFromFilePicker,
          imageToolFilePathFromFilePicker:
              state.imageToolFilePathFromFilePicker,
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
      ImageChanged event, Emitter<CreateToolState> emit) async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    final Uint8List? imageBytes = await image?.readAsBytes();

    final ImageValidationStatus imageValidationStatus =
        _validateToolImage(imageBytes, image?.path, image?.name);

    emit(
      state.copyWith(
        tool: state.tool,
        imageToolFileBytes: imageBytes,
        imageToolFileNameFromFilePicker: image?.name,
        imageToolFilePathFromFilePicker: image?.path,
        isValid: _validate(
          name: state.tool.name,
          description: state.tool.description,
          category: state.tool.category,
          quantity: state.tool.quantity.toString(),
          imageToolFileBytes: imageBytes,
          imageToolFileNameFromFilePicker: image?.name,
          imageToolFilePathFromFilePicker: image?.path,
        ),
        displayError: imageValidationStatus == ImageValidationStatus.empty
            ? 'Please select an image'
            : null,
      ),
    );
  }

  bool _validate({
    required String name,
    required String description,
    required String category,
    required String quantity,
    required Uint8List? imageToolFileBytes,
    required String? imageToolFilePathFromFilePicker,
    required String? imageToolFileNameFromFilePicker,
  }) {
    final NameValidationStatus nameValidationStatus = _validateName(name);
    final DescriptionValidationStatus descriptionValidationStatus =
        _validateDescription(description);
    final CategoryValidationStatus categoryValidationStatus =
        _validateCategory(category);
    final QuantityValidationStatus quantityValidationStatus =
        _validateQuantity(quantity);
    final ImageValidationStatus imageValidationStatus = _validateToolImage(
        imageToolFileBytes,
        imageToolFilePathFromFilePicker,
        imageToolFileNameFromFilePicker);

    return nameValidationStatus == NameValidationStatus.valid &&
        descriptionValidationStatus == DescriptionValidationStatus.valid &&
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

  DescriptionValidationStatus _validateDescription(String description) {
    if (description.isEmpty) {
      return DescriptionValidationStatus.empty;
    } else {
      return DescriptionValidationStatus.valid;
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
      Uint8List? imageToolFileBytes,
      String? imageToolFilePathFromFilePicker,
      String? imageToolFileNameFromFilePicker) {
    if (imageToolFilePathFromFilePicker == null ||
        imageToolFileNameFromFilePicker == null ||
        imageToolFileBytes == null) {
      return ImageValidationStatus.empty;
    } else {
      return ImageValidationStatus.valid;
    }
  }
}

enum NameValidationStatus { empty, valid }

enum DescriptionValidationStatus { empty, valid }

enum CategoryValidationStatus { empty, valid }

enum QuantityValidationStatus { empty, invalid, valid }

enum ImageValidationStatus { empty, valid }
