part of 'users_stream_bloc.dart';

enum UsersStreamStatus { loading, success, failure }

class UsersStreamState extends Equatable {
  final UsersStreamStatus status;
  final List<UserModel>? userStream;

  const UsersStreamState._({
    this.status = UsersStreamStatus.loading,
    this.userStream,
  });

  const UsersStreamState.loading() : this._();

  const UsersStreamState.success(List<UserModel> userStream)
      : this._(status: UsersStreamStatus.success, userStream: userStream);

  const UsersStreamState.failure() : this._(status: UsersStreamStatus.failure);

  @override
  List<Object?> get props => [status, userStream];
}
