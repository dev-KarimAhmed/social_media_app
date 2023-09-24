import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/cubit/social_media_ui_state.dart';

import '../constants/constant.dart';
import '../models/message_model.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../views/chat.dart';
import '../views/new_feeds.dart';
import '../views/new_post_view.dart';
import '../views/search.dart';
import '../views/settings.dart';

class AppCubit extends Cubit<SocialMediaUiState> {
  AppCubit() : super(SocialMediaUiInitial());
  static AppCubit get(context) => BlocProvider.of(context);
  UserModel? model;

  // Function to hide password in the textField
  bool isHidden = true;
  void hidePassword() {
    isHidden = !isHidden;
    emit(PasswordHideen());
  }

  //Function to register the user for the first time when use application
  void userRegister(
      {required String name,
      required String email,
      required String password,
      required String phone}) async {
    emit(LoadingState());
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      createUser(
        name: name,
        email: email,
        phone: phone,
        uId: credential.user!.uid,
        isEmailVerified: false,
      );
      emit(SuccessState(credential.user!.uid));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        const ScaffoldMessenger(
            child: SnackBar(content: Text('sorry , The password is so week!')));
      } else if (e.code == 'email-already-in-use') {
        const ScaffoldMessenger(
            child: SnackBar(
                content: Text(
                    'sorry , The account already exists for that email.')));
      }
    } catch (e) {
      print(e);
      emit(FailureState());
    }
  }

  //Function to Login in
  void userLogin({required String email, required String password}) async {
    emit(LoadingState());
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      emit(SuccessState(credential.user!.uid));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        const ScaffoldMessenger(
            child: SnackBar(
                content: Text('sorry ,No user found for that email.')));
      } else if (e.code == 'wrong-password') {
        const ScaffoldMessenger(
            child: SnackBar(
                content:
                    Text('sorry ,Wrong password provided for that user.')));
      } else {
        emit(FailureState());
      }
    }
  }

  //Function to create a user and / === intialize the model === /
  void createUser({
    required String name,
    required String email,
    required String phone,
    required String uId,
    required bool isEmailVerified,
  }) {
    //=== intialize the model ===
    UserModel userModel = UserModel(
        name: name,
        email: email,
        phone: phone,
        uId: uId,
        isEmailVerified: isEmailVerified,
        bio: 'write your bio...',
        cover:
            'https://img.freepik.com/free-photo/courage-man-jump-through-gap-hill-business-concept-idea_1323-262.jpg?size=626&ext=jpg',
        image:
            'https://img.freepik.com/free-vector/illustration-businessman_53876-5856.jpg?size=626&ext=jpg');
    // Set the data for the first time in the fireStroe in firebase
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId) // The id for the user (in your model)
        .set(userModel
            .toMap()) // set the function toMap()  (in your model) return Map<String, dynamic>
        .then((value) {
      emit(CreateUserSuccess());
    }).catchError((error) {
      emit(CreateUserFailure(error.toString()));
    });
  }

  // Function to get the data of the user to show UX different according each user
  // you should call it firstly in main with its cubit provider
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

  // variables for the navigationBar
  int currentIndex = 0;
  List<Widget> screens = [
    NewsFeedView(),
    ChatView(),
    NewPostScreen(),
    SearchView(),
    SettingsView()
  ];
  List<String> title = ['Home', 'Chat', 'Add Post', 'Search', 'Settings'];

  // function to change screens in navigationBar
  void changeBottomNav(int index) {
    if (index == 1) {
      getAllUsers();
    }

    if (index == 2) {
      emit(NewPost());
    } else {
      currentIndex = index;
      emit(ChangeNavBottom());
    }
  }

  // Function to pick an image from your gallery for profile (imagePicker package)
  File? profileImage;
  Future pickedImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage != null) {
      profileImage = File(returnImage.path);
    } else {
      return;
    }
    emit(ProfileImagePickedSuccess());
  }

  // Function to pick an image from your gallery for profile (imagePicker package)
  File? coverImage;
  Future pickedImageCoverFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnImage != null) {
      coverImage = File(returnImage.path);
    } else {
      return;
    }

    emit(CoverImagePickedSuccess());
  }

  // Fucntion to upload the profile image in the storage of Firebase
  // we call updateUserData() , because After we upload the image we use it to update user Data
  final storage = FirebaseStorage.instance;
  void uploadProfileImage({
    required String name,
    required String bio,
    required String phone,
  }) {
    emit(UpdateDataLoading());
    storage
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((p0) {
      p0.ref.getDownloadURL().then((value) {
        updateUserData(
          name: name,
          bio: bio,
          phone: phone,
          image: value,
        );
        //  emit(ProfileImageSuccessUpload());
      }).catchError((error) {
        emit(ProfileImageErrorUpload());
      });
    }).catchError((error) {
      emit(ProfileImageErrorUpload());
    });
  }

  // Fucntion to upload the cover image in the storage of Firebase
  void uploadCoverImage({
    required String name,
    required String bio,
    required String phone,
  }) {
    emit(UpdateDataLoading());
    storage
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((p0) {
      p0.ref.getDownloadURL().then((value) {
        updateUserData(
          name: name,
          bio: bio,
          phone: phone,
          cover: value,
        );
        //emit(CoverImageSuccessUpload());
      }).catchError((error) {
        emit(CoverImageErrorUpload());
      });
    }).catchError((error) {
      emit(CoverImageErrorUpload());
    });
  }

  // void updateUserImages(
  //     {required String name, required String bio, required String phone}) {
  //   emit(UpdateDataLoading());
  //   if (profileImage != null) {
  //     uploadProfileImage();
  //   } else if (profileImage != null) {
  //     uploadCoverImage();
  //   } else if (profileImage != null && profileImage != null) {
  //   } else {
  //     updateUserData(name: name, bio: bio, phone: phone);
  //   }
  // }

  // we use this function to update all user Data
  void updateUserData({
    required String name,
    required String bio,
    required String phone,
    String? image,
    String? cover,
  }) {
    UserModel userModel = UserModel(
      name: name,
      phone: phone,
      uId: uId,
      isEmailVerified: false,
      bio: bio,
      cover: cover ?? model!.cover,
      email: model!.email,
      image: image ?? model!.image,
    );
    emit(UpdateDataSuccess());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .update(userModel.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(UpdateDataError());
    });
  }

  File? postImage;
  Future pickedPostImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnImage != null) {
      postImage = File(returnImage.path);
    } else {
      return;
    }

    emit(PostImagePickedSuccess());
  }

  void removePostImage() {
    postImage = null;
    emit(PostImagePickedRemoveSuccess());
  }

  void uploadPostImage({
    required String dateTime,
    required String postText,
  }) {
    emit(PostCreateLoading());
    storage
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((p0) {
      p0.ref.getDownloadURL().then((value) {
        createNewPost(
          dateTime: dateTime,
          postText: postText,
          postImage: value,
        );
        //  emit(ProfileImageSuccessUpload());
      }).catchError((error) {
        emit(PostCreateError());
      });
    }).catchError((error) {
      emit(PostCreateError());
    });
  }

  void createNewPost({
    required String dateTime,
    required String postText,
    String? postImage,
  }) {
    emit(PostCreateLoading());
    PostModel postModel = PostModel(
      name: model!.name,
      dateTime: dateTime,
      uId: model!.uId,
      postText: postText,
      profileImage: model!.image,
      postImage: postImage ?? '',
    );
    // emit(PostCreateSuccess());
    FirebaseFirestore.instance
        .collection('posts')
        .add(postModel.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(PostCreateError());
    });
  }

  List<PostModel> posts = [];
  List<String> postsID = [];
  List<int> likes = [];
  Future<void> getPosts() async {
    try {
      final postsCollection = FirebaseFirestore.instance.collection('posts');
      final postsQuery = await postsCollection.get();

      for (var element in postsQuery.docs) {
        final likesQuery = await element.reference.collection('likes').get();
        likes.add(likesQuery.docs.length);
        postsID.add(element.id);
        posts.add(PostModel.fromJson(element.data()));
      }
      emit(GetPostsSuccess());
    } catch (error) {
      emit(GetPostsError(error.toString()));
    }
  }

  List<UserModel> allUsers = [];
  Future<void> getAllUsers() async {
    if (allUsers.isEmpty) {
      try {
        final usersCollection = FirebaseFirestore.instance.collection('users');
        final usersQuery = await usersCollection.get();

        for (var element in usersQuery.docs) {
          // allUsers.add(UserModel.fromJson(element.data()));
          if (element.data()['uId'] != model?.uId) {
            allUsers.add(UserModel.fromJson(element.data()));
          }
        }
        emit(GetUsersSuccess());
      } catch (error) {
        emit(GetUsersError(error.toString()));
      }
    }
  }

  // void getPosts() {
  //   FirebaseFirestore.instance.collection('posts').get().then((value) {
  //     for (var element in value.docs) {
  //       element.reference.collection('likes').get().then((value) {
  //         likes.add(value.docs.length);
  //         postsID.add(element.id);
  //         posts.add(PostModel.fromJson(element.data()));
  //       }).catchError((error) {});
  //     }
  //     emit(GetPostsSuccess());
  //   }).catchError((error) {
  //     emit(GetPostsError(error.toString()));
  //   });
  // }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(model!.uId)
        .set({'like': true}).then((value) {
      emit(LikeSuccess());
    }).catchError((error) {
      emit(LikeError());
    });
  }

  void sendMessage({
    required String receiverID,
    required String dateTime,
    required String text,
  }) {
    MessageModel messageModel = MessageModel(
      senderId: model!.uId,
      receiverID: receiverID,
      dateTime: dateTime,
      text: text,
    );

    // set my chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uId)
        .collection('chats')
        .doc(receiverID)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      print('Sent================1');
      emit(SendMessageSuccess());
    }).catchError((error) {
      emit(SendMessageError(error.toString()));
    });

    // set receiver chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverID)
        .collection('chats')
        .doc(model!.uId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      print('Sent================2');
      emit(SendMessageSuccess());
    }).catchError((error) {
      emit(SendMessageError(error.toString()));
    });
  }

  List<MessageModel> messages = [];

  void getMessages({required String receiverId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      for (var element in event.docs) {
        messages.add(MessageModel.fromJson(element.data()));
      }
      emit(GetMessagesSuccess());
    });
  }

}
