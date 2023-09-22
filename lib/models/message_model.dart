class MessageModel {
   String? senderId, receiverID, dateTime,text ;

  MessageModel(
      {
      required this.senderId,
      required this.receiverID,
      required this.dateTime,
      required this.text,
      });

  MessageModel.fromJson(Map<String, dynamic>? json) {
    senderId = json!['senderId'];
    receiverID = json['receiverID'];
    dateTime = json['dateTime'];
    text = json['text'];
  }
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverID': receiverID,
      'dateTime': dateTime,
      'text': text,
    };
  }
}
