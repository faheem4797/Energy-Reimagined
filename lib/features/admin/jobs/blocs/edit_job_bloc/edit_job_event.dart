part of 'edit_job_bloc.dart';

sealed class EditJobEvent extends Equatable {
  const EditJobEvent();

  @override
  List<Object> get props => [];
}

final class EditJobWithUpdatedToolModel extends EditJobEvent {}

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

final class LocationChanged extends EditJobEvent {
  final String locationName;
  final int locationLatitude;
  final int locationLongitude;
  const LocationChanged({
    required this.locationName,
    required this.locationLatitude,
    required this.locationLongitude,
  });

  @override
  List<Object> get props => [locationName, locationLatitude, locationLongitude];
}