import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/cubit/social_media_ui_cubit.dart';

import '../cubit/social_media_ui_state.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, SocialMediaUiState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('News Feed'),
          ),
          body: ConditionalBuilder(
            condition: AppCubit.get(context).model != null,
            builder: (context) {
              var model = AppCubit.get(context).model;
              return Column(
                children: [
                  if (!FirebaseAuth.instance.currentUser!.emailVerified)
                    Container(
                      color: Colors.amber.withOpacity(0.3),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Icon(Icons.info),
                          SizedBox(width: 15),
                          Expanded(child: Text('Please verify your email')),
                          TextButton(
                            onPressed: () {
                              FirebaseAuth.instance.currentUser!
                                  .sendEmailVerification()
                                  .then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('please check your mail')));
                              });
                            },
                            child: Text('Send'),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
            fallback: (context) => Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}
