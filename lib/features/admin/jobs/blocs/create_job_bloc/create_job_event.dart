part of 'create_job_bloc.dart';

sealed class CreateJobEvent extends Equatable {
  const CreateJobEvent();

  @override
  List<Object> get props => [];
}

final class CreateJobWithDataModel extends CreateJobEvent {}

final class TitleChanged extends CreateJobEvent {
  final String title;
  const TitleChanged({required this.title});

  @override
  List<Object> get props => [title];
}

final class DescriptionChanged extends CreateJobEvent {
  final String description;
  const DescriptionChanged({required this.description});

  @override
  List<Object> get props => [description];
}

final class LocationChanged extends CreateJobEvent {
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