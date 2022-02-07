import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'model/init_params.dart';
import 'model/join_meeting_params.dart';

class FlutterZoomSdk {
  static final FlutterZoomSdk _flutterZoomSdk = FlutterZoomSdk._internal();

  factory FlutterZoomSdk() {
    return _flutterZoomSdk;
  }
  FlutterZoomSdk._internal() {
    _channel = MethodChannel('flutter_zoom_sdk');
    _eventChannel = EventChannel('flutter_zoom_sdk_event_stream');
  }
  late MethodChannel _channel;
  late EventChannel _eventChannel;

  String? _voteUrl;
  String? get voteUrl => _voteUrl;
  set setVoteUrl(String? url) {
    _voteUrl = url;
  }

  // static const MethodChannel _channel = MethodChannel('flutter_zoom_sdk')
  //   ..setMethodCallHandler((call) => null);
  // static const EventChannel _eventChannel =
  //     EventChannel('flutter_zoom_sdk_event_stream');

  Future<dynamic> initZoom(InitParams initParams) async {
    _channel.setMethodCallHandler(methodHandler);
    return await _channel.invokeMethod('init', initParams.toMap());
  }

  Future<bool> joinMeeting(JoinMeetingParams joinParams) async {
    return _channel
        .invokeMethod<bool>('join', joinParams.toMap())
        .then<bool>((bool? value) => value ?? false);
  }

  Stream<dynamic> onMeetingStatus() {
    return _eventChannel.receiveBroadcastStream();
  }

  Future<dynamic> methodHandler(MethodCall call) async {
    print('======>SET METHOD CALL HANDLER');
    switch (call.method) {
      case "get_vote_url":
        return voteUrl;
      default:
        return MissingPluginException();
    }
  }
}
