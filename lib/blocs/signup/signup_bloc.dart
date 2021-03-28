import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:joke_app/app/validators.dart';
import 'package:joke_app/data/repositories/user_repository.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final UserRepository _userRepository;

  SignupBloc({UserRepository userRepository})
      : _userRepository = userRepository,
        super(SignupState.initial());

  @override
  Stream<SignupState> mapEventToState(SignupEvent event) async* {
    if (event is SignupEmailChanged) {
      yield* _mapSignupEmailChangeToState(event.email);
    } else if (event is SignupPasswordChanged) {
      yield* _mapSignupPasswordChangeToState(event.password);
    } else if (event is SignupConfirmPasswordChanged) {
      yield* _mapSignupConfirmPasswordChangedToState(
          event.password, event.confirmpassword);
    } else if (event is SignupSubmitted) {
      yield* _mapSignupSubmittedToState(
          email: event.email, password: event.password);
    }
  }

  Stream<SignupState> _mapSignupEmailChangeToState(String email) async* {
    yield state.update(isEmailValid: Validators.isValidEmail(email));
  }

  Stream<SignupState> _mapSignupPasswordChangeToState(String password) async* {
    yield state.update(isPasswordValid: Validators.isValidPassword(password));
  }

  Stream<SignupState> _mapSignupConfirmPasswordChangedToState(
      String password, String confirmPassword) async* {
    yield state.update(
        isConfirmPasswordValid: password.compareTo(confirmPassword) == 0);
  }

  Stream<SignupState> _mapSignupSubmittedToState(
      {String email, String password}) async* {
    yield SignupState.loading();
    try {
      await _userRepository.signUp(email, password);
      yield SignupState.success();
    } catch (error) {
      print(error);
      yield SignupState.failure();
    }
  }
}
