class LoginRequestModel {
  final String email;
  final String password;

  const LoginRequestModel({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
    'email': email.trim(),
    'password': password,
  };
}

class LoginResponseModel {
  final bool success;
  final String? message;
  final String? token;
  final String? userId;
  final String? name;
  final String? email;
  final String? role;
  final Map<String, dynamic> raw;

  const LoginResponseModel({
    required this.success,
    required this.raw,
    this.message,
    this.token,
    this.userId,
    this.name,
    this.email,
    this.role,
  });

  factory LoginResponseModel.fromJson(dynamic json) {
    final raw = json is Map<String, dynamic> ? json : <String, dynamic>{};
    final payload = _payloadMap(raw);
    final nested = _nestedMap(raw);
    final userMap = _firstMap([
      payload['user'],
      payload['data'],
      payload['result'],
      raw['user'],
      raw['data'],
      raw['result'],
      nested['user'],
      nested['data'],
      nested['result'],
    ]);
    final responseData = _firstMap([
      raw['data'],
      nested['data'],
      payload['data'],
      userMap,
    ]);

    return LoginResponseModel(
      success:
          _readBool(raw, ['success', 'status', 'ok']) ??
          _readBool(payload, ['success', 'status', 'ok']) ??
          _readBool(nested, ['success', 'status', 'ok']) ??
          _readBool(responseData, ['success', 'status', 'ok']) ??
          (_readString(responseData, [
                'token',
                'accessToken',
                'access_token',
              ]) !=
              null),
      message:
          _readString(raw, ['message', 'msg']) ??
          _readString(payload, ['message', 'msg']) ??
          _readString(nested, ['message', 'msg']) ??
          _readString(responseData, ['message', 'msg']) ??
          _readString(userMap, ['message', 'msg']),
      token:
          _readString(raw, ['token', 'accessToken', 'access_token']) ??
          _readString(payload, ['token', 'accessToken', 'access_token']) ??
          _readString(nested, ['token', 'accessToken', 'access_token']) ??
          _readString(responseData, ['token', 'accessToken', 'access_token']) ??
          _readString(userMap, ['token', 'accessToken', 'access_token']),
      userId:
          _readString(userMap, ['id', '_id', 'userId']) ??
          _readString(responseData, ['id', '_id', 'userId']) ??
          _readString(raw, ['id', '_id', 'userId']) ??
          _readString(nested, ['id', '_id', 'userId']),
      name:
          _readString(userMap, ['fullName', 'name', 'userName']) ??
          _readString(responseData, ['fullName', 'name', 'userName']) ??
          _readString(raw, ['fullName', 'name', 'userName']),
      email:
          _readString(userMap, ['email']) ??
          _readString(responseData, ['email']) ??
          _readString(raw, ['email']) ??
          _readString(nested, ['email']),
      role:
          _readString(userMap, ['role']) ??
          _readString(responseData, ['role']) ??
          _readString(raw, ['role']) ??
          _readString(nested, ['role']),
      raw: raw,
    );
  }

  bool get hasToken => token != null && token!.isNotEmpty;
}

Map<String, dynamic> _payloadMap(Map<String, dynamic> source) {
  final data = source['data'];
  if (data is Map<String, dynamic>) return data;
  return source;
}

Map<String, dynamic> _nestedMap(Map<String, dynamic> source) {
  final data = source['data'];
  if (data is Map<String, dynamic>) {
    return data;
  }
  final result = source['result'];
  if (result is Map<String, dynamic>) {
    return result;
  }
  return source;
}

Map<String, dynamic> _firstMap(Iterable<dynamic> values) {
  for (final value in values) {
    if (value is Map<String, dynamic>) {
      return value;
    }
  }
  return <String, dynamic>{};
}

String? _readString(Map<String, dynamic>? source, List<String> keys) {
  if (source == null) return null;
  for (final key in keys) {
    final value = source[key];
    if (value == null) continue;
    final text = value.toString().trim();
    if (text.isNotEmpty) return text;
  }
  return null;
}

bool? _readBool(Map<String, dynamic>? source, List<String> keys) {
  if (source == null) return null;
  for (final key in keys) {
    final value = source[key];
    if (value is bool) return value;
    if (value is String) {
      final normalized = value.toLowerCase().trim();
      if (normalized == 'true') return true;
      if (normalized == 'false') return false;
    }
  }
  return null;
}
