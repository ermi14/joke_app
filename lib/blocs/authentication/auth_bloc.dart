import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:joke_app/data/repositories/user_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository _userRepository;
  AuthBloc({UserRepository userRepository})
      : _userRepository = userRepository,
        super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthStarted) {
      yield* _mapAuthStartedToState();
    } else if (event is AuthLoggedIn) {
      yield* _mapAuthLoggedInToState();
    } else if (event is AuthLoggedOut) {
      yield* _mapAuthLoggedOutInToState();
    }
  }

  // AuthLoggedOut
  Stream<AuthState> _mapAuthLoggedOutInToState() async* {
    yield AuthFailure();
    _userRepository.signOut();
  }

  // AuthLoggedIn
  Stream<AuthState> _mapAuthLoggedInToState() async* {
    yield AuthSuccess(await _userRepository.getUser());
  }

  // AuthStarted
  Stream<AuthState> _mapAuthStartedToState() async* {
    final isSignedIn = await _userRepository.isSignedIn();
    if (isSignedIn) {
      final user = await _userRepository.getUser();
      yield AuthSuccess(user);
    } else {
      yield AuthFailure();
    }
  }
}
