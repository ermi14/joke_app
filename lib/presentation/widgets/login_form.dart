import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joke_app/blocs/authentication/auth_bloc.dart';
import 'package:joke_app/blocs/login/login_bloc.dart';
import 'package:joke_app/data/repositories/user_repository.dart';
import 'package:joke_app/presentation/pages/signup_page.dart';

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;
  const LoginForm({Key key, UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChange);
    _passwordController.addListener(_onPasswordChange);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(listener: (context, state) {
      if (state.isFailure) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(
              duration: Duration(seconds: 2),
              backgroundColor: Colors.redAccent.shade100,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Logging Failed. Try Again.'),
                  Icon(
                    Icons.error,
                    color: Colors.white,
                  )
                ],
              )));
      }
      if (state.isSubmitting) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(
              backgroundColor: Colors.lightBlue.shade400,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Logging in . . .'),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                ],
              )));
      }
      if (state.isSuccess) {
        BlocProvider.of<AuthBloc>(context).add(
          AuthLoggedIn(),
        );
      }
    }, child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
              child: Column(children: <Widget>[
            _emailField(state),
            _passwordField(state),
            SizedBox(
              height: 50,
            ),
            _loginButton(state),
            SizedBox(
              height: 20,
            ),
            _signUpText(context),
          ])));
    }));
  }

  TextFormField _passwordField(LoginState state) {
    return TextFormField(
        controller: _passwordController,
        decoration: InputDecoration(
          icon: Icon(Icons.lock),
          labelText: "Password",
        ),
        obscureText: true,
        autovalidateMode: AutovalidateMode.always,
        autocorrect: false,
        validator: (_) {
          return !state.isPasswordValid ? 'Invalid Password' : null;
        });
  }

  TextFormField _emailField(LoginState state) {
    return TextFormField(
        controller: _emailController,
        decoration: InputDecoration(
          icon: Icon(Icons.email),
          labelText: "Email",
        ),
        keyboardType: TextInputType.emailAddress,
        autovalidateMode: AutovalidateMode.always,
        autocorrect: false,
        validator: (_) {
          return !state.isEmailValid ? 'Invalid Email' : null;
        });
  }

  GestureDetector _loginButton(LoginState state) {
    return GestureDetector(
      onTap: () {
        if (isButtonEnabled(state)) {
          _onFormSubmitted();
        }
      },
      child: Container(
          width: double.infinity,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.lightBlue.shade400,
              borderRadius: BorderRadius.circular(8)),
          child: Text(
            'Login',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          )),
    );
  }

  GestureDetector _signUpText(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return SignupPage(
            userRepository: widget._userRepository,
          );
        }));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Don\'t have an account?'),
          SizedBox(width: 10),
          Text(
            'Create an account',
            style: TextStyle(
              color: Colors.lightBlue.shade400,
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChange() {
    _loginBloc.add(LoginEmailChanged(email: _emailController.text));
  }

  void _onPasswordChange() {
    _loginBloc.add(LoginPasswordChanged(password: _passwordController.text));
  }

  void _onFormSubmitted() {
    _loginBloc.add(LoginWithCredentialsPressed(
        email: _emailController.text, password: _passwordController.text));
  }
}
