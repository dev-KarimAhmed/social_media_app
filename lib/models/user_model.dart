class UserModel {
  late String name, email, phone, uId, image, bio, cover;
  late bool isEmailVerified;

  UserModel(
      {required this.name,
      required this.email,
      required this.phone,
      required this.uId,
      required this.isEmailVerified,
      required this.image,
      required this.bio,
      required this.cover
      });

  UserModel.fromJson(Map<String, dynamic>? json) {
    name = json!['name'];
    email = json['email'];
    phone = json['phone'];
    uId = json['uId'];
    isEmailVerified = json['isEmailVerified'];
    image = json['image'];
    bio = json['bio'];
    cover = json['cover'];
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'uId': uId,
      'isEmailVerified': isEmailVerified,
      'image': image,
      'bio': bio,
      'cover' : cover
    };
  }
}
