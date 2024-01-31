import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobs_repository/jobs_repository.dart';

part 'add_after_image_event.dart';
part 'add_after_image_state.dart';

class AddAfterImageBloc extends Bloc<AddAfterImageEvent, AddAfterImageState> {
  final JobsRepository _jobsRepository;

  final String userId;
  AddAfterImageBloc(
      {required JobsRepository jobsRepository, required this.userId})
      : _jobsRepository = jobsRepository,
        super(const AddAfterImageState()) {
    on<UpdateJobWithAfterImage>(_updateJobWithAfterImage);
  }

  FutureOr<void> _updateJobWithAfterImage(
      UpdateJobWithAfterImage event, Emitter<AddAfterImageState> emit) async {
    final ImagePicker picker = ImagePicker();

    final List<XFile> imageList = await picker.pickMultiImage();
    emit(state.copyWith(status: AddAfterImageStatus.inProgress));

    final List<String> imageNames = [];
    final List<String> imageFilePaths = [];

    for (var image in imageList) {
      imageNames.add(image.name);
      imageFilePaths.add(image.path);
    }

    if (imageNames.isEmpty || imageFilePaths.isEmpty) {
      emit(state.copyWith(
          status: AddAfterImageStatus.failure,
          errorMessage: 'Image Not Selected'));
      emit(state.copyWith(status: AddAfterImageStatus.initial));
      return;
    }

    try {
      await _jobsRepository.setJobImage(
          event.job, imageFilePaths, imageNames, userId, false);

      emit(state.copyWith(status: AddAfterImageStatus.success));
    } on SetFirebaseDataFailure catch (e) {
      emit(state.copyWith(
          status: AddAfterImageStatus.failure, errorMessage: e.message));
      emit(state.copyWith(status: AddAfterImageStatus.initial));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: AddAfterImageStatus.failure));
      emit(state.copyWith(status: AddAfterImageStatus.initial));
    }
  }
}
