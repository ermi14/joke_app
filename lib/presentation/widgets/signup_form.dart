import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joke_app/blocs/authentication/auth_bloc.dart';
import 'package:joke_app/blocs/signup/signup_bloc.dart';

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool get isPopulated =>
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _confirmPasswordController.text.isNotEmpty;

  bool isButtonEnabled(SignupState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  SignupBloc _signupBloc;

  @override
  void initState() {
    super.initState();
    _signupBloc = BlocProvider.of<SignupBloc>(context);
    _emailController.addListener(_onEmailChange);
    _passwordController.addListener(_onPasswordChange);
    _confirmPasswordController.addListener(_onConfirmPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(listener: (context, state) {
      if (state.isFailure) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(
              duration: Duration(seconds: 2),
              backgroundColor: Colors.redAccent.shade100,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Sign up Failed. Try Again.'),
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
                  Text('Signing up . . .'),
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
        Navigator.pop(context);
      }
    }, child: BlocBuilder<SignupBloc, SignupState>(builder: (context, state) {
      return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
              child: Column(children: <Widget>[
            _emailField(state),
            _passwordField(state),
            _confirmPasswordField(state),
            SizedBox(
              height: 50,
            ),
            _signUpButton(state),
          ])));
    }));
  }

  TextFormField _emailField(SignupState state) {
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
      },
    );
  }

  TextFormField _passwordField(SignupState state) {
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
      },
    );
  }

  TextFormField _confirmPasswordField(SignupState state) {
    return TextFormField(
        controller: _confirmPasswordController,
        decoration: InputDecoration(
          icon: Icon(Icons.lock_outline),
          labelText: "Confirm Password",
        ),
        obscureText: true,
        autovalidateMode: AutovalidateMode.always,
        autocorrect: false,
        validator: (_) {
          return !state.isConfirmPasswordValid
              ? 'Password does not match'
              : null;
        });
  }

  GestureDetector _signUpButton(SignupState state) {
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
            'Sign Up',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          )),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onEmailChange() {
    _signupBloc.add(SignupEmailChanged(email: _emailController.text));
  }

  void _onPasswordChange() {
    _signupBloc.add(SignupPasswordChanged(password: _passwordController.text));
  }

  void _onConfirmPasswordChanged() {
    _signupBloc.add(SignupConfirmPasswordChanged(
        confirmpassword: _confirmPasswordController.text,
        password: _passwordController.text));
  }

  void _onFormSubmitted() {
    _signupBloc.add(SignupSubmitted(
        email: _emailController.text, password: _passwordController.text));
  }
}
