import 'dart:convert';

class JoinMeetingParams {
  final String webinarToken;
  final String displayName;
  final String email;
  final String password;
  final String meetingNo;
  JoinMeetingParams({
    required this.webinarToken,
    required this.displayName,
    required this.email,
    required this.password,
    required this.meetingNo,
  });

  JoinMeetingParams copyWith({
    String? webinarToken,
    String? displayName,
    String? email,
    String? password,
    String? meetingNo,
  }) {
    return JoinMeetingParams(
      webinarToken: webinarToken ?? this.webinarToken,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      password: password ?? this.password,
      meetingNo: meetingNo ?? this.meetingNo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'webinarToken': webinarToken,
      'displayName': displayName,
      'email': email,
      'password': password,
      'meetingNo': meetingNo,
    };
  }

  factory JoinMeetingParams.fromMap(Map<String, dynamic> map) {
    return JoinMeetingParams(
      webinarToken: map['webinarToken'] ?? '',
      displayName: map['displayName'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      meetingNo: map['meetingNo'] ?? '',
    );
  }
}
