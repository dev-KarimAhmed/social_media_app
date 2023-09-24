import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/cubit/social_media_ui_cubit.dart';

import '../components/custom_sperator.dart';
import '../components/post_item.dart';
import '../cubit/social_media_ui_state.dart';
import '../models/post_model.dart';

class NewsFeedView extends StatelessWidget {
  const NewsFeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, SocialMediaUiState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        print(AppCubit.get(context).posts.length);
        return Scaffold(
          body: ListView(
            children: [
              Card(
                elevation: 10,
                margin: EdgeInsets.all(8),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Image(
                      width: double.infinity,
                      image: NetworkImage(
                          'https://img.freepik.com/free-photo/cheerful-young-men-plaid-blue-shirts-white-t-shirts-colorful-pants-pose-orange-wall-great-mood-smile_197531-23466.jpg?size=626&ext=jpg'),
                      fit: BoxFit.cover,
                      height: 200,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Communicate with friends',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
              AppCubit.get(context).posts.isNotEmpty
                  ? ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => PostItem(
                          model: AppCubit.get(context).posts[index],
                          index: index),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10),
                      itemCount: AppCubit.get(context).posts.length,
                      )
                  : Center(
                      child: CircularProgressIndicator(),
                    )
            ],
          ),
        );
      },
    );
  }
}

