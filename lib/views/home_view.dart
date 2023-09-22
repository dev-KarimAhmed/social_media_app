import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_media_app/cubit/social_media_ui_cubit.dart';

import '../components/custom_appBar.dart';
import '../cubit/social_media_ui_state.dart';
import 'new_post_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, SocialMediaUiState>(
      listener: (context, state) {
        if (state is NewPost) {
          //when click to post 
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => NewPostScreen()));
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          appBar: customAppBar(
              title: cubit.title[cubit.currentIndex], context: context),
          body: cubit.screens[cubit.currentIndex],
          //Navigation bar 
          bottomNavigationBar: BottomNavigationBar(
              fixedColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeBottomNav(index);
              },
              items: const[
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.message), label: 'Chat'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.upload_file), label: 'Post'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Users'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), label: 'Settings'),
              ]),
        );
      },
    );
  }
}
