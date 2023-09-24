import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/cubit/social_media_ui_cubit.dart';

import '../cubit/social_media_ui_state.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';

class ChatDetailsScreen extends StatelessWidget {
  ChatDetailsScreen({super.key, required this.model});
  final UserModel? model;
  final TextEditingController messageController = TextEditingController();
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      AppCubit.get(context).getMessages(receiverId: model!.uId);
      return BlocConsumer<AppCubit, SocialMediaUiState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          List<MessageModel> messages = AppCubit.get(context).messages;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.black,
                  )),
              titleSpacing: 0,
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(model?.image ??
                        'https://img.freepik.com/free-photo/cute-cat-laying-grass_23-2150385852.jpg?size=626&ext=jpg'),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    model?.name ?? 'someone',
                    style: Theme.of(context).textTheme.titleLarge,
                  )
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 10,
              ),
              child: Column(
                children: [
                  messages.isNotEmpty
                      ? Expanded(
                          child: ListView.separated(
                            controller: controller,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              MessageModel message =
                                  AppCubit.get(context).messages[index];

                              return AppCubit.get(context).model!.uId ==
                                      message.senderId
                                  ? MyMessage(message: message)
                                  : ReceiverMessage(message: message);
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 15,
                              );
                            },
                            itemCount: messages.length,
                          ),
                        )
                      : Center(child: CircularProgressIndicator()),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.withOpacity(.3),
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: messageController,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 8),
                              border: InputBorder.none,
                              hintText: 'Type your message here......',
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(color: Colors.blue[300]),
                          child: IconButton(
                              onPressed: () {
                                if (messageController.text.isNotEmpty) {
                                  AppCubit.get(context).sendMessage(
                                    receiverID: model!.uId,
                                    dateTime: DateTime.now().toString(),
                                    text: messageController.text,
                                  );
                                  controller.animateTo(
                                    controller.position.maxScrollExtent,
                                    duration: Duration(seconds: 1),
                                    curve: Curves.fastOutSlowIn,
                                  );
                                }
                                messageController.text = '';
                              },
                              icon: Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}

class MyMessage extends StatelessWidget {
  const MyMessage({
    super.key,
    required this.message,
  });
  final MessageModel message;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.blue[300],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              )),
          child: Text(message.text!)),
    );
  }
}

class ReceiverMessage extends StatelessWidget {
  const ReceiverMessage({
    super.key,
    required this.message,
  });
  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10),
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              )),
          child: Text(message.text!)),
    );
  }
}
