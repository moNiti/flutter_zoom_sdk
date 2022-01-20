import 'dart:async';

import 'package:flutter/services.dart';

import 'model/init_params.dart';
import 'model/join_meeting_params.dart';

class FlutterZoomSdk {
  static const MethodChannel _channel = MethodChannel('flutter_zoom_sdk');
  static const EventChannel _eventChannel =
      EventChannel('flutter_zoom_sdk_event_stream');

  static Future<dynamic> initZoom(InitParams initParams) async {
    return await _channel.invokeMethod('init', initParams.toMap());
  }

  static Future<bool> joinMeeting(JoinMeetingParams joinParams) async {
    return _channel
        .invokeMethod<bool>('join', joinParams.toMap())
        .then<bool>((bool? value) => value ?? false);
  }

  static Stream<dynamic> onMeetingStatus() {
    return _eventChannel.receiveBroadcastStream();
  }
}
