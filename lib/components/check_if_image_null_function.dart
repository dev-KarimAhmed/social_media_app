import 'dart:io';

import 'package:flutter/material.dart';

ImageProvider profileImageUploadIfNull(File? profileImage) {
  if (profileImage == null) {
    return const NetworkImage(
        'https://img.freepik.com/premium-vector/man-avatar-icon-flat-illustration-man-avatar-vector-icon-any-web-design_98396-3370.jpg?size=626&ext=jpg');
  } else {
    return FileImage(profileImage);
  }
}

ImageProvider coverImageUploadIfNull(File? coverImage) {
  if (coverImage == null) {
    return const NetworkImage(
        'https://img.freepik.com/free-photo/egypt-collage-concept_23-2150299584.jpg?size=626&ext=jpg');
  } else {
    return FileImage(coverImage);
  }
}

ImageProvider postImageUploadIfNull(File? postImage) {
  if (postImage == null) {
    return const NetworkImage(
        'https://img.freepik.com/free-photo/egypt-collage-concept_23-2150299584.jpg?size=626&ext=jpg');
  } else {
    return FileImage(postImage);
  }
}
