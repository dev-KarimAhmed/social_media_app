import 'package:flutter/material.dart';

import '../cubit/social_media_ui_cubit.dart';
import '../models/post_model.dart';
import 'custom_sperator.dart';

class PostItem extends StatelessWidget {
  const PostItem({
    super.key,
    required this.model,
    required this.index,
  });
  final PostModel model;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(8),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://img.freepik.com/free-vector/illustration-businessman_53876-5856.jpg?size=626&ext=jpg'),
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
                          Text(model.name!),
                          SizedBox(width: 5),
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      Text(
                        model.dateTime!,
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    ],
                  )),
                  IconButton(
                      onPressed: () {
                        AppCubit.get(context).deletePost(
                            postId: AppCubit.get(context).postsID[index]);
                      },
                      icon: Icon(Icons.delete_rounded))
                ],
              ),
            ),
            CustomSperator(),
            Row(
              children: [
                Text(
                  model.postText ?? '',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            if (model.postImage != '') ...[
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(model.postImage!),
                      )),
                ),
              ),
            ],
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_circle_up,
                          color: Colors.green,
                          size: 18,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${AppCubit.get(context).likes[index]}',
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.message,
                          color: Colors.amber,
                          size: 18,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '0 comment',
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[300],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              AppCubit.get(context).model?.image ?? ''),
                          radius: 15,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'write a comment...',
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        AppCubit.get(context)
                            .likePost(AppCubit.get(context).postsID[index]);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.arrow_circle_up,
                            color: Colors.green,
                            size: 22,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'UP',
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
