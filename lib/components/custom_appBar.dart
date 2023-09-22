 import 'package:flutter/material.dart';

AppBar customAppBar({required String title, required dynamic context}) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      actions: [
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.black,
            )),
        IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.black)),
      ],
    );
  }

