part of 'edit_job_bloc.dart';

sealed class EditJobEvent extends Equatable {
  const EditJobEvent();

  @override
  List<Object> get props => [];
}

final class EditJobWithUpdatedJobModel extends EditJobEvent {}

final class TitleChanged extends EditJobEvent {
  final String title;
  const TitleChanged({required this.title});

  @override
  List<Object> get props => [title];
}

final class DescriptionChanged extends EditJobEvent {
  final String description;
  const DescriptionChanged({required this.description});

  @override
  List<Object> get props => [description];
}

final class MunicipalityChanged extends EditJobEvent {
  final String municipality;
  const MunicipalityChanged({required this.municipality});

  @override
  List<Object> get props => [municipality];
}

final class LocationChanged extends EditJobEvent {
  final String locationName;
  // final int locationLatitude;
  // final int locationLongitude;
  const LocationChanged({
    required this.locationName,
    // required this.locationLatitude,
    // required this.locationLongitude,
  });

  @override
  List<Object> get props => [
        locationName,
        // locationLatitude, locationLongitude
      ];
}

// final class StatusChanged extends EditJobEvent {
//   final bool isCancelled;
//   const StatusChanged({required this.isCancelled});

//   @override
//   List<Object> get props => [isCancelled];
// }

final class TechnicianSelected extends EditJobEvent {
  final UserModel technician;
  const TechnicianSelected({required this.technician});
  @override
  List<Object> get props => [technician];
}
