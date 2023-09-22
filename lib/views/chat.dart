import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/cubit/social_media_ui_cubit.dart';

import '../components/custom_sperator.dart';
import '../cubit/social_media_ui_state.dart';
import '../models/user_model.dart';
import 'chat_view_details.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, SocialMediaUiState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          body: AppCubit.get(context).allUsers.length > 0
              ? ListView.separated(
                  itemBuilder: (context, index) {
                    return ChatItem(
                      model: AppCubit.get(context).allUsers[index],
                    );
                  },
                  separatorBuilder: (context, index) => const CustomSperator(),
                  itemCount: AppCubit.get(context).allUsers.length)
              : Center(
                  child: CircularProgressIndicator(),
                ),
        );
      },
    );
  }
}

class ChatItem extends StatelessWidget {
  const ChatItem({
    super.key,
    required this.model,
  });
  final UserModel model;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ChatDetailsScreen(model: model,)));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(model.image),
              radius: 25,
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(model.name),
                    SizedBox(width: 5),
                  ],
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
