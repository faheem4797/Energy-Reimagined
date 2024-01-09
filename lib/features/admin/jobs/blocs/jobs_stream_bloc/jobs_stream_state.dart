part of 'jobs_stream_bloc.dart';

sealed class JobsStreamState extends Equatable {
  const JobsStreamState();
  
  @override
  List<Object> get props => [];
}

final class JobsStreamInitial extends JobsStreamState {}
