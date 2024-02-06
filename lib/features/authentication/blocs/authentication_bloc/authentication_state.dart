part of 'authentication_bloc.dart';

enum AuthenticationStatus {
  technicianAuthenticated,
  adminAuthenticated,
  managerAuthenticated,
  unauthenticated,
  unknown
}

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.user,
    this.userModel,
    this.errorMessage,
  });
  final AuthenticationStatus status;
  final User? user;
  final UserModel? userModel;
  final String? errorMessage;

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.technicianAuthenticated(
      User user, UserModel userModel)
      : this._(
            status: AuthenticationStatus.technicianAuthenticated,
            user: user,
            userModel: userModel);
  const AuthenticationState.adminAuthenticated(User user, UserModel userModel)
      : this._(
            status: AuthenticationStatus.adminAuthenticated,
            user: user,
            userModel: userModel);
  const AuthenticationState.managerAuthenticated(User user, UserModel userModel)
      : this._(
            status: AuthenticationStatus.managerAuthenticated,
            user: user,
            userModel: userModel);

  const AuthenticationState.unauthenticated(String? errorMessage)
      : this._(
          status: AuthenticationStatus.unauthenticated,
          errorMessage: errorMessage,
        );

  @override
  List<Object?> get props => [status, user, userModel, errorMessage];
}
