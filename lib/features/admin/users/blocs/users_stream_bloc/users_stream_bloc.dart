import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_data_repository/user_data_repository.dart';

part 'users_stream_event.dart';
part 'users_stream_state.dart';

class UsersStreamBloc extends Bloc<UsersStreamEvent, UsersStreamState> {
  final UserDataRepository _userDataRepository;
  late final StreamSubscription<List<UserModel>?> _userSubscription;
  UsersStreamBloc({required UserDataRepository userDataRepository})
      : _userDataRepository = userDataRepository,
        super(const UsersStreamState.loading()) {
    _userSubscription = _userDataRepository.getUsersStream.listen((userData) {
      add(GetUserStream(userStream: userData));
    });
    on<GetUserStream>(_getUserStream);
  }

  FutureOr<void> _getUserStream(
      GetUserStream event, Emitter<UsersStreamState> emit) async {
    try {
      emit(UsersStreamState.success(event.userStream));
    } catch (e) {
      log(e.toString());
      emit(const UsersStreamState.failure());
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
