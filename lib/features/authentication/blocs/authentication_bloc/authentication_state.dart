part of 'authentication_bloc.dart';

enum AuthenticationStatus {
  authenticated,
  adminauthenticated,
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

  const AuthenticationState.authenticated(
      User user, UserModel userModel, String? errorMessage)
      : this._(
            status: AuthenticationStatus.authenticated,
            user: user,
            userModel: userModel,
            errorMessage: errorMessage);
  const AuthenticationState.adminauthenticated(User user)
      : this._(status: AuthenticationStatus.adminauthenticated, user: user);

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  @override
  List<Object?> get props => [status, user, userModel, errorMessage];
}
