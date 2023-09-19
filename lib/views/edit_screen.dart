import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/cubit/social_media_ui_cubit.dart';

import '../cubit/social_media_ui_state.dart';

class EditProfile extends StatelessWidget {
  EditProfile({super.key});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, SocialMediaUiState>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = AppCubit.get(context).model;
        File? profileImage = AppCubit.get(context).profileImage;
        File? coverImage = AppCubit.get(context).coverImage;
        nameController.text = userModel?.name ?? '';
        bioController.text = userModel?.bio ?? '';
        phoneController.text = userModel?.phone ?? '';
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
            title: Text(
              'Edit Profile',
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  AppCubit.get(context).updateUserData(
                    name: nameController.text,
                    bio: bioController.text,
                    phone: phoneController.text,
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor),
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (state is UpdateDataLoading) ...[
                    LinearProgressIndicator(),
                  ],
                  // if(state is UpdateDataLoading)
                  SizedBox(
                    height: 200,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 160,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: imageCreateCover(coverImage),
                                    ),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8))),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  radius: 20,
                                  child: IconButton(
                                      onPressed: () {
                                        AppCubit.get(context)
                                            .pickedImageCoverFromGallery();
                                      },
                                      icon: Icon(Icons.camera_alt)),
                                ),
                              )
                            ],
                          ),
                        ),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 54,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                backgroundImage: imageCreate(profileImage),
                                radius: 50,
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.blue,
                              radius: 15,
                              child: IconButton(
                                  onPressed: () {
                                    AppCubit.get(context)
                                        .pickedImageFromGallery();
                                  },
                                  icon: Icon(
                                    Icons.camera_alt,
                                    size: 15,
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  if (AppCubit.get(context).profileImage != null ||
                      AppCubit.get(context).coverImage != null) ...[
                    Row(
                      children: [
                        if (AppCubit.get(context).profileImage != null) ...[
                          Expanded(
                            child: Column(
                              children: [
                                MaterialButton(
                                  color: Colors.blue,
                                  onPressed: () {
                                    AppCubit.get(context).uploadProfileImage(
                                      name: nameController.text,
                                      bio: bioController.text,
                                      phone: phoneController.text,
                                    );
                                  },
                                  child: Text(
                                    'UPLOAD PROFILE',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                if (state is UpdateDataLoading) ...[
                                  SizedBox(height: 5,),
                    LinearProgressIndicator(),
                  ],
                              ],
                            ),
                          ),
                        ],
                        SizedBox(
                          width: 5,
                        ),
                        if (AppCubit.get(context).coverImage != null) ...[
                          Expanded(
                            child: Column(
                              children: [
                                MaterialButton(
                                  color: Colors.blue,
                                  onPressed: () {
                                    AppCubit.get(context).uploadCoverImage(
                                      name: nameController.text,
                                      bio: bioController.text,
                                      phone: phoneController.text,
                                    );
                                  },
                                  child: Text(
                                    'UPLOAD COVER',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                           if (state is UpdateDataLoading) ...[
                                  SizedBox(height: 5,),
                    LinearProgressIndicator(),
                  ],
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                  SizedBox(
                    height: 20,
                  ),

                  CustomTextFormField(
                    icon: Icons.person,
                    label: 'Name',
                    controller: nameController,
                    keyboardType: TextInputType.name,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    icon: Icons.info,
                    label: 'Bio',
                    controller: bioController,
                    keyboardType: TextInputType.name,
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    icon: Icons.phone_android,
                    label: 'phone number',
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

ImageProvider imageCreate(File? profileImage) {
  if (profileImage == null) {
    return NetworkImage(
        'https://img.freepik.com/free-photo/shark-sea_181624-17254.jpg?size=626&ext=jpg');
  } else {
    return FileImage(profileImage);
  }
}

ImageProvider imageCreateCover(File? coverImage) {
  if (coverImage == null) {
    return NetworkImage(
        'https://img.freepik.com/premium-photo/sea-turtle-swims-along-coral-reefs-underwater-world-bali_508256-21.jpg?size=626&ext=jpg');
  } else {
    return FileImage(coverImage);
  }
}

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.label,
    required this.icon,
    this.controller,
    this.keyboardType,
  });
  final String label;
  final IconData icon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        } else {
          return null;
        }
      },
      keyboardType: keyboardType,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        label: Text(label),
        prefixIcon: Icon(icon),
      ),
    );
  }
}
