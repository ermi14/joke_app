part of 'signup_bloc.dart';

class SignupState extends Equatable {
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isConfirmPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  SignupState( 
      {this.isEmailValid,
      this.isPasswordValid,
      this.isConfirmPasswordValid,
      this.isSubmitting,
      this.isSuccess,
      this.isFailure});

  bool get isFormValid => isEmailValid && isPasswordValid;

  @override
  List<Object> get props => [
        isEmailValid,
        isPasswordValid,
        isConfirmPasswordValid,
        isSubmitting,
        isSuccess,
        isFailure
      ];

  factory SignupState.initial() {
    return SignupState(
      isEmailValid: true,
      isPasswordValid: true,
      isConfirmPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory SignupState.loading() {
    return SignupState(
      isEmailValid: true,
      isPasswordValid: true,
      isConfirmPasswordValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory SignupState.failure() {
    return SignupState(
      isEmailValid: true,
      isPasswordValid: true,
      isConfirmPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  factory SignupState.success() {
    return SignupState(
      isEmailValid: true,
      isPasswordValid: true,
      isConfirmPasswordValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  SignupState update({
    bool isEmailValid,
    bool isPasswordValid,
    bool isConfirmPasswordValid,
  }) {
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isConfirmPasswordValid: isConfirmPasswordValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  SignupState copyWith({
    bool isEmailValid,
    bool isPasswordValid,
    bool isConfirmPasswordValid,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return SignupState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isConfirmPasswordValid:
          isConfirmPasswordValid ?? this.isConfirmPasswordValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }
}

class SignupInitial extends SignupState {}
