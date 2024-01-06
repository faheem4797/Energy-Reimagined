part of 'users_stream_bloc.dart';

sealed class UsersStreamEvent extends Equatable {
  const UsersStreamEvent();

  @override
  List<Object> get props => [];
}

final class GetUserStream extends UsersStreamEvent {
  final List<UserModel> userStream;

  const GetUserStream({required this.userStream});

  @override
  List<Object> get props => [userStream];
}
