class UserData {
  String token;
  int userId;

  UserData({required this.token, required this.userId});
  static List<UserData> parseUserList(map) {
    var list = map['data'] as List;
    return list.map((user) => UserData.fromJson(user)).toList();
  }

  factory UserData.fromJson(Map<String, dynamic> map) {
    return UserData(
      token: map['token'].toString(),
      userId: map['userId'],
    );
  }
  Map<String, dynamic> toJson() => {"token": token, "userId": userId};
  @override
  String toString() {
    return 'UserData{token: $token, userId: $userId}';
  }
}
