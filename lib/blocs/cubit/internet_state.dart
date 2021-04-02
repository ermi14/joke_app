part of 'internet_cubit.dart';

abstract class InternetState {}

class InternetLoading extends InternetState {}

class InternetConnected extends InternetState {
  InternetConnected();
}

class InternetDisconnected extends InternetState {}
