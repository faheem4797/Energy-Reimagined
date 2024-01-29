import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobs_repository/jobs_repository.dart';

part 'before_completion_image_event.dart';
part 'before_completion_image_state.dart';

class BeforeCompletionImageBloc
    extends Bloc<BeforeCompletionImageEvent, BeforeCompletionImageState> {
  final JobsRepository _jobsRepository;
  final JobModel jobModel;
  final String userId;
  BeforeCompletionImageBloc(
      {required JobsRepository jobsRepository,
      required this.jobModel,
      required this.userId})
      : _jobsRepository = jobsRepository,
        super(BeforeCompletionImageState(job: jobModel)) {
    on<BeforeCompletionImageChanged>(_beforeCompletionImageChanged);
    on<UpdateJobWithBeforeImage>(_updateJobWithBeforeImage);
  }

  FutureOr<void> _beforeCompletionImageChanged(
      BeforeCompletionImageChanged event,
      Emitter<BeforeCompletionImageState> emit) async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    final Uint8List? imageBytes = await image?.readAsBytes();

    emit(state.copyWith(
      imageToolFileBytes: imageBytes,
      imageToolFileNameFromFilePicker: image?.name,
      imageToolFilePathFromFilePicker: image?.path,
    ));
  }

  FutureOr<void> _updateJobWithBeforeImage(UpdateJobWithBeforeImage event,
      Emitter<BeforeCompletionImageState> emit) async {
    if (state.imageToolFileBytes == null ||
        state.imageToolFilePathFromFilePicker == null) {
      emit(state.copyWith(
          status: BeforeCompletionImageStatus.failure,
          errorMessage: 'Image Not Selected'));
      emit(state.copyWith(status: BeforeCompletionImageStatus.initial));
      return;
    }
    emit(state.copyWith(status: BeforeCompletionImageStatus.inProgress));
    try {
      await _jobsRepository.setJobDataWithBeforeImage(
          state.job,
          state.imageToolFilePathFromFilePicker!,
          state.imageToolFileNameFromFilePicker!,
          userId);

      emit(state.copyWith(status: BeforeCompletionImageStatus.success));
    } on SetFirebaseDataFailure catch (e) {
      emit(state.copyWith(
          status: BeforeCompletionImageStatus.failure,
          errorMessage: e.message));
      emit(state.copyWith(status: BeforeCompletionImageStatus.initial));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: BeforeCompletionImageStatus.failure));
      emit(state.copyWith(status: BeforeCompletionImageStatus.initial));
    }
  }
}
