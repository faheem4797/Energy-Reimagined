import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
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
    on<ImageChanged>(_imageChanged);
  }
  RegExp numberOnlyRegex = RegExp(r'^\d+$');

  FutureOr<void> _editToolWithUpdatedToolModel(
      EditToolWithUpdatedToolModel event, Emitter<EditToolState> emit) async {
    emit(state.copyWith(
      isValid: _validate(
        name: state.tool.name,
        category: state.tool.category,
        quantity: state.tool.quantity.toString(),
        // imageToolFileBytes: state.imageToolFileBytes,
        // imageToolFileNameFromFilePicker: state.imageToolFileNameFromFilePicker,
        // imageToolFilePathFromFilePicker: state.imageToolFilePathFromFilePicker,
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
      await _toolsRepository.setToolData(
          state.tool,
          state.imageToolFilePathFromFilePicker,
          state.imageToolFileNameFromFilePicker);

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
          // imageToolFileBytes: state.imageToolFileBytes,
          // imageToolFileNameFromFilePicker:
          //     state.imageToolFileNameFromFilePicker,
          // imageToolFilePathFromFilePicker:
          //     state.imageToolFilePathFromFilePicker,
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
          // imageToolFileBytes: state.imageToolFileBytes,
          // imageToolFileNameFromFilePicker:
          //     state.imageToolFileNameFromFilePicker,
          // imageToolFilePathFromFilePicker:
          //     state.imageToolFilePathFromFilePicker,
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
          // imageToolFileBytes: state.imageToolFileBytes,
          // imageToolFileNameFromFilePicker:
          //     state.imageToolFileNameFromFilePicker,
          // imageToolFilePathFromFilePicker:
          //     state.imageToolFilePathFromFilePicker,
        ),
        displayError: categoryValidationStatus == CategoryValidationStatus.empty
            ? 'Please enter a category'
            : null,
      ),
    );
  }

  FutureOr<void> _imageChanged(
      ImageChanged event, Emitter<EditToolState> emit) async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    final Uint8List? imageBytes = await image?.readAsBytes();

    // final ImageValidationStatus imageValidationStatus =
    //     _validateToolImage(imageBytes, image?.path, image?.name);

    emit(
      state.copyWith(
        tool: state.tool,
        imageToolFileBytes: imageBytes,
        imageToolFileNameFromFilePicker: image?.name,
        imageToolFilePathFromFilePicker: image?.path,
        isValid: _validate(
          name: state.tool.name,
          category: state.tool.category,
          quantity: state.tool.quantity.toString(),
          // imageToolFileBytes: imageBytes,
          // imageToolFileNameFromFilePicker: image?.name,
          // imageToolFilePathFromFilePicker: image?.path,
        ),
        // displayError: imageValidationStatus == ImageValidationStatus.empty
        //     ? 'Please select an image'
        //     : null,
      ),
    );
  }

  bool _validate({
    required String name,
    required String category,
    required String quantity,
    // required Uint8List? imageToolFileBytes,
    // required String? imageToolFilePathFromFilePicker,
    // required String? imageToolFileNameFromFilePicker,
  }) {
    final NameValidationStatus nameValidationStatus = _validateName(name);

    final CategoryValidationStatus categoryValidationStatus =
        _validateCategory(category);
    final QuantityValidationStatus quantityValidationStatus =
        _validateQuantity(quantity);
    // final ImageValidationStatus imageValidationStatus = _validateToolImage(
    //     imageToolFileBytes,
    //     imageToolFilePathFromFilePicker,
    //     imageToolFileNameFromFilePicker);

    return nameValidationStatus == NameValidationStatus.valid &&
            categoryValidationStatus == CategoryValidationStatus.valid &&
            quantityValidationStatus == QuantityValidationStatus.valid
        // &&
        // imageValidationStatus == ImageValidationStatus.valid
        ;
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

  // ImageValidationStatus _validateToolImage(
  //     Uint8List? imageToolFileBytes,
  //     String? imageToolFilePathFromFilePicker,
  //     String? imageToolFileNameFromFilePicker) {
  //   if (imageToolFilePathFromFilePicker == null ||
  //       imageToolFileNameFromFilePicker == null ||
  //       imageToolFileBytes == null) {
  //     return ImageValidationStatus.empty;
  //   } else {
  //     return ImageValidationStatus.valid;
  //   }
  // }
}

enum NameValidationStatus { empty, valid }

enum CategoryValidationStatus { empty, valid }

enum QuantityValidationStatus { empty, invalid, valid }

// enum ImageValidationStatus { empty, valid }
