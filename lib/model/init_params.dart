class InitParams {
  final String domain;
  final String appKey;
  final String appSecret;
  InitParams({
    required this.domain,
    required this.appKey,
    required this.appSecret,
  });

  InitParams copyWith({
    String? domain,
    String? appKey,
    String? appSecret,
  }) {
    return InitParams(
      domain: domain ?? this.domain,
      appKey: appKey ?? this.appKey,
      appSecret: appSecret ?? this.appSecret,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'domain': domain,
      'appKey': appKey,
      'appSecret': appSecret,
    };
  }

  factory InitParams.fromMap(Map<String, dynamic> map) {
    return InitParams(
      domain: map['domain'] ?? '',
      appKey: map['appKey'] ?? '',
      appSecret: map['appSecret'] ?? '',
    );
  }
  @override
  String toString() =>
      'InitParams(domain: $domain, appKey: $appKey, appSecret: $appSecret)';
}
