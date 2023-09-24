import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_app/views/home_view.dart';
import 'package:social_media_app/views/login_view.dart';

import 'constants/constant.dart';
import 'cubit/social_media_ui_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  uId = prefs.get('uId');
  var token = await FirebaseMessaging.instance.getAPNSToken();
  print(token);

  FirebaseMessaging.onMessage.listen((event) {
    print(event.data.toString());
  });

  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print(event.data.toString());
  });
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<AppCubit>(create: (context) => AppCubit()),
      BlocProvider<AppCubit>(
          create: (context) => AppCubit()
            ..getUserData()
            ..getPosts()),
    ],
    child: uId == null
        ? SocialMediaApp()
        : MaterialApp(debugShowCheckedModeBanner: false, home: HomeView()),
  ));
}

class SocialMediaApp extends StatelessWidget {
  const SocialMediaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Social media',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginView(),
    );
  }
}
