import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_app/views/register_view.dart';

import '../cubit/social_media_ui_cubit.dart';
import '../cubit/social_media_ui_state.dart';
import '../widgets/custom_text_field.dart';
import 'home_view.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, SocialMediaUiState>(
      listener: (context, state) async {
        if (state is SuccessState) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          
          prefs.setString('uId', state.uId).then((value) => Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeView())));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 180,
                    ),
                    Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 26,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Login Now to find more friends',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      hintText: 'Email Address',
                      prefixIcon: Icon(Icons.email),
                      keyboardType: TextInputType.emailAddress,
                      controller: email,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      controller: password,
                      suffixIcon: IconButton(
                        onPressed: () {
                          AppCubit.get(context).hidePassword();
                        },
                        icon: AppCubit.get(context).isHidden
                            ? Icon(Icons.remove_red_eye)
                            : Icon(Icons.visibility_off),
                      ),
                      obscureText: AppCubit.get(context).isHidden,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          AppCubit.get(context).userLogin(
                              email: email.text, password: password.text);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.blue,
                        ),
                        child: state is LoadingState
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style: TextStyle(fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterView()));
                          },
                          child: Text(
                            'Register',
                            style: TextStyle(fontSize: 16, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )),
        );
      },
    );
  }
}
