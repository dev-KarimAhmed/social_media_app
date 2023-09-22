class PostModel {
   String? name, uId, postImage, dateTime, postText , profileImage;

  PostModel(
      {
      required this.name,
       this.postImage,
      required this.dateTime,
      required this.uId,
      required this.postText,
       this.profileImage,
      });

  PostModel.fromJson(Map<String, dynamic>? json) {
    name = json!['name'];
    postImage = json['postImage'];
    dateTime = json['dateTime'];
    uId = json['uId'];
    postText = json['postText'];
    profileImage = json['profileImage'];
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'postImage': postImage,
      'dateTime': dateTime,
      'uId': uId,
      'postText': postText,
      'profileImage': profileImage,
    };
  }
}
