// import 'dart:async';
// import 'dart:developer';
// import 'dart:typed_data';

// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:jobs_repository/jobs_repository.dart';

// part 'complete_job_event.dart';
// part 'complete_job_state.dart';

// class CompleteJobBloc extends Bloc<CompleteJobEvent, CompleteJobState> {
//   final JobsRepository _jobsRepository;
//   final JobModel jobModel;
//   final String userId;
//   CompleteJobBloc(
//       {required JobsRepository jobsRepository,
//       required this.jobModel,
//       required this.userId})
//       : _jobsRepository = jobsRepository,
//         super(CompleteJobState(job: jobModel)) {
//     on<AfterCompletionImageChanged>(_afterCompletionImageChanged);
//     on<CompleteJob>(_completeJob);
//   }

//   FutureOr<void> _completeJob(
//       CompleteJob event, Emitter<CompleteJobState> emit) async {
//     if (state.imageToolFileBytes == null ||
//         state.imageToolFilePathFromFilePicker == null) {
//       emit(state.copyWith(
//           status: CompleteJobStatus.failure,
//           errorMessage: 'Image Not Selected'));
//       emit(state.copyWith(status: CompleteJobStatus.initial));
//       return;
//     }
//     emit(state.copyWith(status: CompleteJobStatus.inProgress));
//     try {
//       emit(state.copyWith(
//           job: state.job
//               .copyWith(workDoneDescription: event.workDoneDescription)));
//       await _jobsRepository.setJobDataWithCompleteImage(
//           state.job,
//           state.imageToolFilePathFromFilePicker!,
//           state.imageToolFileNameFromFilePicker!,
//           userId);

//       emit(state.copyWith(status: CompleteJobStatus.success));
//     } on SetFirebaseDataFailure catch (e) {
//       emit(state.copyWith(
//           status: CompleteJobStatus.failure, errorMessage: e.message));
//       emit(state.copyWith(status: CompleteJobStatus.initial));
//     } catch (e) {
//       log(e.toString());
//       emit(state.copyWith(status: CompleteJobStatus.failure));
//       emit(state.copyWith(status: CompleteJobStatus.initial));
//     }
//   }

//   FutureOr<void> _afterCompletionImageChanged(
//       AfterCompletionImageChanged event, Emitter<CompleteJobState> emit) async {
//     final ImagePicker picker = ImagePicker();

//     final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//     final Uint8List? imageBytes = await image?.readAsBytes();

//     emit(state.copyWith(
//       imageToolFileBytes: imageBytes,
//       imageToolFileNameFromFilePicker: image?.name,
//       imageToolFilePathFromFilePicker: image?.path,
//     ));
//   }
// }
