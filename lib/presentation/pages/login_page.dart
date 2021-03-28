import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joke_app/blocs/login/login_bloc.dart';
import 'package:joke_app/data/repositories/user_repository.dart';
import 'package:joke_app/presentation/widgets/curved_widget.dart';
import 'package:joke_app/presentation/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  final UserRepository _userRepository;
  const LoginPage({Key key, UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        brightness: Brightness.dark,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(userRepository: _userRepository),
        child: Container(
          height: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                CurvedWidget(
                  child: Container(
                    padding: const EdgeInsets.only(top: 100, left: 30),
                    color: Colors.lightBlue.shade300,
                    width: double.infinity,
                    height: 300,
                    child: Text(
                      'Welcome',
                      style: TextStyle(color: Colors.white, fontSize: 34),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 40, horizontal: 10),
                  margin: const EdgeInsets.only(top: 230),
                  child: LoginForm(userRepository: _userRepository),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
