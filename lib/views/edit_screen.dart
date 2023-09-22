import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/cubit/social_media_ui_cubit.dart';

import '../components/check_if_image_null_function.dart';
import '../components/custom_actionBtn.dart';
import '../components/custom_circleAvatr.dart';
import '../components/custom_textFormField.dart';
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
              CustomActionButton(
                onTap: () {
                  AppCubit.get(context).updateUserData(
                    name: nameController.text,
                    bio: bioController.text,
                    phone: phoneController.text,
                  );
                },
                text: 'Update',
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
                                      image: coverImageUploadIfNull(coverImage),
                                    ),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8))),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomCircleAvatar(
                                  icon: Icons.camera_alt_rounded,
                                  onPressed: () {
                                    AppCubit.get(context)
                                        .pickedImageCoverFromGallery();
                                  },
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
                                backgroundImage:
                                    profileImageUploadIfNull(profileImage),
                                radius: 50,
                              ),
                            ),
                            CustomCircleAvatar(
                              icon: Icons.camera_alt_rounded,
                              radius: 15,
                              size: 15,
                              onPressed: () {
                                AppCubit.get(context).pickedImageFromGallery();
                              },
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
                                  SizedBox(
                                    height: 5,
                                  ),
                                  LinearProgressIndicator(),
                                ],
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(
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
                                  child: const Text(
                                    'UPLOAD COVER',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                if (state is UpdateDataLoading) ...[
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const LinearProgressIndicator(),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                    icon: Icons.person,
                    label: 'Name',
                    controller: nameController,
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    icon: Icons.info,
                    label: 'Bio',
                    controller: bioController,
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(
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
