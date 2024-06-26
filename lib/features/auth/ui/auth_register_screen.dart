import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:tweet/design/app_widgets.dart';
import 'package:tweet/features/auth/bloc/auth_bloc.dart';
import 'package:tweet/features/tweet/ui/tweets_page.dart';

class AuthRegisterScreeen extends StatefulWidget {
  const AuthRegisterScreeen({super.key});

  @override
  State<AuthRegisterScreeen> createState() => _AuthRegisterScreeenState();
}

class _AuthRegisterScreeenState extends State<AuthRegisterScreeen> {
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final formkey = Key('form');
  bool isLogin = true;

  AuthBloc authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true, leading: Container(), title: AppLogoWidget()),
      body: SingleChildScrollView(
        child: BlocConsumer<AuthBloc, AuthState>(
          bloc: authBloc,
          listenWhen: (previous, current) => current is AuthActionState,
          buildWhen: (previous, current) => current is! AuthActionState,
          listener: (context, state) {
            if (state is AuthErrorState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
            } else if (state is AuthLoadingState) {
              CircularProgressIndicator();
            } else if (state is AuthSuccessState) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => TweetsPage()),
                  (route) => false);
            }
          },
          builder: (context, state) {
            return Form(
              key: formkey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isLogin) const SizedBox(height: 32),
                    if (!isLogin) Text("Enter your First Name"),
                    if (!isLogin)
                      TextFormField(
                        controller: fnameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter your first Name";
                          } else {
                            return null;
                          }
                        },
                        decoration:
                            InputDecoration(hintText: "Your first Name"),
                      ),
                    if (!isLogin) const SizedBox(height: 32),
                    if (!isLogin) Text("Enter your Last Name"),
                    if (!isLogin)
                      TextFormField(
                        controller: lnameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter your last Name";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(hintText: "Your last Name"),
                      ),
                    const SizedBox(height: 32),
                    Text("Enter your Email"),
                    TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your Email";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(hintText: "Your Email"),
                    ),
                    const SizedBox(height: 32),
                    Text("Enter your Password"),
                    TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your Password";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(hintText: "Your Password"),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      height: 50,
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: () {
                          authBloc.add(AuthenticationEvent(
                              authType:
                                  isLogin ? AuthType.login : AuthType.register,
                              email: emailController.text,
                              password: passwordController.text,
                              firstname: fnameController.text,
                              lastname: lnameController.text));
                        },
                        child: Text(isLogin ? "Login" : "Register"),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(isLogin
                            ? "Dont have an account?"
                            : "Already have an Account?"),
                        InkWell(
                          onTap: () {
                            setState(() {
                              isLogin = !isLogin;
                            });
                          },
                          child: Text(
                            !isLogin ? "Login" : "Register",
                            style: TextStyle(color: Colors.deepPurple.shade200),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Center(
                      child: Container(
                        width: double.maxFinite,
                        child: SignInButton(
                          Buttons.Google,
                          padding: EdgeInsets.all(8),
                          onPressed: () {
                            authBloc.add(AuthenticationEvent(
                                authType: AuthType.google,
                                email: '',
                                password: '',
                                firstname: '',
                                lastname: ''));
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
