part of 'add_work_description_bloc.dart';

enum AddWorkDescriptionStatus { initial, inProgress, success, failure }

final class AddWorkDescriptionState extends Equatable {
  const AddWorkDescriptionState({
    this.status = AddWorkDescriptionStatus.initial,
    this.errorMessage,
  });

  final AddWorkDescriptionStatus status;
  final String? errorMessage;

  AddWorkDescriptionState copyWith({
    AddWorkDescriptionStatus? status,
    String? errorMessage,
  }) {
    return AddWorkDescriptionState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
