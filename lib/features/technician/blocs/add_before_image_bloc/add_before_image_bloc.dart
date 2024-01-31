import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobs_repository/jobs_repository.dart';

part 'add_before_image_event.dart';
part 'add_before_image_state.dart';

class AddBeforeImageBloc
    extends Bloc<AddBeforeImageEvent, AddBeforeImageState> {
  final JobsRepository _jobsRepository;

  final String userId;
  AddBeforeImageBloc(
      {required JobsRepository jobsRepository, required this.userId})
      : _jobsRepository = jobsRepository,
        super(const AddBeforeImageState()) {
    on<UpdateJobWithBeforeImage>(_updateJobWithBeforeImage);
  }

  FutureOr<void> _updateJobWithBeforeImage(
      UpdateJobWithBeforeImage event, Emitter<AddBeforeImageState> emit) async {
    final ImagePicker picker = ImagePicker();

    final List<XFile> imageList = await picker.pickMultiImage();
    emit(state.copyWith(status: AddBeforeImageStatus.inProgress));

    print(state.status);
    final List<String> imageNames = [];
    final List<String> imageFilePaths = [];

    for (var image in imageList) {
      imageNames.add(image.name);
      imageFilePaths.add(image.path);
    }

    if (imageNames.isEmpty || imageFilePaths.isEmpty) {
      emit(state.copyWith(
          status: AddBeforeImageStatus.failure,
          errorMessage: 'Image Not Selected'));
      emit(state.copyWith(status: AddBeforeImageStatus.initial));
      return;
    }
    try {
      await _jobsRepository.setJobImage(
          event.job, imageFilePaths, imageNames, userId, true);

      emit(state.copyWith(status: AddBeforeImageStatus.success));
    } on SetFirebaseDataFailure catch (e) {
      emit(state.copyWith(
          status: AddBeforeImageStatus.failure, errorMessage: e.message));
      emit(state.copyWith(status: AddBeforeImageStatus.initial));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: AddBeforeImageStatus.failure));
      emit(state.copyWith(status: AddBeforeImageStatus.initial));
    }
  }
}
