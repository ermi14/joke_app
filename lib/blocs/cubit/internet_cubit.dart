import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final Connectivity connectivity;
  StreamSubscription connectivityStreamSubscription;

  InternetCubit({@required this.connectivity}) : super(InternetLoading()) {
    monitorInternetCubit();
  }

  StreamSubscription<ConnectivityResult> monitorInternetCubit() {
    return connectivityStreamSubscription =
      connectivity.onConnectivityChanged.listen((connectivityResult) {
    if (connectivityResult == ConnectivityResult.wifi) {
      emitInternetConnected();
    } else if (connectivityResult == ConnectivityResult.mobile) {
      emitInternetConnected();
    } else {
      emitInternetDisconnected();
    }
  });
  }

  void emitInternetConnected() =>
      emit(InternetConnected());

  void emitInternetDisconnected() => emit(InternetDisconnected());

  @override
  Future<void> close() {
    connectivityStreamSubscription.cancel();
    return super.close();
  }
}

