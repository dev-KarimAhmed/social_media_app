import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/social_media_ui_cubit.dart';
import '../cubit/social_media_ui_state.dart';
import '../widgets/custom_text_field.dart';
import 'home_view.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController phone = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, SocialMediaUiState>(
      listener: (context, state) {
        if (state is CreateUserSuccess) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeView()));
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
                      'REGISTER',
                      style: TextStyle(
                        fontSize: 26,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Register Now to find more friends',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      hintText: 'User Name',
                      prefixIcon: Icon(Icons.person),
                      controller: name,
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
                    CustomTextField(
                      hintText: 'Phone',
                      prefixIcon: Icon(Icons.phone),
                      keyboardType: TextInputType.phone,
                      controller: phone,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => HomeView()));
                          AppCubit.get(context).userRegister(
                              name: name.text,
                              email: email.text,
                              password: password.text,
                              phone: phone.text);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.blue,
                        ),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                      ),
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
