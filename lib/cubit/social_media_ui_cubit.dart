import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/cubit/social_media_ui_state.dart';

import '../constants/constant.dart';
import '../models/user_model.dart';
import '../views/chat.dart';
import '../views/new_feeds.dart';
import '../views/new_post_view.dart';
import '../views/search.dart';
import '../views/settings.dart';

class AppCubit extends Cubit<SocialMediaUiState> {
  AppCubit() : super(SocialMediaUiInitial());
  static AppCubit get(context) => BlocProvider.of(context);
  bool isHidden = true;
   UserModel? model;

  void hidePassword() {
    isHidden = !isHidden;
    emit(PasswordHideen());
  }

  void userRegister(
      {
      required String name,
      required String email,
      required String password,
      required String phone
      }) async {
    emit(LoadingState());
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(credential.user);
      createUser(
          name: name,
          email: email,
          phone: phone,
          uId: credential.user!.uid,
          isEmailVerified: false);
      emit(SuccessState(credential.user!.uid));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
      emit(FailureState());
    }
  }

  void userLogin({required String email, required String password}) async {
    emit(LoadingState());
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      emit(SuccessState(credential.user!.uid));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else {
        emit(FailureState());
      }
    }
  }

  void createUser(
      {
        required String name,
      required String email,
      required String phone,
      required String uId,
      required bool isEmailVerified}) {
    UserModel userModel = UserModel(
        name: name,
        email: email,
        phone: phone,
        uId: uId,
        isEmailVerified: isEmailVerified,
        bio: 'write your bio...',
        cover: 'https://img.freepik.com/free-photo/courage-man-jump-through-gap-hill-business-concept-idea_1323-262.jpg?size=626&ext=jpg',
        image: 'https://img.freepik.com/free-vector/illustration-businessman_53876-5856.jpg?size=626&ext=jpg'
        );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(userModel.toMap())
        .then((value) {
      emit(CreateUserSuccess());
    }).catchError((error) {
      emit(CreateUserFailure(error.toString()));
    });
  }

  void getUserData() {
    emit(GetDataLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      print('Your data is ${value.data()}');
      model = UserModel.fromJson(value.data());
      emit(GetDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetDataFailureState(error.toString()));
    });
  }

  int currentIndex = 0;

  List<Widget> screens = [
    NewsFeedView(),
    ChatView(),
    NewPostScreen(),
    SearchView(),
    SettingsView()
  ];
  List<String> title = ['Home', 'Chat', 'Add Post' ,  'Search', 'Settings'];

  void changeBottomNav(int index) {
    if (index == 2) {
      emit(NewPost());
    } else {
    currentIndex = index;
    emit(ChangeNavBottom());
    }
  }
}
